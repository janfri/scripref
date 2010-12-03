# - encoding: utf-8 -
module Scripref::German

  def book_names
    @booknames ||= %q(1. Mose, 2.Mose, 3. Mose, 4. Mose, 5. Mose, Josua, Richter, Ruth, 1. Samuel 2. Samuel
        1. Könige, 2.Könige, 1. Chronika, 2. Chronika, Esra, Nehemia).split(/,\s*/)
  end

  def book_re
    @book_re ||= Regexp.new(book_names.map {|bn| bn + '\s*'}.join('|'))
  end

  def book2num str
    return nil unless book_re =~str
    book_names.index(str.strip) + 1
  end

end
