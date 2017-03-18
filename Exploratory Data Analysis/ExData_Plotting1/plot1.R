if(!file.exists("household_power_consumption.txt")) {
  data_location <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(data_location, destfile = "household_power_consumption.zip")
  unzip("household_power_consumption.zip")
  file.remove("household_power_consumption.zip")
}

power_consumption <- read.table("household_power_consumption.txt", sep = ";", na.strings = "?", header = T)
power_consumption$Date <- as.Date(power_consumption$Date, format = "%d/%m/%Y")

pwr.filtered <- power_consumption[(power_consumption$Date >= as.Date("2007-02-01")) & (power_consumption$Date <= as.Date("2007-02-02")), ]

png(filename = "plot1.png", width = 480, height = 480, units = "px", bg = "transparent")
with(pwr.filtered, hist(x = Global_active_power,
                        xlab = "",
                        ylab = "",
                        col = "red"))
dev.off()
