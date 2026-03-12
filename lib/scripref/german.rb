# encoding: utf-8
# frozen_string_literal: true

require_relative 'const_reader'

module Scripref

  # Mixin for parsing references in German.
  module German

    booknames = <<-END
      Gen: 1. Mose|1. Mos|1Mo|1M
      Exod: 2. Mose|2. Mos|2Mo|2M
      Lev: 3. Mose|3. Mos|3Mo|3M
      Num: 4. Mose|4. Mos|4Mo|4M
      Deut: 5. Mose|5. Mos|5Mo|5M
      Josh: Josua|Jos
      Judg: Richter|Ri
      Ruth: Ruth|Ruth|Rt
      1Sam: 1. Samuel|1. Sam|1Sam|1Sm
      2Sam: 2. Samuel|2. Sam|2Sam|2Sm
      1Kgs: 1. Könige|1. Kön|1Kön|1Kö
      2Kgs: 2. Könige|2. Kön|2Kön|2Kö
      1Chr: 1. Chronika|1. Chr|1Chr|1Ch
      2Chr: 2. Chronika|2. Chr|2Chr|2Ch
      Ezra: Esra|Esr
      Neh: Nehemia|Neh
      Esth: Esther|Est
      Job: Hiob|Hi
      Ps: Psalm|Ps, Psalmen
      Prov: Sprüche|Spr
      Eccl: Prediger|Pred
      Song: Hohelied|Hohel|Hoh|Hl
      Isa: Jesaja|Jes
      Jer: Jeremia|Jer
      Lam: Klagelieder|Klag
      Ezek: Hesekiel|Hes
      Dan: Daniel|Dan
      Hos: Hosea|Hos
      Joel: Joel|Joel
      Amos: Amos|Amos|Am
      Obad: Obadja|Obad|Ob
      Jonah: Jona|Jona|Jon
      Mic: Micha|Mich|Mi
      Nah: Nahum|Nah
      Hab: Habakuk|Hab
      Zeph: Zefanja|Zef, Zephanja|Zeph
      Hag: Haggai|Hag
      Zech: Sacharja|Sach
      Mal: Maleachi|Mal
      Matt: Matthäus|Mat|Mt
      Mark: Markus|Mar|Mr
      Luke: Lukas|Luk|Lk
      John: Johannes|Joh|Jh
      Acts: Apostelgeschichte|Apg
      Rom: Römer|Röm|Rö
      1Cor: 1. Korinther|1. Kor|1Ko
      2Cor: 2. Korinther|2. Kor|2Ko
      Gal: Galater|Gal
      Eph: Epheser|Eph
      Phil: Philipper|Phil
      Col: Kolosser|Kol
      1Thess: 1. Thessalonicher|1. Thes|1.Thes|1Thes|1Th
      2Thess: 2. Thessalonicher|2. Thes|2.Thes|2Thes|2Th
      1Tim: 1. Timotheus|1. Tim|1Tim
      2Tim: 2. Timotheus|2. Tim|2Tim
      Titus: Titus|Tit
      Phlm: Philemon|Philem|Phm
      Heb: Hebräer|Heb
      Jas: Jakobus|Jak
      1Pet: 1. Petrus|1. Pet|1Pet|1Pe
      2Pet: 2. Petrus|2. Pet|2Pet|2Pe
      1John: 1. Johannes|1. Joh|1Joh|1Jo
      2John: 2. Johannes|2. Joh|2Joh|2Jo
      3John: 3. Johannes|3. Joh|3Joh|3Jo
      Jude: Judas|Jud
      Rev: Offenbarung|Off
    END

    # Mapping of OSIS book ID to instance of Bookname
    BOOKNAMES_HASH = {}
    booknames.each_line do |l|
      bn = Bookname.parse(l)
      BOOKNAMES_HASH[bn.book_id] = bn
    end

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
    # @param book_id OSIS-ID of the book
    def book_has_only_one_chapter? book_id
      %i[Obad Phlm 2John 3John Jude].include?(book_id)
    end

    # Regular expression to match punctuation marks
    PUNCTUATION_MARKS_RE = /[,;.\-]\s*/

    # Generate attr_reader methods for all constants
    extend ConstReader
    const_reader constants

  end

end
