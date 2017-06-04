require "json"
require "erb"

class Called < BasicObject
  VERSION = "0.1.1"

  def self.on obj, path={}
    new obj, path[:log]
  end

  def initialize obj, path
    @obj = obj
    @file = LogFile.new path
  end

  def method_missing method_id, *args, &block
    log_and_call method_id, *args, &block
  end

  ::Module.instance_method(:instance_methods).bind(BasicObject).call.each do |method_id|
    define_method method_id do |*args, &block|
      log_and_call method_id, *args, &block
    end
  end

  private

  def log_and_call method_id, *args, &block
    record = {thread: ::Thread.current.object_id, method: method_id, stack: ::Kernel.caller[1..-1]}
    @file.puts record
    @obj.send method_id, *args, &block
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
          json = @set.to_json
          str = template.result binding
          f.puts str
        end
      end
    end

    def template
      return @tmpl if defined? @tmpl
      tmpl = File.expand_path('../called/tmpl.html.erb', __FILE__)
      @tmpl = ::ERB.new File.read tmpl
    end
  end

end
