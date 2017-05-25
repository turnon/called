require "called/version"
require "json"

class Called

  def self.on obj, path={}
    new obj, path[:log]
  end

  def initialize obj, path
    @obj = obj
    @file = LogFile.new path
  end

  def method_missing meth, *arg, &blk
    record = {method: meth, stack: ::Kernel.caller, thread: Thread.current.object_id}
    @file.puts record
    @obj.send meth, *arg, &blk
  end

  class LogFile
    def initialize path
      @lock = Mutex.new
      @set = []
      @path = path
    end

    def puts record
      @lock.synchronize do
        @set << record
        File.open @path, 'w' do |f|
          f.puts @set.to_json
        end
      end
    end
  end

end
