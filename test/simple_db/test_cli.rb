require "test_helper"
require "stringio"

class MockCLI 
  include SimpleDb::CLI
end

class TestCLI < MiniTest::Unit::TestCase
  def setup
    @output = StringIO.new
    $stdout = @output
    @cli = MockCLI.new
  end

  def teardown
    # restore...just in case
    $stdout = STDOUT
  end

  def test_cli_set_value_does_not_print_anything
    @cli.set("key", :value)
    assert @output.string.empty?
  end

  def test_cli_get_value_prints_NULL_when_not_found
    @cli.get("key not found")
    assert_equal "NULL", @output.string.chomp
  end

  def test_cli_get_value_prints_value_when_found
    @cli.set("key", :value)
    @cli.get("key")
    assert_equal "value", @output.string.chomp
  end

  def test_cli_unset_does_not_print_anything
    @cli.set("key", :value)
    @cli.unset("key")
    assert @output.string.empty?
  end

  def test_num_equal_to_prints_count
    @cli.set("key", :value)
    @cli.set("other_key", :value)
    @cli.num_equal_to(:value)

    assert_equal "2", @output.string.chomp
  end

end