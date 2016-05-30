getdatafunc <- function(start_year, start_month, start_day, end_year, end_month, end_day){
## download R packages downloads data from website and put into R
  
  start <- as.Date(paste(start_year, start_month, start_day, sep="-"))
  end <- as.Date(paste(end_year, end_month, end_day, sep="-"))
  
  all_days <- seq(start, end, by = 'day')
  
  year <- as.POSIXlt(all_days)$year + 1900
  urls <- paste0('http://cran-logs.rstudio.com/', year, '/', all_days, '.csv.gz')
  
  filenames = paste(getwd(),all_days, ".csv", sep="")
  data <- vector("list", length(urls))
  for(i in 1:length(urls)){
    download.file(urls[i], filenames[i], "auto")
    Sys.sleep(1)
    data[[i]]<- read.csv(filenames[i])
  }
  
  message("Completing...")
  library(data.table)
  downloads <- rbindlist(data)
  downloads[, date:=as.Date(date)]
  message("Complete")
  downloads
}