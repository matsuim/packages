## get descriptions
desc <- character(nrow(package_downloads))
library(RCurl)
for(i in 1:nrow(package_downloads)){
  url <- paste('https://cran.r-project.org/package=', package_downloads$package[i],sep='')
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
myStopwords <- c("packag","use", "can", "includ", "also")
desc <- tm_map(desc, removeWords, myStopwords)
dtm <- DocumentTermMatrix(desc)
rownames(dtm) <- head(package_downloads$package,100)
freq <- colSums(as.matrix(dtm))
order <- order(freq,decreasing=TRUE)
write.csv(freq[order],'word_freq.csv')

#LDA
library(topicmodels)
ldaOut <- ldaOut <-LDA(dtm,10, method="Gibbs")
ldaOut <- ldaOut <-LDA(dtm,5, method="Gibbs", control=list(nstart=20, seed = sample(1:100,20), best=TRUE, burnin = 4000, iter = 4000, thin=500))
topics <- as.matrix(topics(ldaOut))
colnames(topics) <- c("topic")
terms <- as.matrix(terms(ldaOut,20))
probabilities <- as.data.frame(ldaOut@gamma)

#ALSO: to inspect element
writeLines(as.character(desc[[1]]))
