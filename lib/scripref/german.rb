# - encoding: utf-8 -
require 'scripref/const_reader'

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

    BOOKS_RES = BOOK_NAMES.map do |bn|
      Regexp.new(bn.gsub(/([^1-5A-Z])/, '\1?').gsub('.', '\.') << '\b\s*')
    end

    BOOK_RE = Regexp.new('^' << BOOKS_RES.map {|re| '(' << re.to_s << ')' }.join('|'))

    CV_SEP_RE = /,\s*/o
    HYPHEN_RE = /\s*-\s*/o
    REF_SEP_RE = /;\s*/o
    VERSE_SEP_RE = /\.\s*/o

    VERSE_ADDON_RE = /([ab]|ff?)\s*/o

    pass = '([1-5]\.?\s*)?[A-Z][a-zäöü]+\.?\s*(\d+\s*[,.\-]\s*)*\d+\s*'
    REFERENCE_RE = /#{pass}(;\s*#{pass})*/o

    extend ConstReader
    const_reader constants

  end

end
