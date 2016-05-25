library(dplyr)
package_downloads$package <- as.character(package_downloads$package)
z <- numeric(length(package_downloads))
for(i in 1:300){
  message(i)
  x <- package_downloads[i,2]
  a<-rapply(package_dependencies(package_downloads$package[i], which=c("Depends", "Imports", "LinkingTo"), reverse=TRUE), as.character)
  if(length(a)>0){
    names(a) <- NULL
    for(j in 1:length(a)){
      if(a[j] %in% package_downloads$package){
        b <- filter(package_downloads, package==a[j])[,2]
        x <- x-(.8*b)
      }
    }
  }
  z[i] <- x
}

index <- data.frame(package=head(package_downloads$package,300), i=z)
index <- mutate(index, raw_rank=c(1:300))
index <- arrange(index, desc(i))
index <- mutate(index, index_rank=c(1:300))

