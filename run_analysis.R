# this program reads in both the test and the train datasets, combines them into one, extracts the mean and standard deviation
# measurements to a new dataset, groups it by subject id and activity, calculates the average values 
# and writes to a table for output
features <- read.table("features.txt")
actlbl <- read.table("activity_labels.txt")
# create the train data.frame
x_train<-read.table("train/x_train.txt")
colnames(x_train) <- features[[2]]
subject_train <- read.table("train/subject_train.txt")
y_train <- read.table("train/y_train.txt", colClasses="factor")
levels(y_train[[1]])<-actlbl[[2]]
x_train$activity<-y_train[[1]]
x_train$subject_id<-subject_train[[1]]
# create the test data.frame
x_test <- read.table("test/x_test.txt")
colnames(x_test) <- features[[2]]
subject_test <- read.table("test/subject_test.txt")
y_test <- read.table("test/y_test.txt", colClasses="factor")
levels(y_test[[1]])<-actlbl[[2]]
x_test$activity<-y_test[[1]]
x_test$subject_id<-subject_test[[1]]
# combine the test and train data.frames
x_all <- rbind(x_train, x_test)
# tidy up the variable names
valid_column_names <- make.names(names=names(x_all), unique=TRUE, allow_ = TRUE)
names(x_all)<-valid_column_names
# extract the needed parts, group them and do the averaging
library(dplyr)
extract <- select(x_all, subject_id, activity, contains(".mean."), contains(".std."))
tidy <- summarise_each(group_by(extract, subject_id, activity),funs(mean))
write.table(tidy, file="tidy.txt", row.name=FALSE)
