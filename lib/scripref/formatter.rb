# - encoding: utf-8 -

module Scripref

  class Formatter

    # @param mods one or more modules to include
    def initialize *mods
      @mods = mods
      mods.each do |m|
        m.class_eval do
          extend ConstReader
          const_accessor constants
        end
        extend m
      end
    end

    # Formats a reference (array of passages)
    def format *reference
      last_b = last_c = last_v = nil
      pass_texts = reference.flatten.map do |pass|
        changed = false
        s = ''
        if changed || last_b != pass.b1
          s << book_names[pass.b1 - 1]
          last_b = pass.b1
          changed = true
        end
        if changed || last_c != pass.c1
          s << ' '
          if ! Scripref.book_has_only_one_chapter?(pass.b1)
            s << pass.c1.to_s
          end
          last_c = pass.c1
          changed = true
        end
        if changed || last_v != pass.v1
          if ! Scripref.book_has_only_one_chapter?(pass.b1)
            s << cv_separator
          end
          s << pass.v1.to_s
          last_v = pass.v1
          changed = true
        end
        # second part
        changed = false
        a2 = []
        if changed || last_b != pass.b2
          a2 << book_names[pass.b2 - 1]
          last_b = pass.b2
          changed = true
        end
        if changed || last_c != pass.c2
          a2 << ' ' if pass.b1 != pass.b2
          if ! Scripref.book_has_only_one_chapter?(pass.b2)
            a2 << pass.c2.to_s
            a2 << cv_separator
          end
          last_c = pass.c2
          changed = true
        end
        if changed || last_v != pass.v2
          a2 << pass.v2.to_s
          last_v = pass.v2
          changed = true
        end
        if ! a2.empty?
          s << hyphen_separator
          s << a2.join('')
        end
        s
      end
      pass_texts.join(pass_separator)
    end

  end

end
