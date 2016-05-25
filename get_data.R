setwd("~/Documents/data/packages")

start <- as.Date('2016-01-01')
today <- as.Date('2016-05-18')

all_days <- seq(start, today, by = 'day')

year <- as.POSIXlt(all_days)$year + 1900
urls <- paste0('http://cran-logs.rstudio.com/', year, '/', all_days, '.csv.gz')

filenames = paste("~/Documents/data/packages/files/",all_days, ".csv", sep="")

for(i in 1:length(urls)){
  download.file(urls[i], filenames[i], "auto")
  
}
data <- list(length(urls))
for(i in 1:length(urls)){
  message(i)
  data[[i]]<- read.csv(filenames[i])
}

library(data.table)
downloads <- rbindlist(data)
downloads[, date:=as.Date(date)]
downloads[, weekday:=weekdays(date)]

save(downloads, file="downloads.Rdata")

load("~/Documents/data/package_data/downloads.Rdata")
