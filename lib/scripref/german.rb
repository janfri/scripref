# - encoding: utf-8 -
module Scripref

  module German

    BOOK_NAMES = <<-END.strip.split(/,\s*/)
      1. Mose, 2. Mose, 3. Mose, 4. Mose, 5. Mose, Josua, Richter, Ruth, 1. Samuel, 2. Samuel,
      1. Könige, 2.Könige, 1. Chronika, 2. Chronika, Esra, Nehemia, Esther, Hiob, Psalm,
      Sprüche, Prediger, Hohelied, Jesaja, Jeremia, Klagelieder, Hesekiel, Daniel, Hosea, Joel,
      Amos, Obadja, Jona, Micha, Nahum, Habakuk, Zephanja, Haggai, Sacharja, Maleachi,
      Matthäus, Markus, Lukas, Johannes, Apostelgeschichte, Römer, 1. Korinther, 2. Korinther,
      Galater, Epheser, Philipper, Kolosser, 1. Thessalonicher, 2. Thessalonicher, 1. Timotheus,
      2. Timotheus, Titus, Philemon, Hebräer, Jakobus, 1. Petrus, 2. Petrus, 1. Johannes,
      2. Johannes, 3. Johannes, Judas, Offenbarung
    END

    BOOK_RE = Regexp.new(BOOK_NAMES.map {|bn| bn + '\s*'}.join('|'))

    CV_SEP_RE = /,\s*/
      HYPHEN_RE = /\s*-\s*/
      REF_SEP_RE = /;\s*/
      VERSE_SEP_RE = /\.\s*/o

    def book_re
      BOOK_RE
    end

    def book2num str
      return nil unless book_re =~str
      BOOK_NAMES.index(str.strip) + 1
    end

    def cv_sep_re
      CV_SEP_RE
    end

    def hyphen_re
      HYPHEN_RE
    end

    def ref_sep_re
      REF_SEP_RE
    end

    def verse_sep_re
      VERSE_SEP_RE
    end

  end

end
