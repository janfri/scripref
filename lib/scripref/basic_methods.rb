# - encoding: utf-8 -
module Scripref

  # Mixin with methods of basic functionality
  module BasicMethods

    NUMBER_RE = /\d+\s*/o

    # Regular expression to match a chapter
    def chapter_re
      NUMBER_RE
    end

    # Regular expression to match a verse
    def verse_re
      NUMBER_RE
    end

    # Regular expression to match a book.
    def book_re
      return @book_re if @book_re
      books_res_as_strings = book_names.map do |bn|
        bn.names.map do |n|
          (n.gsub(/([^\dA-Z])/, '\1?').gsub('.', '\.'))
        end
      end.flatten
      @book_re = Regexp.compile(books_res_as_strings.map {|s| '(\b' << s << '\b\s*)' }.join('|'), nil)
    end

  end

end
