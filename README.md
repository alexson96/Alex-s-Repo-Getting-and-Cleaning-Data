# Alex-s-Repo-Getting-and-Cleaning-Data
#Merges the training and the test sets to create one data set.
#Extracts only the measurements on the mean and standard deviation for each measurement.
#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive variable names.
#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#Download the file
if(!file.exists("./data")){
  dir.create("./data")
}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data/Dataset.zip")
unzip(zipfile = "./data/Dataset.zip", exdir = "./data")
files_all <- file.path("./data", "UCI HAR Dataset")
files <- list.files(files_all, recursive = TRUE)
files

#Reading file-specific data

#Test
dataActivityTest <- read.table(file.path(files_all, "test", "Y_test.txt"), header = FALSE)
dataSubjectTest <- read.table(file.path(files_all, "test", "subject_test.txt"), header = FALSE)
dataFeaturesTest <- read.table(file.path(files_all, "test", "X_test.txt"), header = FALSE)

#Train
dataActivityTrain <- read.table(file.path(files_all, "train", "Y_train.txt"), header = FALSE)
dataFeaturesTrain <- read.table(file.path(files_all, "train", "X_train.txt"), header = FALSE)
dataSubjectTrain <- read.table(file.path(files_all, "train", "subject_train.txt"), header = FALSE)

#looking at the data properties
str(dataActivityTest)

str(dataActivityTrain)

str(dataSubjectTrain)

str(dataSubjectTest)

str(dataFeaturesTest)

str(dataFeaturesTrain)

#Merging Train + Test --> One Data Set

  #concatenate data tables by rows
dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity <- rbind(dataActivityTrain, dataActivityTest)
dataFeatures <- rbind(dataFeaturesTrain, dataFeaturesTest)

  #give the variables names
names(dataSubject) <- c("subject")
names(dataActivity) <- c("activity")
dataFeaturesNames <- read.table(file.path(files_all, "features.txt"), head = FALSE)
names(dataFeatures) <- dataFeaturesNames$V2

  #Merge columns
dataSnA <- cbind(dataSubject, dataActivity)
AlldaData <- cbind(dataFeatures, dataSnA)

#Taking out just the measurements for mean and sd
  #Subset Name of Features by measurements on the mean and standard deviation
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









