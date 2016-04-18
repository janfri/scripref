# - encoding: utf-8 -
require 'scripref/const_reader'

module Scripref

  # Mixin for parsing references in German.
  module German

    # Array of book names.
    BOOK_NAMES = <<-END.strip.split(/,\s*/).map {|e| e.split('|')}
      1. Mose, 2. Mose, 3. Mose, 4. Mose, 5. Mose, Josua, Richter, Ruth, 1. Samuel, 2. Samuel,
      1. Könige, 2. Könige, 1. Chronika, 2. Chronika, Esra, Nehemia, Esther, Hiob, Psalm|Psalmen,
      Sprüche, Prediger, Hohelied, Jesaja, Jeremia, Klagelieder, Hesekiel, Daniel, Hosea, Joel,
      Amos, Obadja, Jona, Micha, Nahum, Habakuk, Zefanja|Zephanja, Haggai, Sacharja, Maleachi,
      Matthäus, Markus, Lukas, Johannes, Apostelgeschichte, Römer, 1. Korinther, 2. Korinther,
      Galater, Epheser, Philipper, Kolosser, 1. Thessalonicher, 2. Thessalonicher, 1. Timotheus,
      2. Timotheus, Titus, Philemon, Hebräer, Jakobus, 1. Petrus, 2. Petrus, 1. Johannes,
      2. Johannes, 3. Johannes, Judas, Offenbarung
    END

    # Separator between chapter and verse.
    CV_SEPARATOR = ','

    # Regular expression to match a separator between chapter and verse.
    CV_SEP_RE = /,\s*/o

    # Separator between a range.
    HYPHEN_SEPARATOR = '-'

    # Regular expression to match a hyphen.
    HYPHEN_RE = /\s*-\s*/o

    # Separator between passages.
    PASS_SEPARATOR = '; '

    # Regular expression to match a separator between passages.
    PASS_SEP_RE = /;\s*/o

    # Regular expression to match a separator between verses.
    VERSE_SEP_RE = /\.\s*/o

    # Separator between verses.
    VERSE_SEPARATOR = '.'

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

    pass = '([1-5]\.?\s*)?[A-Z][a-zäöü]+\.?\s*(\d+\s*[,.\-]\s*)*\d+\s*'

    # Regular expression to parse a reference
    REFERENCE_RE = /#{pass}(;\s*#{pass})*/o

    # Check if book has only one chapter
    # @param book book as number
    def book_has_only_one_chapter? book
      [31, 57, 63, 64, 65].include?(book)
    end

    # Hash with special abbreviations
    SPECIAL_ABBREV_MAPPING = {'Phil' => 'Philipper'}

    # Generate attr_reader methods for all constants
    extend ConstReader
    const_reader constants

  end

end
