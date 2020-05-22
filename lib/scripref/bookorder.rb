# encoding: utf-8
# frozen_string_literal: true

module Scripref

  # Constants of different orderings of bible books using standardized IDs
  # (see https://wiki.crosswire.org/OSIS_Book_Abbreviations)
  module Bookorder

    # Canonical order (the default order without any apocryphal books)
    CANONICAL = %i[
      Gen Exod Lev Num Deut Josh Judg Ruth 1Sam 2Sam 1Kgs 2Kgs 1Chr 2Chr Ezra
      Neh Esth Job Ps Prov Eccl Song Isa Jer Lam Ezek Dan Hos Joel Amos Obad
      Jonah Mic Nah Hab Zeph Hag Zech Mal Matt Mark Luke John Acts Rom 1Cor
      2Cor Gal Eph Phil Col 1Thess 2Thess 1Tim 2Tim Titus Phlm Heb Jas 1Pet
      2Pet 1John 2John 3John Jude Rev
    ]
  end

end
