## load data

traindata <- read.table("C:/Users/nashlaur.CSR/Documents/UCI HAR Dataset/train/X_train.txt",header=FALSE,sep="")
testdata <- read.table("C:/Users/nashlaur.CSR/Documents/UCI HAR Dataset/test/X_test.txt",header=FALSE,sep="")
subjecttrain <- read.table("C:/Users/nashlaur.CSR/Documents/UCI HAR Dataset/train/subject_train.txt",header=FALSE,sep="")
subjecttest <- read.table("C:/Users/nashlaur.CSR/Documents/UCI HAR Dataset/test/subject_test.txt",header=FALSE,sep="")
activitytrain <- read.table("C:/Users/nashlaur.CSR/Documents/UCI HAR Dataset/train/y_train.txt",header=FALSE,sep="")
activitytest <- read.table("C:/Users/nashlaur.CSR/Documents/UCI HAR Dataset/test/y_test.txt",header=FALSE,sep="")
features_header <- read.table("C:/Users/nashlaur.CSR/Documents/UCI HAR Dataset/features.txt")


## 1. Merges the training and the test sets to create one data set.

## merge actual data
merged_data <- rbind(traindata,testdata)

## merge subject data
subject_data <- rbind(subjecttrain,subjecttest)

## merge activity data
activity_data <- rbind(activitytrain,activitytest)

## add column names to main data
names(merged_data) <- features_header$V2

## add name to subject column
names(subject_data) <- c("Subject")

## add name to activity column
names(activity_data) <- c("Activity")

## merge subject and activity data together
sub_act_cols <- cbind(subject_data, activity_data)

## merge subject and activity data with main data
all_data <- cbind(merged_data, sub_act_cols)


## 2.	Extracts only the measurements on the mean and standard deviation for each measurement. 

## select only columns with -mean() and -std() in the column name, from the column name file
mean_and_std_names <- grep("(-mean\\(\\)|-std\\(\\))",features_header$V2)

## match this to all data to just pull mean and std data
new_data <- all_data[, mean_and_std_names]

## remerge new data with the subject and activity columns
new_data_2 <- cbind(new_data, sub_act_cols)


## 3. Uses descriptive activity names to name the activities in the data set

## upload activity labels
activity_labels <- read.table("C:/Users/nashlaur.CSR/Documents/UCI HAR Dataset/activity_labels.txt")

## replace activity numeric column with the activity labels
new_data_2$Activity <- activity_labels[new_data_2$Activity,2]


## 4. Appropriately labels the data set with descriptive variable names. 

## completed in above steps


## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## melt data to create new data set each with unique subject & activity
TidyData <- melt(new_data_2, id=c("Subject","Activity"))

## summarize data set by the average per activity and subject
TidyData_mean <- dcast(TidyData, Subject + Activity ~ variable, mean)

## export the data
write.table(TidyData_mean, "TidyData_mean.txt", row.name=FALSE)
