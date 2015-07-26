library(reshape2) ## Included to melt the data


## The files are downloded and alredy placed in the Working Directory and Folder UCI.
#Load the relevant datasets 

#Activity Lables
actLbl <- read.table("./UCI/activity_labels.txt")

#Features 
features <- read.table("./UCI/features.txt")

#Load Training Datasets  
x_train <- read.table("./UCI/train/X_train.txt")
y_train <- read.table("./UCI/train/y_train.txt")
sub_train <- read.table("./UCI/train/subject_train.txt")

#Load test datasets 
x_test <- read.table("./UCI/test/X_test.txt")
y_test <- read.table("./UCI/test/y_test.txt")
sub_test <- read.table("./UCI/test/subject_test.txt")

#Merge Train and test datasets 

train <- cbind(sub_train, y_train, x_train)
test <- cbind(sub_test, y_test, x_test)

final <- rbind(train, test)

#Measures Needed and pull out only Mean and SD Title

measures <- grepl(".*mean.*", features[,2]) | grepl(".*std.*", features[,2])
named.measure <- features[measures,2]

#Give a meaningful name

named.measure <- gsub('-mean', 'Mean', named.measure)
named.measure <- gsub('-std', 'SD', named.measure)
named.measure <- gsub('[()-]', '', named.measure)
named.measure <- gsub('tBody', '', named.measure)
named.measure <- gsub('fBodyBody', '', named.measure)
named.measure <- gsub('fBody', '', named.measure)


# Apply all the col names to the finaldataset 
colnames(final) <- c("subject", "activity", named.measure)

# Factorize Subject and activity - for activity, apply the lables
final$subject <- as.factor(final$subject)
final$activity <- factor(final$activity, labels = actLbl[,2])

# Strip/Melt out only Subject and activity and cast it into a table with the average of each variable for each activity and each subject

melted <- melt(final, id = c("subject", "activity"))
castedTab <- dcast(melted, subject + activity ~ variable, mean)

# Write the data to tidyData.txt
##write.table(castedTab, "tidyData.txt")
write.table(castedTab, "tidyData.txt", row.names = FALSE)


