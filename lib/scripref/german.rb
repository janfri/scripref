# encoding: utf-8
# frozen_string_literal: true

require_relative 'const_reader'

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
      1. Mos|1Mo|1M, 2. Mos|2Mo|2M, 3. Mos|3Mo|3M, 4. Mos|4Mo|4M, 5. Mos|5Mo|5M, Jos, Ri,
      Ruth, 1. Sam|1Sam|1Sm, 2. Sam|2Sam|2Sm, 1. Kön|1Kön|1Kö, 2. Kön|2Kön|2Kö,
      1. Chr|1Chr|1Ch, 2. Chr|2Chr|2Ch, Esr, Neh, Est, Hi, Ps, Spr, Pred,
      Hohel|Hoh|Hl, Jes, Jer, Klag, Hes, Dan, Hos, Joel, Amos|Am, Obad|Ob,
      Jona|Jon, Mich|Mi, Nah, Hab, Zef, Hag, Sach, Mal, Mat|Mt, Mar|Mr, Luk|Lk,
      Joh|Jh, Apg, Röm|Rö, 1. Kor|1Ko, 2. Kor|2Ko, Gal, Eph, Phil, Kol,
      1. Thes|1Thes|1Th, 2. Thes|2Thes|2Th, 1. Tim|1Tim, 2. Tim|2Tim, Tit, Philem|Phm, Heb,
      Jak, 1. Pet|1Pet|1Pe, 2. Pet|2Pet|2Pe, 1. Joh|1Joh|1Jo, 2. Joh|2Joh|2Jo,
      3. Joh|3Joh|3Jo, Jud, Off
    END

    # Array of book names.
    BOOK_NAMES = Bookorder::CANONICAL.zip(book_names, book_abbrevs).map {|osis_book_id, names, abbrevs| Bookname.new(osis_id: osis_book_id, names: names, abbrevs: abbrevs)}

    # Map of OSIS book ID to instance of Bookname
    OSIS_BOOK_ID_TO_BOOK_NAME = Bookorder::CANONICAL.zip(BOOK_NAMES).map {|id, n| [id, n]}.to_h

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
    # @param osis_id OSIS-ID of the book
    def book_has_only_one_chapter? osis_id
      %i[Obad Phlm 2John 3John Jude].include?(osis_id)
    end

    # Regular expression to match punctuation marks
    PUNCTUATION_MARKS_RE = /[,;.\-]\s*/

    # Generate attr_reader methods for all constants
    extend ConstReader
    const_reader constants

  end

end
