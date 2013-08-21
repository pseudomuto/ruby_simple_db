require "test_helper"

class TestDatabase < MiniTest::Unit::TestCase
  def setup
    @database = SimpleDb::Database.new
  end

  def test_get_value_returns_nil_when_not_found
    assert_nil @database.get_value("a")
  end

  def test_get_value_returns_stored_value
    @database.set_value("name", :value)
    assert_equal :value, @database.get_value("name")
  end

  def test_set_value_overwites_existing_value
    @database.set_value("name", :value)
    @database.set_value("name", :new_value)
    assert_equal :new_value, @database.get_value("name")
  end

  def test_unset_value_sets_value_to_nil
    @database.set_value("name", :value)
    @database.unset_value("name")
    assert_nil @database.get_value("name")
  end

  def test_unset_value_is_cool_when_the_key_is_not_found
    @database.unset_value("key not found")
  end

  def test_num_equal_to_returns_key_count_for_value
    @database.set_value("name", :key_value)
    @database.set_value("number", :key_value)
    @database.set_value("email", :key_value)

    assert_equal 3, @database.num_equal_to(:key_value)
  end
end