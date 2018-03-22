# Getting and Cleaning Data

# Load Packages
packages <- c("data.table","reshape2")
sapply(packages,require,character.only=TRUE,quietly=TRUE)

# Set directory and url
path <- getwd()

# Download and unzip data
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,file.path(path,"dataset.zip"))
unzip(zipfile="dataset.zip")

# Load activity labels and features on the mean and standard deviation for each measurement
activityLabels <- fread(file.path(path,"UCI HAR Dataset/activity_labels.txt"),col.names=c("classLabels","activityName"))
features <- fread(file.path(path,"UCI HAR Dataset/features.txt"),col.names=c("index","featureNames"))
featuresWanted <- grep("(mean|std)\\(\\)",features[,featureNames])
measurements <- features[featuresWanted,featureNames]
measurements <- gsub('[()]','',measurements)

# Load train datasets
train <- fread(file.path(path,"UCI HAR Dataset/train/X_train.txt"))[,featuresWanted,with=FALSE]
test <- fread(file.path(path,"UCI HAR Dataset/test/X_test.txt"))[,featuresWanted,with=FALSE]
data.table::setnames(train,colnames(train),measurements)
data.table::setnames(test,colnames(test),measurements)
trainAct <- fread(file.path(path,"UCI HAR Dataset/train/Y_train.txt"),col.names=c("Activity"))
testAct <- fread(file.path(path,"UCI HAR Dataset/test/Y_test.txt"),col.names=c("Activity"))
trainSub <- fread(file.path(path,"UCI HAR Dataset/train/subject_train.txt"),col.names=c("SubjectNum"))
testSub <- fread(file.path(path,"UCI HAR Dataset/test/subject_test.txt"),col.names=c("SubjectNum"))
train <- cbind(trainSub,trainAct,train)
test <- cbind(testSub,testAct,test)

# Merges the training and the test sets to create one data set
comb <- rbind(train, test)

# Convert classLabels to activityName
comb[["Activity"]] <- factor(comb[,Activity],levels=activityLabels[["classLabels"]],labels=activityLabels[["activityName"]])
comb[["SubjectNum"]] <- as.factor(comb[,SubjectNum])
comb <- reshape2::melt(data=comb,id=c("SubjectNum","Activity"))
comb <- reshape2::dcast(data=comb,SubjectNum+Activity~variable,fun.aggregate=mean)

# Write tidy dataset to file
write.table(comb,file="tidy.txt",row.names=FALSE,col.names=TRUE)
