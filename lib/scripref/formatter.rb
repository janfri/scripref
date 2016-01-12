# - encoding: utf-8 -

module Scripref

  class Formatter

    attr_accessor :cv_separator, :hyphen_separator, :pass_separator


    # @param mods one or more modules to include
    def initialize *mods
      @mods = mods
      mods.each {|m| extend m}
    end

    # Formats a reference (array of passages)
    def format *reference
      @last_b = @last_c = @last_v = :undefined
      @result = ''
      reference.flatten.each do |pass|
        @pass = pass
        process_passage
      end
      @result
    end

    def format_book num
      Array(book_names[num - 1]).first
    end

    private

    def process_passage
      @changed = false
      process_b1
    end

    def process_b1
      b1 = @pass.b1
      if @last_b != b1
        @result << format_book(b1)
        @last_b = b1
        @changed = true
      end
      process_c1
    end

    def process_c1
      c1 = @pass.c1
      if c1 && (@changed || @last_c != c1)
        @result << ' '
        if ! book_has_only_one_chapter?(@pass.b1)
          @result << c1.to_s
        end
        @last_c = c1
        @changed = true
      end
      process_v1
    end

    def process_v1
      v1 = @pass.v1
      if v1 && (@changed || @last_v != v1)
        if ! book_has_only_one_chapter?(@pass.b1)
          @result << cv_separator
        end
        @result << v1.to_s
        @last_v = v1
        process_a1
      end
      process_b2
    end

    def process_a1
      a1 = @pass.a1
      @result << a1.to_s if a1
    end

    def process_b2
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
      process_c2
    end

    def process_c2
      c2 = @pass.c2
      if c2 && (@changed || @last_c != c2)
        if @hyphen
          @result << ' '
        else
          @result << hyphen_separator
          @hyphen = true
        end
        if ! book_has_only_one_chapter?(@pass.b2)
          @result << c2.to_s
        end
        @last_c = c2
        @changed = true
      end
      process_v2
    end

    def process_v2
      v2 = @pass.v2
      if v2 && (@changed || @last_v != v2)
        if @hyphen
          if ! book_has_only_one_chapter?(@pass.b2)
            @result << cv_separator
          end
        else
          @result << hyphen_separator
          @hyphen = true
        end
        @result << v2.to_s
        @last_v = @v2
        @changed = true
        process_a2
      end
    end

    def process_a2
      a2 = @pass.a2
      @result << a2.to_s if a2
    end

    alias << format

  end

end
