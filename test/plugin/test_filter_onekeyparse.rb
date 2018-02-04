require "helper"
require "fluent/plugin/filter_onekeyparse.rb"

class OnekeyparseFilterTest < Test::Unit::TestCase
  setup do
    Fluent::Test.setup
    @time = Fluent::Engine.now
  end

  private

  def create_driver(conf)
    Fluent::Test::Driver::Filter.new(Fluent::Plugin::OnekeyparseFilter).configure(conf)
  end
  
  CONFIG = %[
    in_format ^(?<val1>[^ ]*) (?<val2>[^ ]*) (?<val3>[^ ]*)$
    in_key key1
    out_record_keys val1,val2,val3
    out_record_types string,string,string
  ]

  sub_test_case "configure" do
    test "check config" do
      d = create_driver CONFIG
      assert_equal '^(?<val1>[^ ]*) (?<val2>[^ ]*) (?<val3>[^ ]*)$', d.instance.config['in_format']
      assert_equal 'key1', d.instance.config['in_key']
      assert_equal 'val1,val2,val3', d.instance.config['out_record_keys']
      assert_equal 'string,string,string', d.instance.config['out_record_types']
    end
  end


  def filter(config, messages)
    d = create_driver(config)
    yield d if block_given?
    d.run(default_tag: "input.access") {
      messages.each {|message|
        d.feed(@time, message)
      }
    }
    d.filtered_records
  end

  sub_test_case "filter" do
    test "check filter" do
      messages = [
        {'key1' => 'test1 test2 test3', 'key2' => 'hoge'}
      ]
      expected = [
        {
          'val1' => 'test1',
          'val2' => 'test2',
          'val3' => 'test3',
        }
      ]
      filtered = filter(CONFIG, messages)
      assert_equal(expected, filtered)
    end
  end
end