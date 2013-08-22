module SimpleDb
  # Public: A simple storage system that supports get, set, unset and 
  # num equal to operations
  #
  # Examples
  #
  #     db = SimpleDb::Database.new
  #     db.set_value("key", :value)
  #     puts db.get_value("key")
  #      
  #     #=> value
  class Database

    # Public: Retrieves the specified key from the data store. If they key 
    # is not found, nil will be returned.
    #
    # key - the key to get the value for
    #
    # Examples:
    #
    #     db_instance.get_value("key")
    #
    # Returns the value for the specified key or nil
    def get_value(key)
      database[key]
    end

    # Public: Stores the key/value pair in the database. The value will be 
    # overwritten if the key already exists.
    #
    # key - the key to store the value for
    # value - the value to store
    #
    # Examples:
    #
    #     db_instance.set_value("key", "my_special_value")
    #
    def set_value(key, value)
      database[key] = value
      removed_keys.delete(key)
    end

    # Public: Removes the key from the data store. It's ok to call this 
    # method passing non-existent keys.
    #
    # key - the key to remove from the data store
    #
    # Examples:
    #
    #     db_instance.unset_value("key")
    #
    def unset_value(key)
      database.delete(key)
      removed_keys << key
    end

    # Public: Counts the number of keys that have the specified value
    #
    # value - the value to look for
    #
    # Examples:
    #
    #     db_instance.set_value("key", :value)
    #     puts db_instance.num_equal_to(:value)
    #
    #     #=> 1
    #
    # Returns the number of keys with the specified value
    def num_equal_to(value)
      database.select { |k,v| v == value }.size
    end

    # Public: A collection of keys that have been unset. Keys are added when
    # unset_value is called and removed when set_value is call. This collection
    # should not be modified directly.
    #
    # Examples:
    #
    #     db_instance.unset_value("key")
    #     db_instance.unset_value("other_key")
    #     puts db_instance.removed_keys.to_s
    #
    #     #=> ["key", "other_key"]
    #
    # Returns the keys that have been unset
    def removed_keys
      @removed_keys ||= []
    end

    # Public: Merges other_database into this one. Matching keys will get 
    # their value from other_database. All keys found in the other database's
    # removed_keys collection will be removed from this one
    #
    # other_database - the database to merge with this one
    #
    # Examples:
    #
    #     db_instance.set_value("key", 10)
    #     db_instance.set_value("other_key", 20)
    #
    #     other_db.set_value("key", 30)
    #     other_db.unset_value("other_key")
    #
    #     db_instance.merge!(other_db)
    #     puts db_instance.get_value("key")
    #     #=> 30
    #     puts db_instance.get_value("other_key")
    #     #=> NULL
    #
    def merge!(other_database)
      database.merge!(other_database.__send__(:database))
      other_database.removed_keys.each { |key| unset_value(key) }
    end

    private

    def database
      @db ||= {}
    end
  end
end