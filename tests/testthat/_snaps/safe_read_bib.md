# safe_read_bib handles multiple entries and filters ignored ones

    Code
      safe_read_bib(path)
    Message
      * Ignoring entry 'bad2' (line9) because: A bibentry of bibtype 'Article' has to specify the field: title
    Output
            bibtype      title   author journal year
      good1 Article Good Title Author A      J1 2020

