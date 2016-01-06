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
      @last_b = @last_c = @last_v = :undefined
      @result = ''
      reference.flatten.each do |pass|
        @pass = pass
        format_passage
      end
      @result
    end

    def format_passage
      @changed = false
      format_b1
    end

    def format_book num
      Array(book_names[num - 1]).first
    end

    def format_b1
      b1 = @pass.b1
      if @last_b != b1
        @result << format_book(b1)
        @last_b = b1
        @changed = true
      end
      format_c1
    end

    def format_c1
      c1 = @pass.c1
      if c1 && (@changed || @last_c != c1)
        @result << ' '
        if ! Scripref.book_has_only_one_chapter?(@pass.b1)
          @result << c1.to_s
        end
        @last_c = c1
        @changed = true
      end
      format_v1
    end

    def format_v1
      v1 = @pass.v1
      if v1 && (@changed || @last_v != v1)
        if ! Scripref.book_has_only_one_chapter?(@pass.b1)
          @result << cv_separator
        end
        @result << v1.to_s
        @last_v = v1
      end
      format_b2
    end

    def format_b2
      @changed = false
      @hyphen = false
      b2 = @pass.b2
      if b2 && (@changed || @last_b != b2)
        @result << hyphen_separator
        @result << format_book(b2)
        @last_b = b2
        @changed = true
        @hyphen = true
      end
      format_c2
    end

    def format_c2
      c2 = @pass.c2
      if c2 && (@changed || @last_c != c2)
        if @hyphen
          @result << ' '
        else
          @result << hyphen_separator
          @hyphen = true
        end
        if ! Scripref.book_has_only_one_chapter?(@pass.b2)
          @result << c2.to_s
        end
        @last_c = c2
        @changed = true
      end
      format_v2
    end

    def format_v2
      v2 = @pass.v2
      if v2 && (@changed || @last_v != v2)
        if @hyphen
          if ! Scripref.book_has_only_one_chapter?(@pass.b2)
            @result << cv_separator
          end
        else
          @result << hyphen_separator
          @hyphen = true
        end
        @result << v2.to_s
        @last_v = @v2
        @changed = true
      end
    end

    alias << format

  end

end
