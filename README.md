# Called

Just to log down what methods are called and from where

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'called'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install called

## Usage

In test case:

```ruby
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

# output:
# 1
# 3
# 4
# 1
# 3
# 4
```

Result:

```
$ cat /tmp/called_test.txt
   push | /home/z/called/test/called_test.rb:12:in `block in test_it_does_something_useful'
   push | /home/z/called/test/called_test.rb:13:in `block in test_it_does_something_useful'
    pop | /home/z/called/test/called_test.rb:14:in `block in test_it_does_something_useful'
   push | /home/z/called/test/called_test.rb:15:in `block in test_it_does_something_useful'
   push | /home/z/called/test/called_test.rb:16:in `block in test_it_does_something_useful'
  shift | /home/z/called/test/called_test.rb:17:in `block in test_it_does_something_useful'
      + | /home/z/called/test/called_test.rb:18:in `block in test_it_does_something_useful'
 to_ary | /home/z/called/lib/called.rb:17:in `+'
```
