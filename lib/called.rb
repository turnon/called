require "called/version"
require "set"

class Called

  def self.on obj, path={}
    new obj, path[:log]
  end

  def initialize obj, path
    @obj = obj
    @file = LogFile.new path
  end

  def method_missing meth, *arg, &blk
    @file.puts Record.new meth, ::Kernel.caller[0]
    @obj.send meth, *arg, &blk
  end

  Record = ::Struct.new :method_name, :called_from do
    def hash
      [method_name, called_from].hash
    end

    def eql? record
      method_name == record.method_name &&
        called_from == record.called_from
    end
  end

  class LogFile
    def initialize path
      @lock = Mutex.new
      @set = Set.new
      @path = path
    end

    def puts record
      @lock.synchronize do
        @set << record
        File.open @path, 'w' do |f|
          f.puts format @set
        end
      end
    end

    def format set
      records= set.to_a
      max_len = records.
        max{|rec| rec.method_name.length}.
        method_name.
        length + 1
      records.map do |rec|
        formatted = "%#{max_len}s" % rec.method_name
        "#{formatted} | #{rec.called_from}"
      end.join "\n"
    end
  end

end
