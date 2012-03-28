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
          self.singleton_class.const_get c_name
        end
      end
    end
  end

end
