require 'test_helper'

class CalledTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Called::VERSION
  end

  def test_it_does_something_useful
    arr = []
    c = Called.on arr, log: '/tmp/called_test.txt'
    3.times do
      c.push 1
      c.push 2
      c.pop
      c.push 3
      c.push 4
      c.shift
      c + c
    end
    puts arr
  end
end
