## get descriptions
load("index.Rdata")
desc <- character(100)
library(RCurl)
for(i in 1:100){
  url <- paste('https://cran.r-project.org/package=', index$package[i],sep='')
  if(url.exists(url)){
    cranpage <- readLines(url)
    if(FALSE==TRUE %in% grepl("removed from the CRAN repository",cranpage)){
      a<-grep('^<p>', cranpage)
      b<-grep('</p>$', cranpage)
      c <- cranpage[a[1]:b[1]]
      c <-sub('<p>','', c)
      c <- gsub('</p>', '', c)
      desc[i] <- paste(c,sep=" ", collapse=" ")
    }
    else{
      desc[i] <- NA
    }
  }
  else{
    desc[i] <- NA
  }
  message(i)
}

save(desc, file="desc.Rdata")


#transform descriptions
desc <- desc[!is.na(desc)]
library(tm)
desc <- Corpus(VectorSource(desc))
desc <- tm_map(desc, removePunctuation)
desc <- tm_map(desc, content_transformer(tolower))
desc <- tm_map(desc, removeWords, stopwords("english"))
desc <- tm_map(desc, stripWhitespace)
library(SnowballC)
desc <- tm_map(desc, stemDocument)
desc <- tm_map(desc, content_transformer(gsub), pattern = "colour", replacement = "color")
myStopwords <- c("use", "can", "includ", "also", "will", "see", "well", "htpp", "easi", "provid", "allow", "etc")
desc <- tm_map(desc, removeWords, myStopwords)
dtm <- DocumentTermMatrix(desc)
rownames(dtm) <- head(index$package,100)
freq <- colSums(as.matrix(dtm))
order <- order(freq,decreasing=TRUE)
head(freq[order],10)

#LDA
library(topicmodels)
lda <-LDA(dtm,5, method="Gibbs")
ldatopics <- as.matrix(topics(lda))
colnames(ldatopics) <- c("topic")
ldatopics <- mutate(as.data.frame(ldatopics), package=rownames(ldatopics))
ldaterms <- as.matrix(terms(lda,10))
ldaprobabilities <- as.data.frame(lda@gamma)

save(ldatopics,file="ldatopics.R")
save(ldaterms, file="ldaterms.R")
save(ldaprobabilities, file="ldaprobabilities.R")

#CTM
ctm <- CTM(dtm,5)
ctmtopics <- as.data.frame(topics(ctm))
colnames(ctmtopics) <- c("topic")
ctmtopics <- mutate(as.data.frame(ctmtopics), package=rownames(ctmtopics))
filter(ctmtopics, topic==3)
ctmterms <- as.matrix(terms(ctm,10))
ctmprobabilities <- as.data.frame(ctm@gamma)



#ALSO: to inspect element
writeLines(as.character(desc[[1]]))
