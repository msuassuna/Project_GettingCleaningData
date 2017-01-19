### Description of how the script works

Script was constructed trying to respect the steps described in the instructions.

You should create one R script called run_analysis.R that does the following:
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Downloading and storing data

Working directory was defined using setwd() command.
The directory "data" was created to store raw data.
The url where the data is available was assigned as "fileUrl" and it was downloaded using download.file() function.
Downloaded files must be unziped. I used unzip() funtion and defined the directory to extract files to with "exdir = data" argumment.

## 1. Merging training and test data sets to create one new data set.
"x_train.txt" and "x_test.txt" files were read using read.table().
"x_train.txt" has 7352 rows and 561 columns while "x_test.txt" has 2947 and 561 columns.
Each one of the 561 columns corresponds to one measured feature.
Data were binded with rbind() command and a new data set was created by the name "mergedData" with 10299 rows.
I erased x_train and x_test as they are not necessary anymore.

## 2. Extracting only the measurements on the mean and standard deviation for each measurement.
Features were obtained in "features.txt" file and those that contain "mean" or "std" on the name were selected using grep() function.
All variables with mean, Mean or std on its name were selected using grep() function. It doesn't seem to be a bad criteria after reading "features_info.txt" file for this project purposes. It includes, for example, angle measures of some variables.
The selection of those variables was used to subset mergeData. From now on, the number of columns of this data set is 86.

## 3. Descriptive activity names to name the activities in the data set
Each activity name were obtained in "y_train.txt" and "y_test.txt" files. After merging the file, the names of the activities were merged to the activity data set by subseting, and not using "merge" function. Doing so, I can control the order of the rows, as "merge" changes rows order.
I created "mergedActivity2" so I could compare and check if the order of continued the same. I did it suming a logical vector.
In this step I also binded "Subject" information, using "subject_train.txt" and "subject_test.txt" files.

## 4. Appropriately labels the data set with descriptive variable names.
Variables names are "Subject","Activity" (code and name) and each one of the features measured.
Selected features were used to name columns, from the 4th until the last one.

## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
Using the data set in step 4, two functions were used to create tidy data with average of each variable. The first one was group_by() and the second on was sumamarise_all().
group_by() was used to group the data set by Subject and Activity. summarise_all() was used in order to summarise all columns by its means according to a given set of Subject and Activity.
write.table() function was used to write the tidy data set. "row.name=FALSE" argument was used. I also used write.csv2 in my machine so I could check if tidy data set was in fact tidy.