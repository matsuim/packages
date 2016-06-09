getmaterials <- function(package){
##package is a character vector with package name
  library(RCurl)
  library(XML)
  site <- getForm("http://www.google.com/search", hl="en",
                  lr="", q=paste(dQuote(package), "r package tutorial", sep=" "), btnG="Search", tbm="vid")
  site <- htmlTreeParse(site, useInternalNodes=TRUE)
  nodes <- getNodeSet(site, "//h3[@class='r']//a")
  url <- as.character(xmlToList(nodes[[1]])$.attrs)
  a <- regexpr("http", url)
  b <- regexpr("&sa", url)
  url <- substr(url, a,b-1)
  sites <- character(2)
  sites[1] <- url
  sites[2] <- NA
##PDF (if no pdf in first 100 results, use first webpage from google search)
  for(i in 1:10){
    site <- getForm("http://www.google.com/search", hl="en",
                    lr="", q=paste(dQuote(package), "r package tutorial", sep=" "), btnG="Search",start=10*(i-1))
    site <- htmlTreeParse(site, useInternalNodes=TRUE)
    nodes <- getNodeSet(site, "//h3[@class='r']//a")
    for(j in 1:10){
      url <- as.character(xmlToList(nodes[[j]])$.attrs)
      b <- regexpr("&sa", url)
      if(substr(url, b-3,b-1)=="pdf"){
        a <- regexpr("http", url)
        url <- substr(url, a,b-1)
        sites[2] <- url
      }
      if(is.na(sites[2])==FALSE){
        break
      }
    }
    if(is.na(sites[2])==FALSE){
      break
    }
  }
  sites
}
