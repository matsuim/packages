indexfunc <- function(packages, downloads){
## packages is a character vector of package names you want to create indexes for
## downloads is data from sortbypackage
  all_packages <- downloads$package
  all_downloads <- downloads$downloads
  packages <- as.character(packages)
  z <- numeric(length(packages))
  prog <- txtProgressBar(min=0, max=length(packages))
  for(i in 1:length(packages)){
    x<-filter(data.frame(p=all_packages, d=all_downloads), p==packages[i])[,2]
    a<-rapply(package_dependencies(packages[i], which=c("Depends", "Imports", "LinkingTo"), reverse=TRUE), as.character)
    if(length(a)>0){
      names(a) <- NULL
      for(j in 1:length(a)){
        if(a[j] %in% all_packages){
          b <- filter(data.frame(p=all_packages,d=all_downloads), p==a[j])[,2]
          x <- x-(.8*b)
        }
      }
    }
    setTxtProgressBar(prog,i)
    z[i]<-x
  }
  z
}