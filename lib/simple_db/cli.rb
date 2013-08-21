require "simple_db/database"

module SimpleDb
  module CLI

    def self.included(instance)
      instance.class_exec do
        def database
          @database ||= Database.new
        end
      end
    end

    def get(key)
      value = database.get_value(key)
      puts value || "NULL"
    end

    def set(key, value)
      database.set_value(key, value)
    end

    def unset(key)
      database.unset_value(key)
    end

    def num_equal_to(value)
      puts database.num_equal_to(value)
    end
  end
end