download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv", "q1data.csv")

data <- read.csv("q1data.csv")

strsplit(names(data), split = "wgtp")[123]


q2Data <- read.csv("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv", skip = 4, nrows = 190)
q2Data$X.4 <- as.numeric(gsub(",", "", q2Data$X.4))
mean(q2Data$X.4, na.rm = T)


q4Data <- read.csv("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv")

mergedDF <- merge(q2Data, q4Data, by.x = 'X', by.y = 'CountryCode')

mergedDF$Special.Notes[grep("fiscal.*june", mergedDF$Special.Notes, ignore.case = T)]



library(quantmod)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn)
timesDF <- data.frame(sampleTimes = sampleTimes,
                      dayOfWeek = format(sampleTimes, "%a"),
                      year = format(sampleTimes, "%Y"))

nrow(timesDF[which(timesDF$year == 2012),])
nrow(timesDF[which(timesDF$year == 2012 & timesDF$dayOfWeek == "Mon"),])
