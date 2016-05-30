sortbypackage <- function(downloads, inc_rvdp=TRUE){
## inc_rvdp = TRUE will include reverse depends column
  packages<-as.data.frame(table(downloads$package))
  names(packages)<- c("package","downloads")
  library(dplyr)
  packages <- arrange(packages, desc(downloads))
  packages <- mutate(packages, rank=c(1:length(packages$package)))
  if(inc_rvdp==TRUE){
    library(tools)
    package_downloads <- mutate(packages, rv_dp=lengths(package_dependencies(packages$package, which=c("Depends", "Imports", "LinkingTo"), reverse=TRUE)))
  }
  packages
}
  