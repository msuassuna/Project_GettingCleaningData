# Set working directory
setwd("~/Specialization_DataScience/3_DataCleaning/Week4/Assignment")

# Downloading and storing data
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")
unzip(zipfile="./data/Dataset.zip",exdir="./data")

# Merging the training and the test sets to create one data set
trainData <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
testData <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
mergedData <- rbind(trainData,testData)
rm(trainData,testData) # Erase data to save some storage memory

# Extracting only the measurements on the mean and standard deviation for each measurement.
features <- read.table("./data/UCI HAR Dataset/features.txt")
features <- features[,2]
select <- grep("[Mm]ean|[Ss]td", features)
mergedData <- subset(mergedData, select = select)

# Assigniing descriptive activity names to name the activities in the data set
trainActivity <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
testActivity <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
mergedActivity <- rbind(trainActivity,testActivity)
rm(trainActivity,testActivity)

library(dplyr)
activities <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
mergedActivity2 <- mutate(mergedActivity, NameActivity = activities[mergedActivity[,1],2])
sum(mergedActivity2[,1] == mergedActivity[,1]) == nrow(mergedActivity2) # Just to verify if merging is ok

# In this step I merge also subject information to mergedData
trainSubject <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
testSubject <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
mergedSubject <- rbind(trainSubject,testSubject)
rm(trainSubject,testSubject)

mergedData <- cbind(mergedSubject,mergedActivity2, mergedData)

# 4. Appropriately labels the data set with descriptive variable names.
names(mergedData)[1:2] <- c("Subject","Activity")
names(mergedData)[4:ncol(mergedData)] <- as.character(features[select])

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
groupSet <- group_by(mergedData, Subject, Activity, NameActivity)
tidySet <- summarise_all(groupSet,mean)

write.table(tidySet, "tidySet.txt", row.name=FALSE)
write.csv2(tidySet, "tidySet.csv")