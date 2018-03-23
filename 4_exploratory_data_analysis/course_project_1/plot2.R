library("data.table")

# Reads in data
powerDT <- data.table::fread(input="household_power_consumption.txt",na.strings="?")

# Converts to numeric
powerDT[,Global_active_power:=lapply(.SD,as.numeric),.SDcols=c("Global_active_power")]

# Make datetime column
powerDT[,dateTime:=as.POSIXct(paste(Date,Time),format="%d/%m/%Y %H:%M:%S")]

# Filter dates
powerDT <- powerDT[(dateTime>="2007-02-01")&(dateTime<"2007-02-03")]

## Plot 2
png("plot2.png",width=480,height=480)
plot(x=powerDT[,dateTime],y=powerDT[,Global_active_power],type="l",xlab="",ylab="Global Active Power (kilowatts)")
dev.off()