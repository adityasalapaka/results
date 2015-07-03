# Sets working directory.

setwd("~/results")

# Loads natural sort into the environment. Uncomment the next line to install
# it.

# install.packages("naturalsort)

library(naturalsort)

# Function used to convert the PDF to text. Accepts a character vector with
# the file name. Ensure that the file to be extracted is the working directorty
# and that there are no other text files in the working directory.

extract <- function(resultsPDF){
        
        # Counts number of pages in the PDF file.
        
        pages <- system(paste("pdfinfo ", resultsPDF, 
                              ".pdf | awk '/^Pages:/ {print $2}'", sep = ""), 
                        intern = TRUE)
        
        # Extracts text from each page to individual text files, preserving
        # the original layout. This creates the first batch of text files. 
        # Unwanted text at the head and the tail are stripped off to create 
        # a second batch of text files.
        
        for (i in 1:pages){
                system(paste("pdftotext ", resultsPDF, ".pdf -f ", i," -l ", i, 
                             " -layout ", i, ".txt", sep = ""))
                system(paste("sed -e '1, 19d' < ", i, ".txt | head -n -7 > ", i,
                             "output.txt", sep = ""))
                system(paste("rm ", i, ".txt", sep=""))
        }
        
        # Creates a contiguous text file from the indivdual ones.
        
        system("cat *.txt > results.txt")
        
        # Removes all remaining text files.
        
        for(i in 1:pages){
                system(paste("rm ", i, "output.txt", sep=""))
        }
}

foo <- "results"

extract(foo)

con <- file("results.txt")
results <- readLines(con)
close(con)

length(grep("2K12", results))
length(results)

results <- results[grep("([0-9]\\s+\\w+)", results)]
length(results)

results <- gsub("\\b[A-z]{1,2}\\b-.+", "", results) # removes backs

x <- gsub("[A-Z]+2K", " 2K", results) # replaces FOO BOO BAR2K12 with FOO BOO 2K12

s <- gsub("^ *|(?<= ) | *$", "", x, perl = T)
df <- read.table(text=gsub("(?<=[[:digit:]] )(.*)(?= 2K12)", "'\\1'", s, 
                           perl = TRUE), header = FALSE, 
                 na.strings = c("D", "A"))

df <- df[naturalorder(df$V3),]

rownames(df) <- NULL
colnames(df)[c(1:3, 13, 14)] <- c("Sr.No.", "Name", "Roll. No", "Total Credits"
                                  , "SPI")

write.table(df, file = "results.csv", sep = ",", quote = FALSE, 
            row.names = FALSE)

branchResults <- function(branchCode){
        branch <- df[grep(paste("2K12/", branchCode, sep = ""), df$Roll),]
        rownames(branch) <- NULL
        branch
}