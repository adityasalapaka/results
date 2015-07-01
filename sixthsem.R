setwd("~/results")

library(naturalsort)

extract <- function(resultsPDF){
        
        print(resultsPDF)
        pages <- system(paste("pdfinfo ", resultsPDF, 
                              ".pdf | awk '/^Pages:/ {print $2}'", sep = ""), 
                        intern = TRUE)
        
        for (i in 1:pages){
                system(paste("pdftotext ", resultsPDF, ".pdf -f ", i," -l ", i, 
                             " -layout ", i, ".txt", sep = ""))
                system(paste("sed -e '1, 19d' < ", i, ".txt | head -n -7 > ", i,
                             "output.txt", sep = ""))
        }
        
        
        for(i in 1:pages){
                system(paste("rm ", i, ".txt", sep=""))
        }
        
        system("cat *.txt > results.txt")
        
        for(i in 1:pages){
                system(paste("rm ", i, "output.txt", sep=""))
        }
}

foo <- "results"

extract(foo)

con <- file("results.txt")
results <- readLines(con)
close(con)

length(grep("2K12", results)) # 1361
length(results) # 1479

results <- results[grep("([0-9]\\s+\\w+)", results)]
length(results)

results <- gsub("\\b[A-z]{1,2}\\b-.+", "", results) # removes backs
(?<=a)b
x <- gsub("[A-Z]+2K", " 2K", results) # replaces FOO BOO BAR2K12 with FOO BOO 2K12

s <- gsub("^ *|(?<= ) | *$", "", x, perl = T)
df <- read.table(text=gsub("(?<=[[:digit:]] )(.*)(?= 2K12)", "'\\1'", s, 
                           perl = T), header = F)

df <- df[naturalorder(df$V3),]

rownames(df) <- NULL

branchResults <- function(branchCode){
        branch <- df[grep(paste("2K12/", branchCode, sep = ""), df$V3),]
}

mechanical <- branchResults("ME")
