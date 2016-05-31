sortbycountry <- function(downloads, n=10){
## create data frame showing top n packages in each country from downloaded data, downloads
  countries <- as.data.frame(table(downloads$country))
  names(countries) <- c("country", "freq")
  countries <- arrange(countries, desc(freq))
  rank <- rep(1:n, length(countries))
  cp <- vector("list", length(countries$country))
  names(cp) <- countries$country
  for(i in 1:length(countries$country)){
    a <- downloads[country==countries$country[i],]
    b <- arrange(as.data.frame(table(a$package)), desc(Freq))
    c <- as.character(head(b[,1],n))
    d <- head(b[,2], n)
    cp[[i]] <- data.frame(package=c, downloads=d)
  }
  country <- rep(countries$country,each=n)
  countries <- rbindlist(cp)
  countries <- cbind(country, rank, countries)
  countries
}