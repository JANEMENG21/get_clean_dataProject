#run_analysis.R

#1. Merges the training and the test sets to create one data set.
# read the training data
trainX <- read.table("train/X_train.txt", header = FALSE)
trainy <- read.table("train/y_train.txt", header = FALSE)
trains <- read.table("train/subject_train.txt", header = FALSE)
# combine the "subject", "activity" and 561 feature variables
traind <- cbind(trains, trainy, trainX)

# read the test data
testX <- read.table("test/X_test.txt", header = FALSE)

testy <- read.table("test/y_test.txt", header = FALSE)
tests <- read.table("test/subject_test.txt", header = FALSE)
# combine the "subject", "activity" and 561 feature variables
testd <- cbind(tests, testy, testX)

# merge the training and test data
alld <- rbind(traind, testd)

#2. Extracts only the measurements on the mean and standard deviation for each measurement.
feature_names <- read.table("features.txt", header = FALSE, colClasses = "character")
# use "grep" to get the index, and shift the indices right by 2, because the first 2 columns are "subject" and "activity"
index <- c(1:2, grep("-(mean|std)\\(", feature_names[[2]]) + 2)
mean_std_dat <- alld[index]

#3. Uses descriptive activity names to name the activities in the data set
# name the activities in mean_std_dat with descriptive activity names
actlabels <- read.table("activity_labels.txt", header = FALSE)
mean_std_dat <- merge(mean_std_dat, actlabels, by.x = 2, by.y = 1)
# remove the first column
mean_std_dat <- mean_std_dat[-1]

#4. Appropriately labels the data set with descriptive variable names.
# the name of the first and last columns should be "subject" and "activity", others should be extracted from feature names by using "grep" and regular expression
varnames <- c("subject",feature_names[[2]][grep("-(mean|std)\\(", feature_names[[2]])], "activity")
names(mean_std_dat) <- varnames

# generate a new data set whith the average of each variable for each subject on each activity
library("data.table")
mean_std_dat <- as.data.table(mean_std_dat)
#with data.table, ".SD" refers to all the comumns except the group columns, in this context, the group columns are "subject" and "activity"
tidydata<-mean_std_dat[,lapply(.SD,sum),by=.(subject,activity)]

tidy_data=tidydata
#the row number of the result is 180, because there are 30 subjects and 6 activities, and I sort it by "activity"
setorder(tidy_data, activity)
write.table(tidy_data, file = "tidydata.txt", row.names = FALSE)

# I looked through several other's code to find out the solution of my bugs
