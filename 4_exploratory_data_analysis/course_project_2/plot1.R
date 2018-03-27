NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

aggTotals <- aggregate(Emissions ~ year, NEI, sum)

png("plot1.png", width=480, height=480)

barplot(aggTotals$Emissions/100000, names.arg=aggTotals$year, xlab="Years", ylab="Emissions/100000", main="Emissions over the Years")

dev.off()