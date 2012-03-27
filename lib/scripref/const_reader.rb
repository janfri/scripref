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
#  class C
#    include M
#  end
#  c = C.new
#  c.a # => :a
#  c.b # => :b
module ConstReader
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
