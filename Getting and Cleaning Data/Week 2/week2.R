library(httr)

# 1. Find OAuth settings for github:
#    http://developer.github.com/v3/oauth/
oauth_endpoints("github")

# 2. To make your own application, register at at
#    https://github.com/settings/applications. Use any URL for the homepage URL
#    (http://github.com is fine) and  http://localhost:1410 as the callback url
#
#    Replace your key and secret below.
myapp <- oauth_app("Coursera",
                   key = "25d74dd2a8b16220bbd5",
                   secret = "ad3a594b4ebec0f476a966635c79035f577c4941")

# 3. Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

# 4. Use API
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/users/jtleek/repos", gtoken)
stop_for_status(req)
data <- content(req)
list(data[[11]]$name, data[[11]]$created_at)



library(sqldf)
library(XML)
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv", "acs.csv")
acs <- read.csv("acs.csv")


connection <- url("http://biostat.jhsph.edu/~jleek/contact.html")
htmlCode <- readLines(connection)
close(connection)
rows <- c(10,20,30,100)
nchar(htmlCode[rows])

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for", "data.for")
data <- read.fwf("data.for", widths = c(12, 7, 4, 9, 4, 9, 4, 9, 4), skip = 4)
sum(data[,4])
