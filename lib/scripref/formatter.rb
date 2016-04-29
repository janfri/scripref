# - encoding: utf-8 -

module Scripref

  class Formatter

    attr_accessor :bookformat, :cv_separator, :hyphen_separator, :pass_separator

    # @param mods one or more modules to include
    # @param bookformat (:short use abbreviations, :long use full names of books)
    def initialize *mods, bookformat: :name
      @mods = mods
      mods.each {|m| extend m}
      @bookformat = bookformat
    end

    # Formats a reference (array of passages and maybe separators)
    def format *reference
      @last_b = @last_c = @last_v = :undefined
      @result = []
      reference.flatten.each do |entry|
        next if entry.kind_of? Sep
        @pass = entry
        process_passage
      end
      @result.join
    end

    # Formats a book
    # @param num number of book (starting at 1)
    def format_book num
      book_names[num - 1].send @bookformat
    end

    # Formats a chapter
    # @param num number of chapter
    def format_chapter num
      num.to_s
    end

    # Formats a verse
    # @param num number of verse
    def format_verse num
      num.to_s
    end

    # Formats a verse addon
    def format_addon a
      a.to_s
    end

    # Formats a verse postfix
    def format_postfix p
      p.to_s
    end

    private

    def last_token
      @result.last
    end

    def process_passage
      @changed = false
      process_b1
    end

    def process_b1
      b1 = @pass.b1
      if @last_b != b1
        case last_token
        when Token
          push_sep pass_separator
        end
        push_book b1
        @last_b = b1
        @changed = true
      end
      process_c1
    end

    def process_c1
      c1 = @pass.c1
      if c1 && (@changed || @last_c != c1)
        if ! book_has_only_one_chapter?(@pass.b1)
          case last_token
          when Book
            push_space
          when Token
            push_sep pass_separator
          end
          push_chapter c1
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
          case last_token
          when Verse
            push_sep verse_separator
          when Token
            push_sep cv_separator
          end
        else
          push_space
        end
        push_verse v1
        @last_v = v1
        process_a1
      end
      process_b2
    end

    def process_a1
      a1 = @pass.a1
      push_addon a1
    end

    def process_b2
      @changed = false
      @hyphen = false
      b2 = @pass.b2
      if b2 && (@changed || @last_b != b2)
        push_sep hyphen_separator
        push_book(b2)
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
          push_space
        else
          push_sep hyphen_separator
          @hyphen = true
        end
        if ! book_has_only_one_chapter?(@pass.b2)
          push_chapter c2
        end
        @last_c = c2
        @changed = true
      end
      process_v2
    end

    def process_v2
      v2 = @pass.v2
      case v2
      when :f
        push_postfix postfix_one_following_verse
        return
      when :ff
        push_postfix postfix_more_following_verses
        return
      end
      if v2 && (@changed || @last_v != v2)
        if @hyphen
          if ! book_has_only_one_chapter?(@pass.b2)
            push_sep cv_separator
          end
        else
          push_sep hyphen_separator
          @hyphen = true
        end
        push_verse v2
        @last_v = @v2
        @changed = true
        process_a2
      end
    end

    def process_a2
      a2 = @pass.a2
      push_addon a2
    end

    def push_book b
      @result << Book.new(format_book(b))
    end

    def push_chapter c
      @result << Chapter.new(format_chapter(c))
    end

    def push_verse v
      @result << Verse.new(format_verse(v))
    end

    def push_addon a
      if a
        @result << Addon.new(format_addon(a))
      end
    end

    def push_postfix p
      @result << Postfix.new(format_postfix(p))
    end

    def push_space
      @result << Space.new(' ')
    end

    def push_sep s
      @result << Sep.new(s)
    end

    alias << format

  end

end
