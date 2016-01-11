# - encoding: utf-8 -

# Mixin to generate instance methods to access of mixin constants.
#
# Example:
#  module M
#    A = :a
#    B = :b
#    extend ConstReader
#    const_reader constants
#  end
#
#  # Include in class
#  class C
#    include M
#  end
#  c = C.new
#  c.a # => :a
#  c.b # => :b
#
#  # Extend an instance
#  o = Object.new
#  o.extend M
#  o.a # => :a
#  o.b # => :b
module ConstReader

  # Define a getter method for one or more constants.
  #
  # Example:
  #   # all defined constants
  #   const_reader constants
  #
  #   # constants A and B
  #   const_reader :A, :B
  def const_reader *consts
    consts.flatten.each do |c|
      class_exec(c.to_s, c.to_s.downcase) do |c_name, m_name|
        define_method m_name do
          ivar = '@' << m_name
          if instance_variable_defined? ivar
            return instance_variable_get(ivar)
          else
            val = self.singleton_class.const_get c_name
            instance_variable_set ivar, val
            return val
          end
        end
      end
    end
  end

  # Define a getter and a setter method for one or more constant values.
  # The value of the constant itself is not changed, instead
  # a corresponding instance variable is used.
  #
  # Example:
  #   module M
  #     A = :ma
  #     extend ConstReader
  #     const_accessor :A
  #   end
  #   class C
  #     include M
  #   end
  #   c1 = C.new
  #   c1.a # => :ma
  #   c1.a = :ca
  #   c1.a # => :ca
  #   c2 = C.new
  #   c2.a # => :ma
  def const_accessor *consts
    consts.flatten.each do |c|
      class_exec(c.to_s, c.to_s.downcase) do |c_name, m_name|
        define_method m_name do
          ivar = '@' << m_name
          if instance_variable_defined? ivar
            return instance_variable_get(ivar)
          else
            val = self.singleton_class.const_get c_name
            instance_variable_set ivar, val
            return val
          end
        end
        attr_writer m_name
      end
    end
  end
end
