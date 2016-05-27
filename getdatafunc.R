getdatafunc <- function(start_date, end_date){
 
  start <- as.Date(start_date)
  end <- as.Date(end_date)
  
  all_days <- seq(start, end, by = 'day')
  
  year <- as.POSIXlt(all_days)$year + 1900
  urls <- paste0('http://cran-logs.rstudio.com/', year, '/', all_days, '.csv.gz')
  prog <- txtProgressBar(min=0, max=length(urls))
  
  filenames = paste(getwd(),all_days, ".csv", sep="")
  data <- vector("list", length(urls))
  for(i in 1:length(urls)){
    download.file(urls[i], filenames[i], "auto")
    Sys.sleep(1)
    data[[i]]<- read.csv(filenames[i])
    setTxtProgressBar(prog,i)
  }
  
  message("Completing...")
  library(data.table)
  downloads <- rbindlist(data)
  downloads[, date:=as.Date(date)]
  message("Complete")
  downloads
}