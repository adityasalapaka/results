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
        # the original layout.
        
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

# The PDF filename, without the .pdf extention.

foo <- "results"

extract(foo)

# Read filenames into a character vector

con <- file("results.txt")
results <- readLines(con)
close(con)


# Keeps rows with a roll number in them.
results <- results[grep("([0-9]\\s+\\w+)", results)]

# Removes the string containing failed subjects. These interfered with the final
# data frame and weren't really helpful in analysis.

results <- gsub("\\b[A-z]{1,2}\\b-.+", "", results)

# Some long names merged with the roll number. This removes the particular name.
# For example, FOO BAR2K12 is replaced with FOO 2K12.

results <- gsub("[A-Z]+2K", " 2K", results) 

# Replaces all surplus whitespaces with a single space.

results <- gsub("^ *|(?<= ) | *$", "", results, perl = T)

# Treats names with variable number of words as a single string and finally
# converts the text into a data frame. Scores unavailable due to detention or
# absence are treated as NA.

df <- read.table(text=gsub("(?<=[[:digit:]] )(.*)(?= 2K12)", "'\\1'", results, 
                           perl = TRUE), header = FALSE, 
                 na.strings = c("D", "A"))

# Orders data frame by roll number, like it appeared in the original PDF.

df <- df[naturalorder(df$V3),]

# Removes row numbers and adds column headers wherever possible.

rownames(df) <- NULL
colnames(df)[c(1:3, 13, 14)] <- c("Sr.No.", "Name", "Roll. No", "Total Credits"
                                  , "SPI")

# generates final CSV file with "." as decimal point and "," as separator.
write.table(df, file = "results.csv", sep = ",", quote = FALSE, 
            row.names = FALSE)

# A function used to generate individual data frames for a particular branch.

branchResults <- function(branchCode){
        branch <- df[grep(paste("2K12/", branchCode, sep = ""), df$Roll),]
        rownames(branch) <- NULL
        branch
}

# Uncomment the line below for an example to generate results for mechanical.

# mechanical <- branchResults("ME")