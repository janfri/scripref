# - encoding: utf-8 -
require 'scripref/bookname'
require 'scripref/const_reader'

module Scripref

  # Mixin for parsing references in German.
  module German

    book_names = <<-END.strip.split(/,\s*/).map {|e| e.split('|')}
      1. Mose, 2. Mose, 3. Mose, 4. Mose, 5. Mose, Josua, Richter, Ruth, 1. Samuel, 2. Samuel,
      1. Könige, 2. Könige, 1. Chronika, 2. Chronika, Esra, Nehemia, Esther, Hiob, Psalm|Psalmen,
      Sprüche, Prediger, Hohelied, Jesaja, Jeremia, Klagelieder, Hesekiel, Daniel, Hosea, Joel,
      Amos, Obadja, Jona, Micha, Nahum, Habakuk, Zefanja|Zephanja, Haggai, Sacharja, Maleachi,
      Matthäus, Markus, Lukas, Johannes, Apostelgeschichte, Römer, 1. Korinther, 2. Korinther,
      Galater, Epheser, Philipper, Kolosser, 1. Thessalonicher, 2. Thessalonicher, 1. Timotheus,
      2. Timotheus, Titus, Philemon, Hebräer, Jakobus, 1. Petrus, 2. Petrus, 1. Johannes,
      2. Johannes, 3. Johannes, Judas, Offenbarung
    END

    book_abbrevs = <<-END.strip.split(/,\s*/).map {|e| e.split('|')}
      1.Mo|1Mo|1M, 2.Mo|2Mo|2M, 3.Mo|3Mo|3M, 4.Mo|4Mo|4M, 5.Mo|5Mo|5M, Jos, Ri,
      Ruth, 1.Sam|1Sam|1Sm, 2.Sam|2Sam|2Sm, 1.Kön|1Kön|1Kö, 2.Kön|2Kön|2Kö,
      1.Chr|1Chr|1Ch, 2.Chr|2Chr|2Ch, Esr, Neh, Est, Hi, Ps, Spr, Pred,
      Hohel|Hoh|Hl, Jes, Jer, Klag, Hes, Dan, Hos, Joel, Amos|Am, Obad|Ob,
      Jona|Jon, Mich|Mi, Nah, Hab, Zef, Hag, Sach, Mal, Mat|Mt, Mar|Mr, Luk|Lk,
      Joh|Jh, Apg, Röm|Rö, 1.Ko|1Ko, 2.Ko|2Ko, Gal, Eph, Phil, Kol,
      1.Thes|1Thes|1Th, 2.Thes|2Thes|2Th, 1.Tim, 2.Tim, Tit, Philem|Phm, Heb,
      Jak, 1.Pet|1Pet|1Pe, 2.Pet|2Pet|2Pe, 1.Joh|1Joh|1Jo, 2.Joh|2Joh|2Jo,
      3.Joh|3Joh|3Jo, Jud, Off
    END

    # Array of book names.
    BOOK_NAMES = book_names.zip(book_abbrevs).map {|name, abbrev| Bookname.new(name, abbrev)}

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
    VERSE_ADDON_RE = /[abc]\b\s*/o

    # Postfix for one following verse
    POSTFIX_ONE_FOLLOWING_VERSE = 'f'

    # Regular expression to match postfix for one following verse
    POSTFIX_ONE_FOLLOWING_VERSE_RE = /f\b\s*/o

    # Postfix for more following verses
    POSTFIX_MORE_FOLLOWING_VERSES = 'ff'

    # Regular expression to match postfix for more following verses
    POSTFIX_MORE_FOLLOWING_VERSES_RE = /ff\b\s*/o

    # Check if book has only one chapter
    # @param book book as number
    def book_has_only_one_chapter? book
      [31, 57, 63, 64, 65].include?(book)
    end

    # Regular expression to match punctuation marks
    PUNCTUATION_MARKS_RE = /[,;.\-]\s*/

    # Generate attr_reader methods for all constants
    extend ConstReader
    const_reader constants

  end

end
