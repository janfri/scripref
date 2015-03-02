# - encoding: utf-8 -

module Scripref

  class Formatter

    # @param mods one or more modules to include
    def initialize *mods
      @mods = mods
      mods.each do |m|
        m.class_eval do
          extend ConstReader
          const_reader constants
        end
        extend m
      end
    end

    # Formats a reference (array of passages) with full
    # book names (i.e. Hebrews 3:8)
    def fullref *reference
      last_b = last_c = last_v = nil
      pass_texts = reference.flatten.map do |pass|
        s = ''
        unless last_b == pass.b1
          s << book_names[pass.b1 - 1]
          last_b = pass.b1
        end
        unless last_c == pass.c1
          s << ' ' << pass.c1.to_s
          last_c = pass.c1
        end
        unless last_v == pass.v1
          s << cv_separator << pass.v1.to_s
          last_v = pass.v1
        end
        # second part
        a2 = []
        unless last_v == pass.v2
          a2 << pass.v2.to_s
          last_v = pass.v2
        end
        unless last_c == pass.c2
          a2 << cv_separator
          a2 << pass.c2.to_s
          last_c = pass.c2
        end
        unless last_b == pass.b2
          a2 << ' ' << book_names[pass.b2 - 1]
          last_b = pass.b2
        end
        if ! a2.empty?
          s << hyphen_separator
          s << a2.reverse.join('')
        end
        s
      end
      pass_texts.join(pass_separator)
    end

  end

end
