setwd("~/results")

#library(tm)
#getSources()
#getReaders()
#cname <- file.path(".", "corpuspdf")
#cname
#dir(cname)
# docs <- Corpus(DirSource(cname), readerControl =list (reader=readPDF))

system("pdftotext ~/results/results.pdf -f 49 -l 56 -layout")

mech <- scan("results.txt", "")


View(data.frame(mech[1:15]))

d1 <- t(data.frame(mech[1:15]))
d2 <- t(data.frame(mech[31:45]))
df <- data.frame()
rbind(d1, d2, df)

extract <- function(x){
        
        a = 1
        b = 15
        df <- data.frame()
        
        for (i in 1:length(x)/15){
                
                df <- rbind(df, t(data.frame(x[a:b])))
                
                a = a*i
                b = b*i
        }
}