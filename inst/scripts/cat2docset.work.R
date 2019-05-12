
library(ssrch)
library(xml2)
source("R/cat2docset.R")
immu300 = cat2docset("./msigdb_v6.2.xml", rec_id_field="recident", min_tok_nchar=2, start=1, end=300,
  max_tok_nchar=1000) 


# hallmark = cat2docset("../../msigdb_v6.2.xml", "H", 
#  1, 50, rec_id_field="recident", min_tok_nchar=2, max_tok_nchar=2000)

