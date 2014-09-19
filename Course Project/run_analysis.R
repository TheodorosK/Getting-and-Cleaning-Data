library(plyr)

## Loads the Feature Names and Activity Labels
features <- read.table("./features.txt",sep="", stringsAsFactors = F)
colnames(features) <- c("ID","Feature_Name")
activityLabels <-  read.table("./activity_labels.txt",sep="", stringsAsFactors = F)
colnames(activityLabels) <- c("ID","Activity_Label")

# Load the Test data and appropriately label the data set with descriptive variable names
testSubjectData <- read.table("./test/subject_test.txt",sep="", stringsAsFactors = T, col.names ="ID")
testYData <- read.table("./test/y_test.txt",sep="", stringsAsFactors = T, col.names ="Activity")
testXData <- read.table("./test/X_test.txt",sep="", stringsAsFactors = T, col.names =features$Feature_Name)
test <- cbind(testSubjectData,testYData,testXData)

# Load the Train data and appropriately label the data set with descriptive variable names
trainSubjectData <- read.table("./train/subject_train.txt",sep="", stringsAsFactors = T, col.names ="ID")
trainYData <- read.table("./train/y_train.txt",sep="", stringsAsFactors = T, col.names ="Activity")
trainXData <- read.table("./train/X_train.txt",sep="", stringsAsFactors = T, col.names =features$Feature_Name)
train <- cbind(trainSubjectData,trainYData,trainXData)

## Merge the training and the test sets to create one data set
allData <- rbind(train, test)

## Extract only the measurements on the mean and standard deviation for each measurement
std <- grep("std", colnames(allData))
mean <- grep("mean", colnames(allData))
stdMeanData <- allData[,c(1,2,std,mean)]

## Use descriptive activity names to name the activities in the data set
stdMeanData$ActivityLabel <- factor(stdMeanData$Activity, levels=activityLabels$ID, labels=activityLabels$Activity_Label)

## Create a second, independent tidy data set with the average of each variable for each activity and each subject
tidyData <- ddply(stdMeanData, .(ID, Activity, ActivityLabel), .fun=function(x){ colMeans(x[,-c(1,2,82)]) })
