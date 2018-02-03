require "helper"
require "fluent/plugin/filter_onekeyparse.rb"

class OnekeyparseFilterTest < Test::Unit::TestCase
  setup do
    Fluent::Test.setup
  end

  test "failure" do
    flunk
  end

  private

  def create_driver(conf)
    Fluent::Test::Driver::Filter.new(Fluent::Plugin::OnekeyparseFilter).configure(conf)
  end
end
