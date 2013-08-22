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

  def output_is?(value)
    @output.string.chomp == value
  end

  def test_cli_set_value_does_not_print_anything
    @cli.set("key", :value)
    assert @output.string.empty?
  end

  def test_cli_get_value_prints_NULL_when_not_found
    @cli.get("key not found")
    assert output_is?("NULL")
  end

  def test_cli_get_value_prints_value_when_found
    @cli.set("key", :value)
    @cli.get("key")
    assert output_is?("value")
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

    assert output_is?("2")
  end

  def test_begin_opens_a_new_transaction
    @cli.begin
    assert_equal 2, @cli.__send__(:databases).size
  end

  def test_begin_plays_nice_with_get
    @cli.set("key", 10)
    @cli.begin
    @cli.set("key", 20)
    @cli.get("key")

    assert output_is?("20")
  end

  def test_begin_plays_nice_with_unset
    @cli.set("key", 10)
    @cli.begin
    @cli.unset("key")
    @cli.get("key")

    assert output_is?("NULL")

    @cli.rollback
    @cli.get("key")

    assert @output.string.chomp.end_with?("10")
  end

  def test_rollback_prints_warning_when_no_transaction_exists
    @cli.rollback
    assert output_is?("NO TRANSACTION")
  end

  def test_rollback_discards_pending_changes
    @cli.set("key", 10)
    @cli.begin
    @cli.set("key", 20)
    @cli.rollback
    @cli.get("key")

    assert output_is?("10")
  end

  def test_commit_prints_warning_when_no_transaction_exists
    @cli.commit
    assert output_is?("NO TRANSACTION")
  end

  def test_commit_commits_all_changes
    @cli.set("a", 50)
    
    @cli.begin
    @cli.get("a")
    @cli.set("a", 60)

    @cli.begin
    @cli.unset("a")
    @cli.get("a")
    @cli.rollback

    @cli.get("a")
    @cli.commit
    @cli.get("a")

    expected = [ "50", "NULL", "60", "60", "NO TRANSACTION" ]
    lines = @output.string.chomp.lines.to_a

    0.upto(lines.size - 1) do |index|
      assert_equal expected[index], lines[index].chomp
    end
  end

end