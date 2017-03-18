if(!file.exists("household_power_consumption.txt")) {
  data_location <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(data_location, destfile = "household_power_consumption.zip")
  unzip("household_power_consumption.zip")
  file.remove("household_power_consumption.zip")
}

power_consumption <- read.table("household_power_consumption.txt", sep = ";", na.strings = "?", header = T, stringsAsFactors = F)
power_consumption$Datetime <- strptime(paste(power_consumption$Date, power_consumption$Time), format = "%d/%m/%Y %H:%M:%S")
power_consumption$Date <- as.Date(power_consumption$Date, format = "%d/%m/%Y")
power_consumption$Time <- strptime(power_consumption$Time, format = "%H:%M:%S")

pwr.filtered <- power_consumption[(power_consumption$Date >= as.Date("2007-02-01")) & (power_consumption$Date <= as.Date("2007-02-02")), ]

png(filename = "plot3.png", width = 480, height = 480, units = "px", bg = "transparent")
with(pwr.filtered, plot(type = "l",
                        x = Datetime,
                        y = Sub_metering_1,
                        xlab = "",
                        ylab = "Energy sub metering"))
with(pwr.filtered, lines(x = Datetime, y = Sub_metering_2, col = "red"))
with(pwr.filtered, lines(x = Datetime, y = Sub_metering_3, col = "blue"))
legend(x = "topright", legend = paste0("Sub_metering_", 1:3), lty = 1, col = c("black", "red", "blue"))
dev.off()
