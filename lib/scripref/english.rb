# encoding: utf-8
# frozen_string_literal: true

require_relative 'const_reader'

module Scripref

  # Mixin for parsing references in English.
  module English

    booknames = <<-END
      Gen: Genesis|Gen
      Exod: Exodus|Ex
      Lev: Leviticus|Lev
      Num: Numbers|Num
      Deut: Deuteronomy|Deut
      Josh: Joshua|Josh
      Judg: Judges|Judg
      Ruth: Ruth|Rth
      1Sam: 1 Samuel|1 Sam
      2Sam: 2 Samuel|2 Sam
      1Kgs: 1 Kings|1 Kgs
      2Kgs: 2 Kings|2 Kgs
      1Chr: 1 Chronicles|1 Chron
      2Chr: 2 Chronicles|2 Chron
      Ezra: Ezra|Ezr
      Neh: Nehemiah|Neh
      Esth: Esther|Esth
      Job: Job|Job
      Ps: Psalms|Ps
      Prov: Proverbs|Prov
      Eccl: Ecclesiastes|Eccles
      Song: Song of Songs|Song
      Isa: Isaiah|Isa
      Jer: Jeremiah|Jer
      Lam: Lamentations|Lam
      Ezek: Ezekiel|Ezek
      Dan: Daniel|Dan
      Hos: Hosea|Hos
      Joel: Joel|Joel
      Amos: Amos|Am
      Obad: Obadiah|Obad
      Jonah: Jonah|Jon
      Mic: Micah|Mic
      Nah: Nahum|Nah
      Hab: Habakkuk|Hab
      Zeph: Zephaniah|Zeph
      Hag: Haggai|Hag
      Zech: Zechariah|Zech
      Mal: Malachi|Mal
      Matt: Matthew|Matt
      Mark: Mark|Mrk
      Luke: Luke|Luk
      John: John|John
      Acts: Acts|Acts
      Rom: Romans|Rom
      1Cor: 1 Corinthians|1 Cor
      2Cor: 2 Corinthians|2 Cor
      Gal: Galatians|Gal
      Eph: Ephesians|Eph
      Phil: Philippians|Phil
      Col: Colossians|Col
      1Thess: 1 Thessalonians|1 Thess
      2Thess: 2 Thessalonians|2 Thess
      1Tim: 1 Timothy|1 Tim
      2Tim: 2 Timothy|2 Tim
      Titus: Titus|Tit
      Phlm: Philemon|Philem
      Heb: Hebrews|Heb
      Jas: James|Jas
      1Pet: 1 Peter|1 Pet
      2Pet: 2 Peter|2 Pet
      1John: 1 John|1 Joh
      2John: 2 John|2 Joh
      3John: 3 John|3 Joh
      Jude: Jude|Jud
      Rev: Revelation|Rev
    END

    # Mapping of OSIS book ID to instance of Bookname
    BOOKNAMES_HASH = {}
    booknames.each_line do |l|
      bn = Bookname.parse_line(l)
      BOOKNAMES_HASH[bn.book_id] = bn
    end

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

    # Separator between verses.
    VERSE_SEPARATOR = ','

    # Regular expression to match addons for a verse.
    VERSE_ADDON_RE = /[abc]\s*/o

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
    PUNCTUATION_MARKS_RE = /[:;.\-]\s*/

    # Generate attr_reader methods for all constants
    extend ConstReader
    const_reader constants

  end

end
