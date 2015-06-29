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
mech <- readLines(con)
close(con)

s <- gsub("^ *|(?<= ) | *$", "", mech, perl = T)
df <- read.table(text=gsub("(?<=[[:digit:]] )(.*)(?= 2K12)", "'\\1'", s, 
                           perl = T), header = F)

