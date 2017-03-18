
if(!file.exists("household_power_consumption.txt")) {
  data_location <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(data_location, destfile = "household_power_consumption.zip")
  unzip("household_power_consumption.zip")
  file.remove("household_power_consumption.zip")
}

power_consumption <- read.csv("household_power_consumption.txt", sep = ";", na.strings = "?")
power_consumption$Date <- as.Date(power_consumption$Date, format = "%d/%m/%Y")
power_consumption$Time <- strptime(power_consumption$Time, format = "%H:%M:%S")


hist(as.numeric(power_consumption$Global_active_power), breaks = 10,
     freq = T,
     main = "Global Active Power",
     xlab = "Global Active Power (Kilowatts)",
     col = "red")
