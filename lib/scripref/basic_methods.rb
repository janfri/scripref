# encoding: utf-8
# frozen_string_literal: false

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

    # Regular expression to match a book
    def book_re
      return @book_re if @book_re
      books_res_as_strings = []
      each_bookname do |bn|
        bn.each_name do |n|
          books_res_as_strings << (n.gsub(/([^\dA-Z])/, '\1?').gsub('.', '\.'))
        end
      end
      @book_re = Regexp.compile(books_res_as_strings.map {|s| '(\b' << s << '\b\.?\s*)' }.join('|'), nil)
    end

    # Enumerator over booknames
    def each_bookname &blk
      osis_book_id_to_book_name.each_value(&blk)
    end

  end

end
