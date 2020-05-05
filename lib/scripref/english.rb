# encoding: utf-8
# frozen_string_literal: true

require 'scripref/bookname'
require 'scripref/const_reader'

module Scripref

  # Mixin for parsing references in English.
  module English

    # Standardized IDs for bible books in order with BOOK_NAMES.
    # (see https://wiki.crosswire.org/OSIS_Book_Abbreviations)
    osis_book_ids = %i[
      Gen Exod Lev Num Deut Josh Judg Ruth 1Sam 2Sam 1Kgs 2Kgs 1Chr 2Chr Ezra
      Neh Esth Job Ps Prov Eccl Song Isa Jer Lam Ezek Dan Hos Joel Amos Obad
      Jonah Mic Nah Hab Zeph Hag Zech Mal Matt Mark Luke John Acts Rom 1Cor
      2Cor Gal Eph Phil Col 1Thess 2Thess 1Tim 2Tim Titus Phlm Heb Jas 1Pet
      2Pet 1John 2John 3John Jude Rev
    ]

    book_names = <<-END.strip.split(/,\s*/)
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

    book_abbrevs = <<-END.strip.split(/,\s*/)
      Gen, Ex, Lev, Num, Deut, Josh, Judg, Rth, 1 Sam, 2 Sam, 1 Kgs, 2 Kgs,
      1 Chron, 2 Chron, Ezr, Neh, Esth, Job, Ps, Prov, Eccles, Song, Isa,
      Jer, Lam, Ezek, Dan, Hos, Joel, Am, Obad, Jon, Mic, Nah, Hab, Zeph, Hag,
      Zech, Mal, Matt, Mrk, Luk, John, Acts, Rom, 1 Cor, 2 Cor, Gal, Eph, Phil,
      Col, 1 Thess, 2 Thess, 1 Tim, 2 Tim, Tit, Philem, Heb, Jas, 1 Pet, 2 Pet,
      1 Joh, 2 Joh, 3 Joh, Jud, Rev
    END

    # Array of book names.
    BOOK_NAMES = osis_book_ids.zip(book_names, book_abbrevs).map {|osis_book_id, names, abbrevs| Bookname.new(osis_id: osis_book_id, names: names, abbrevs: abbrevs)}

    # Map of OSIS book ID to instance of Bookname
    OSIS_BOOK_ID_TO_BOOK_NAME = osis_book_ids.zip(BOOK_NAMES).map {|id, n| [id, n]}.to_h

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
    # @param osis_id OSIS-ID of the book
    def book_has_only_one_chapter? osis_id
      %i[Obad Phlm 2John 3John Jude].include?(osis_id)
    end

    # Regular expression to match punctuation marks
    PUNCTUATION_MARKS_RE = /[:;.\-]\s*/

    # Generate attr_reader methods for all constants
    extend ConstReader
    const_reader constants

  end

end
