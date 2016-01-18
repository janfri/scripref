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

    # Separator between chapter and verse.
    CV_SEPARATOR = ':'

    # Regular expression to match a separator between chapter and verse.
    CV_SEP_RE = /:\s*/o

    # Separator between a range.
    HYPHEN_SEPARATOR = '-'

    # Regular expression to match a hyphen.
    HYPHEN_RE = /\s*-\s*/o

    # Separator between passages.
    PASS_SEPARATOR = '; '

    # Regular expression to match a separator between passages.
    PASS_SEP_RE = /;\s*/o

    # Regular expression to match a separator between verses.
    VERSE_SEP_RE = /,\s*/o

    # Regular expression to match addons for a verse.
    VERSE_ADDON_RE = /[ab]\s*/o

    # Postfix for one following verse
    POSTFIX_ONE_FOLLOWING_VERSE = 'f'

    # Regular expression to match postfix for one following verse
    POSTFIX_ONE_FOLLOWING_VERSE_RE = /f\b\s*/o

    # Postfix for more following verses
    POSTFIX_MORE_FOLLOWING_VERSES = 'ff'

    # Regular expression to match postfix for more following verses
    POSTFIX_MORE_FOLLOWING_VERSES_RE = /ff\b\s*/o

    pass = '([1-3]\s*)?[A-Z][a-z]+\.?\s*(\d+\s*[,.\-]\s*)*\d+\s*'

    # Regular expression to parse a reference
    REFERENCE_RE = /#{pass}(;\s*#{pass})*/o

    # Check if book has only one chapter
    # @param book book as number
    def book_has_only_one_chapter? book
      [31, 57, 63, 64, 65].include?(book)
    end

    # Generate attr_reader methods for all constants
    extend ConstReader
    const_reader constants

  end

end
