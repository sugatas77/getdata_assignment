#unzip the downloaded zip file
unzip("getdata-projectfiles-UCI HAR Dataset.zip")



## read data sets into R
# load features and activity labels
features <- read.table("UCI HAR Dataset/features.txt")
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")

# load test data sets
data_test_subject <- read.table("UCI HAR Dataset/test/subject_test.txt")
data_test_x <- read.table("UCI HAR Dataset/test/X_test.txt")
data_test_y <- read.table("UCI HAR Dataset/test/y_test.txt")

# load train data sets
data_train_subject <- read.table("UCI HAR Dataset/train/subject_train.txt")
data_train_x <- read.table("UCI HAR Dataset/train/X_train.txt")
data_train_y <- read.table("UCI HAR Dataset/train/y_train.txt")





## Merge the training and the test sets to create on big data set
# merge subject
subject_all <- rbind(data_test_subject, data_train_subject)
colnames(subject_all) <- "subject_all"

# merge labels
label_names <- rbind(data_test_y, data_train_y)
label_names <- merge(label_names, activity_labels, by = 1)[,2]

# merge all data
data <- rbind(data_test_x, data_train_x)
colnames(data) <- features[,2]
all_data <- cbind(subject_all, label_names, data) #merge all data sets 



# Extracts only the measurements on the mean and standard diviation for each measurement
all_mean <- grep("mean()", colnames(all_data), fixed = TRUE)
all_std <- grep("std()", colnames(all_data), fixed = TRUE)
grep_data <- all_data[,c(1,2,all_mean,all_std)]

## Create a second, independant tidy data set with the average of each variable for each activity and each subject

library(reshape2)
# create the tidy data set
melt_data = melt(grep_data, id.var = c("subject_all", "label_names"))
tidy_data = dcast(melt_data, subject_all + label_names ~ variable, mean)
write.table(tidy_data, file = "tidy_data.txt",  row.name=FALSE)

# print tidy data set
tidy_data
