require 'test_helper'

class CalledTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Called::VERSION
  end

  def setup
    @lock = Mutex.new
  end

  def test_it_does_something_useful
    arr = []

    c = Called.on arr, log: '/tmp/called_test.txt'
    threads = 3.times.map do
      Thread.new do
        rand_lock { c.push 1 }
        rand_lock { c.push 2 }
        rand_lock { c.push 3 }
        rand_lock { c.push 4 }
        rand_lock { c + c    }
      end
    end
    threads.each &:join

    puts arr
  end

  def rand_lock
    @lock.synchronize do
      yield
    end
    sleep rand 3
  end
end
