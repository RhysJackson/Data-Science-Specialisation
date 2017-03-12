download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv", "data.csv")
data <- read.csv("data.csv")


data$agricultureLogical <- data$AGS == 6 & data$ACR == 3
data[which(data$agricultureLogical)]



library(jpeg)
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg", "instructor.jpg", mode = "wb")
jpg <- readJPEG("instructor.jpg", native = T)
quantile(jpg, probs = c(0.3, 0.8))




gdpData <- read.csv("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv", skip = 4, nrows = 231)
gdpData <- gdpData[!gdpData$X == "", ]
gdpData <- gdpData[, c(1,2,4,5)]
names(gdpData) <- c("CountryCode", "rankingGDP", "Long.Name", "gdp")

eduData <- read.csv("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv")
df <- merge(eduData, gdpData, by = c("CountryCode"), all = T)
df <- df[order(df$rankingGDP, decreasing = T), ]
sum(!is.na(unique(df$rankingGDP)))
df$Long.Name.x[13]


tapply(df$rankingGDP, df$Income.Group, mean, na.rm = T)

breaks <- quantile(df$rankingGDP, probs = c(0,0.2,0.4,0.6,0.8,1), na.rm = TRUE)
df$quantileGDP <- cut(df$rankingGDP, breaks = breaks)
table(df$Income.Group, df$quantileGDP)