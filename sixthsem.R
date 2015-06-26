setwd("~/results")

#library(tm)
#getSources()
#getReaders()
#cname <- file.path(".", "corpuspdf")
#cname
#dir(cname)
# docs <- Corpus(DirSource(cname), readerControl =list (reader=readPDF))

system("pdftotext ~/results/results.pdf -f 49 -l 56 -layout")

mechs <- scan("results.txt", " ")

con <- file("results.txt")
mech <- readLines(con)
close(con)
#mech2 <- readLines(textConnection(mech))
mech3 <- strsplit(mech, "\n")

mech4 <- gsub("(?<=[[:digit:]] )(.*)(?= 2K12)", "'\\1'", mech, perl = TRUE)

read.table(text = mech2)

s1 <- "1 FOO BAR 2K12/ME/01 96 86 86 92 73 86 72 168 82 30 84.93
2 FOO2 BAR2 2K12/ME/02 72 83 61 75 44 88 75 165 91 30 72.60
3 FOO3 BOR BAR3 2K12/ME/03 72 83 61 75 44 88 75 165 91 30 66.6"

s2 <- readLines(textConnection(s1)) #read from your file here
s2 <- strsplit(s2, " ")
s3 <- lapply(s2, function(s) {
        n <- length(s)
        s[2] <- paste(s[2:(2 + (n - 14))], collapse = " ")
        s[-(3:(2 + (n - 14)))]  
})

s1 <- "1      FOO BAR                         2K12/ME/01                  96            86            86            92             73             86             72            168            82                       30     84.93
2      FOO2 BAR2                        2K12/ME/02                  72            83            61            75             44             88             75            165            91                       30     72.60
3      FOO3 BOR BAR3                      2K12/ME/03                  63            84            62            62             50             79             74            157            85                       30     69.13
4      FOO4 BOR BAR4                  2K12/ME/04                  89            88            74            79             77             83             68            182            82                       30     81.93"

v2 <- readLines(textConnection(mech)) #read from your file here
#s2 <- gsub("(?<=[[:digit:]] )(.*)(?= 2K12)", "'\\1'", mech, perl = TRUE)
v2 <- strsplit(v2, "\\s+") #splits by white space

s4 <- lapply(s3, function(s) {
        n <- length(s)
        s[2] <- paste(s[2:(2 + (n - 14))], collapse = " ")
        s[-(3:(2 + (n - 14)))]  
})


DF <- do.call(rbind, s3)
DF <- as.data.frame(DF, stringsAsFactors = FALSE)
DF[] <- lapply(DF, type.convert, as.is = TRUE)
str(DF)

x <- list(c("hello", "hi"), c("manchester","united"))

s3 <- lapply(s2, function(s) {
        c <- unlist(s)
        c <- c[-1]
        c <- list(c)
})