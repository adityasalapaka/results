setwd("~/results")

cleanUp <- function(x){
        
        for (i in 1:65){
                system(paste("pdftotext results.pdf -f ", i," -l ", i, 
                             " -layout ", i, ".txt", sep = ""))
                system(paste("sed -e '1, 19d' < ", i, ".txt | head -n -7 > ", i,
                             "output.txt", sep = ""))
        }
        
        
        for(i in 1:65){
                system(paste("rm ", i, ".txt", sep=""))
        }
        
        system("cat *.txt > results.txt")
        
        for(i in 1:65){
                system(paste("rm ", i, "output.txt", sep=""))
        }
}

con <- file("results.txt")
results <- readLines(con)
close(con)

length(grep("2K12", results)) # 1361
length(results) # 1479

results <- results[grep("([0-9]\\s+\\w+)", results)]
length(results)

x <- gsub("\\b[A-z]{1,2}\\b-.+", "", results)
x <- gsub("[A-Z]+\\dK", " 2K", x) # replaces FOO BOO BAR2K12 with FOO BOO 2K12

s <- gsub("^ *|(?<= ) | *$", "", x, perl = T)
df <- read.table(text=gsub("(?<=[[:digit:]] )(.*)(?= 2K12)", "'\\1'", s, 
                           perl = T), header = F)

rownames(df) <- NULL