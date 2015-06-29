setwd("~/results")

#library(tm)
#getSources()
#getReaders()
#cname <- file.path(".", "corpuspdf")
#cname
#dir(cname)
# docs <- Corpus(DirSource(cname), readerControl =list (reader=readPDF))

# system("pdftotext ~/results/results.pdf -f 49 -l 56 -H 19 -nopgbrk -layout")
# sed -e '1, 19d' < mech1.txt | head -n -7 nech1.txt

# mechs <- scan("results.txt", " ")

con <- file("results.txt")
mech <- readLines(con)
close(con)

s <- gsub("^ *|(?<= ) | *$", "", mech, perl = T)
df <- read.table(text=gsub("(?<=[[:digit:]] )(.*)(?= 2K12)", "'\\1'", s, 
                           perl = T), header = F)

