
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv", "data.csv")
data <- read.csv("data.csv")
nrow(data[which(data$VAL == 24), ])

library(xlsx)
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx", "data.xlsx", mode="wb")
dat <- read.xlsx("data.xlsx", rowIndex = c(18:23), colIndex = c(7:15), sheetName = "NGAP Sample Data")
sum(dat$Zip*dat$Ext,na.rm=T)

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml", "restaurant_data.xml")
require(XML)
restaurant_data <- xmlTreeParse("restaurant_data.xml", useInternalNodes = T)
rootNode <- xmlRoot(restaurant_data)
xPath <- xpathSApply(rootNode,"//zipcode", xmlValue)
tbl <- table(xPath)
tbl[names(tbl) == 21231]


library(data.table)
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv", "q5Data.csv")
DT <- fread("q5Data.csv")
Rprof()
system.time(tapply(DT$pwgtp15,DT$SEX,mean))
system.time(sapply(split(DT$pwgtp15,DT$SEX),mean))
system.time(mean(DT[DT$SEX==1,]$pwgtp15); mean(DT[DT$SEX==2,]$pwgtp15))
system.time(rowMeans(DT)[DT$SEX==1]; rowMeans(DT)[DT$SEX==2])
system.time(mean(DT$pwgtp15,by=DT$SEX))
system.time(DT[,mean(pwgtp15),by=SEX])
