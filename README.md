## course project for Get and Clean Data
# instruction of this repo
"README.md" is an instruction

"run_analysis.R" is the code

"tidydata.txt" is the output of the project

# raw data
 A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

# project requirment
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## TIPS 
#line with bugs/ problems shared(solved by searching other's repo)

index <- c(1:2, grep("-(mean|std)\\(", feature_names[[2]]) + 2)
#use "grep" to get the index, and shift the indices right by 2, because the first 2 columns are "subject" and "activity"

varnames <- c("subject",feature_names[[2]][grep("-(mean|std)\\(", feature_names[[2]])], "activity")
names(mean_std_dat) <- varnames
#the name of the first and last columns should be "subject" and "activity", others should be extracted from feature names by using "grep" and regular expression: ("XXXX)"


tidydata<-mean_std_dat[,lapply(.SD,sum),by=.(subject,activity)]
#with data.table, ".SD" refers to all the comumns except the group columns, in this context, the group columns are "subject" and "activity"
