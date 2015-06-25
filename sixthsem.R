library(tm)
getSources()
getReaders()
cname <- file.path(".", "corpuspdf")
cname
dir(cname)
docs <- Corpus(DirSource(cname), readerControl =list (reader=readPDF))
