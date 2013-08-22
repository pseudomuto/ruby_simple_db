require "simple_db/database"

module SimpleDb
  module CLI

    def self.included(instance)
      instance.class_exec do
        def databases
          @databases ||= [ Database.new ]
        end

        private :databases
      end
    end

    def get(key)
      value = nil
      (databases.size - 1).downto(0) do |index|
        break if databases[index].removed_keys.include?(key)

        value = @databases[index].get_value(key)
        break if value
      end

      puts value || "NULL"
    end

    def set(key, value)
      current_db.set_value(key, value)
    end

    def unset(key)
      current_db.unset_value(key)
    end

    def num_equal_to(value)
      puts current_db.num_equal_to(value)
    end

    def begin
      databases.push(Database.new)
    end

    def rollback
      if not has_transaction?
        print_transaction_warning
      else
        databases.pop
      end
    end

    def commit
      if not has_transaction?
        print_transaction_warning
      else
        1.upto(databases.size - 1) do |index|
          databases[0].merge!(databases[index])
        end

        databases.pop while databases.size > 1
      end
    end

    private 

    def print_transaction_warning
      puts "NO TRANSACTION"
    end

    def current_db
      databases.last
    end

    def has_transaction?
      databases.size > 1
    end
  end
end