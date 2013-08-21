module SimpleDb
  class Database

    def initialize
      @db = { }
    end

    def get_value(key)
      @db[key]
    end

    def set_value(key, value)
      @db[key] = value
    end

    def unset_value(key)
      @db.delete(key)
    end

    def num_equal_to(value)
      @db.select { |k,v| v == value }.size
    end
  end
end