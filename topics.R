## get descriptions
desc <- character(nrow(package_downloads))
for(i in 9682:nrow(package_downloads)){
  url <- paste('https://cran.r-project.org/package=', package_downloads$package[i],sep='')
  if(url.exists(url)){
    cranpage <- readLines(url)
    a<-grep('^<p>', cranpage)
    b<-grep('</p>$', cranpage)
    c <- cranpage[a[1]:b[1]]
    c <-sub('<p>','', c)
    c <- gsub('</p>', '', c)
    desc[i] <- paste(c,sep=" ", collapse="")
  }
  message(i)
}

save(desc, file="desc.Rdata")
