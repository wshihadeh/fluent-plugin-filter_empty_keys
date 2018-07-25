require_relative 'helper'
require 'fluent/plugin/filter_empty_keys'

class TypecastFilterTest < Test::Unit::TestCase
  include Fluent

  setup do
    Fluent::Test.setup
    @time = Fluent::Engine.now
  end

  def create_driver(conf = '')
    Test::FilterTestDriver.new(EmptyKeysFilter).configure(conf, true)
  end

  def filter(d, msgs)
    d.run {
      msgs.each {|msg|
        d.filter(msg, @time)
      }
    }
    d.filtered_as_array
  end

  test 'test_empty_keys' do
    d = create_driver(%[
        empty_keys Undefined:Undefined,Remove:1
      ])
    msg = {
      'integer'   => 1,
      'nil'       => nil,
      'time'      => '2013-02-12 22:01:15 UTC',
      'bool'      => 'true',
      'array'     => 'a,b,c',
      'empty'     => '',
      'Undefined' => 'Undefined',
      'Remove'    => 1,
    }
    filtered = filter(d, [msg]).first[2]
    assert_equal 4, filtered.count
    assert_equal true,  filtered.key?("integer")
    assert_equal false, filtered.key?("nil")
    assert_equal true,  filtered.key?("time")
    assert_equal true,  filtered.key?("bool")
    assert_equal true,  filtered.key?("array")
    assert_equal false, filtered.key?("empty")
    assert_equal false, filtered.key?("Undefined")
    assert_equal false, filtered.key?("Remove")
  end
end
