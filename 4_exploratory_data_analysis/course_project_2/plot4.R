library("ggplot2")

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

combustionRelated <- grepl("comb", SCC$SCC.Level.One, ignore.case=TRUE)
coalRelated <- grepl("coal", SCC$SCC.Level.Four, ignore.case=TRUE) 
combustionSCC <- SCC[(combustionRelated & coalRelated),]$SCC
combustionNEI <- NEI[NEI$SCC %in% combustionSCC,]

png("plot4.png", width=480, height=480)

ggplot(combustionNEI,aes(factor(year), Emissions/10^5)) +
  geom_bar(stat="identity", fill="#FF9999", width=0.75) +
  labs(x="year", y=expression("Total PM"[2.5]*" Emission (10^5 Tons)")) + 
  labs(title=expression("PM"[2.5]*" Coal Combustion Source Emissions Across US from 1999-2008"))

dev.off()