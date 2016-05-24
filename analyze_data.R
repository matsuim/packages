## top 20 packages
tail(sort(table(downloads$package)), 20)
## create a data table of packages and download numbers
package_downloads<-as.data.frame(table(downloads$package))
names(package_downloads)<- c("package","downloads")
library(dplyr)
# sort by download number
package_downloads <- arrange(package_downloads, desc(downloads))

# add rank column
barplot(head(package_downloads$downloads,10), names.arg=head(package_downloads$package,10))
package_downloads <- mutate(package_downloads, rank=c(1:9704))

# reverse dependencies and reverse imports
library(tools)
package_downloads <- mutate(package_downloads, rv_dp=lengths(package_dependencies(package_downloads$package, which=c("Depends", "Imports"), reverse=TRUE)))

save(package_downloads, file="package_downloads.Rdata")

##operating systems
os<-as.data.frame(table(downloads$r_os))

##r versions
r_vers<-as.data.frame(table(downloads$r_version))

substr(r_vers$Var1,1,1)
gsub(".","", r_vers$Var1)
r_vers$Var1


## countries
countries <- as.data.frame(table(downloads$country))
names(countries) <- c("country", "freq")
countries <- arrange(countries, desc(freq))
