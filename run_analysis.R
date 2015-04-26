
if(!file.exists("./data")){
  dir.create("./data")
}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data/Dataset.zip")
unzip(zipfile = "./data/Dataset.zip", exdir = "./data")
files_all <- file.path("./data", "UCI HAR Dataset")
files <- list.files(files_all, recursive = TRUE)
files
dataActivityTest <- read.table(file.path(files_all, "test", "Y_test.txt"), header = FALSE)
dataSubjectTest <- read.table(file.path(files_all, "test", "subject_test.txt"), header = FALSE)
dataFeaturesTest <- read.table(file.path(files_all, "test", "X_test.txt"), header = FALSE)
dataActivityTrain <- read.table(file.path(files_all, "train", "Y_train.txt"), header = FALSE)
dataFeaturesTrain <- read.table(file.path(files_all, "train", "X_train.txt"), header = FALSE)
dataSubjectTrain <- read.table(file.path(files_all, "train", "subject_train.txt"), header = FALSE)
str(dataActivityTest)

str(dataActivityTrain)

str(dataSubjectTrain)

str(dataSubjectTest)

str(dataFeaturesTest)

str(dataFeaturesTrain)


dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity <- rbind(dataActivityTrain, dataActivityTest)
dataFeatures <- rbind(dataFeaturesTrain, dataFeaturesTest)

names(dataSubject) <- c("subject")
names(dataActivity) <- c("activity")
dataFeaturesNames <- read.table(file.path(files_all, "features.txt"), head = FALSE)
names(dataFeatures) <- dataFeaturesNames$V2

dataSnA <- cbind(dataSubject, dataActivity)
AlldaData <- cbind(dataFeatures, dataSnA)

subdataFeaturesNames <- dataFeaturesNames$V2[grep("mean\\(\\) | std\\(\\)", dataFeaturesNames$V2)]
  #subset dataframe by selected names of Features
selectedNames <- c(as.character(subdataFeaturesNames), "subject", "activity")
AlldaData <- subset(AlldaData, select = selectedNames)
  #check structure
str(AlldaData)
#descriptive activity names --> naming activities in data set
  #reading the names
activityLabels <- read.table(file.path(files_all, "activity_Labels.txt"), header = FALSE)
  #factorize Variable activity in data frame using descriptive activity names
  #check
head(AlldaData$activity, 30)

#Appropriate labeling data set with good names
names(AlldaData) <- gsub("^t", "time", names(AlldaData))
names(AlldaData) <- gsub("^f", "frequency", names(AlldaData))
names(AlldaData) <- gsub("Acc", "Accelerometer", names(AlldaData))
names(AlldaData) <- gsub("Gyro", "Gyroscope", names(AlldaData))
names(AlldaData) <- gsub("Mag", "Magnitude", names(AlldaData))
names(AlldaData) <- gsub("BodyBody", "body", names(AlldaData))

#Creating second, independent tidy data set
library(plyr);
AlldaData2 <- aggregate(. ~subject + activity, AlldaData, mean)
AlldaData2 <- AlldaData2[order(AlldaData2$subject, AlldaData2$activity),]
write.table(AlldaData2, file = "tidydata.txt", row.name = FALSE)

#Producing Codebook
library(knitr)
knit2html("codebook.Rmd");









