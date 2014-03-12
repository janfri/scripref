# - encoding: utf-8 -
require 'scripref/const_reader'

module Scripref

  # Mixin for parsing references in English.
  module English

    # Array of book names.
    BOOK_NAMES = <<-END.strip.split(/,\s*/)
      Genesis, Exodus, Leviticus, Numbers, Deuteronomy, Joshua, Judges,
      Ruth, 1 Samuel, 2 Samuel, 1 Kings, 2 Kings, 1 Chronicles,
      2 Chronicles, Ezra, Nehemiah, Esther, Job, Psalms, Proverbs,
      Ecclesiastes, Song of Songs, Isaiah, Jeremiah, Lamentations,
      Ezekiel, Daniel, Hosea, Joel, Amos, Obadiah, Jonah, Micah, Nahum,
      Habakkuk, Zephaniah, Haggai, Zechariah, Malachi,
      Matthew, Mark, Luke, John, Acts, Romans, 1 Corinthians,
      2 Corinthians, Galatians, Ephesians, Philippians, Colossians,
      1 Thessalonians, 2 Thessalonians, 1 Timothy, 2 Timothy, Titus,
      Philemon, Hebrews, James, 1 Peter, 2 Peter, 1 John, 2 John, 3 John,
      Jude, Revelation
    END

    # Array of regular expressions to match book names.
    BOOKS_RES = BOOK_NAMES.map do |bn|
      Regexp.new(bn.gsub(/([^1-3A-Z])/, '\1?').gsub('.', '\.') << '\b\s*')
    end

    # Regular expression to match a book.
    BOOK_RE = Regexp.new(BOOKS_RES.map {|re| '(^' << re.to_s << ')' }.join('|'))

    # Regular expression to match a separator between chapter and verse.
    CV_SEP_RE = /:\s*/o

    # Regular expression to match a hyphen.
    HYPHEN_RE = /\s*-\s*/o

    # Regular expression to match a separator between passages.
    PASS_SEP_RE = /;\s*/o

    # Regular expression to match a separator between verses.
    VERSE_SEP_RE = /,\s*/o

    # Regular expression to match addons for a verse.
    VERSE_ADDON_RE = /([ab]|ff?)\s*/o

    pass = '([1-3]\s*)?[A-Z][a-z]+\.?\s*(\d+\s*[,.\-]\s*)*\d+\s*'

    # Regular expression to parse a reference
    REFERENCE_RE = /#{pass}(;\s*#{pass})*/o

  end

end