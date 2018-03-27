NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

NEI <- NEI[NEI$fips=="24510",]

aggTotals <- aggregate(Emissions ~ year, NEI, sum)

png("plot2.png", width=480, height=480)

barplot(aggTotals$Emissions/1000, names.arg=aggTotals$year, xlab="Years", ylab="Emissions/1000", main="Emissions over the Years")

dev.off()