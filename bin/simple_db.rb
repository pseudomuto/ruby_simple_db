$: << File.expand_path("../../lib", __FILE__)
require "simple_db"

class SimpleDatabase
  include SimpleDb::CLI

  VALID_METHODS = [ :GET, :SET, :UNSET, :NUMEQUALTO ]
  alias_method :numequalto, :num_equal_to

  def initialize
    while true
      input = gets.chomp.split
      command = input.shift
      __send__(command, input)
    end
  end

  def method_missing(method_name, *args)
    if VALID_METHODS.include?(method_name)
      __send__(method_name.downcase, *args[0])
    elsif method_name == :END
      exit
    else
      # play nice...
      super
    end
  end
end

SimpleDatabase.new