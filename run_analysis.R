library(reshape2)

#Get feature list for column headers
features <- read.csv('git/UCI HAR Dataset/features.txt', sep='', head=FALSE)
featurelist <- features[,2]

# Combine train and test data into a single data frame
xtrain <- read.csv('git/UCI HAR Dataset/train/X_train.txt', sep='', head=FALSE)
colnames(xtrain) <- featurelist
ytrain <- read.csv('git/UCI HAR Dataset/train/y_train.txt', head=FALSE)
colnames(ytrain) <- c('Activity')
strain <- read.csv('git/UCI HAR Dataset/train/subject_train.txt', head=FALSE)
colnames(strain) <- c('Subject')
traindata <- cbind(strain, ytrain, xtrain)

xtest <- read.csv('git/UCI HAR Dataset/test/X_test.txt', sep='', head=FALSE)
colnames(xtest) <- featurelist
ytest <- read.csv('git/UCI HAR Dataset/test/y_test.txt', head=FALSE)
colnames(ytest) <- c('Activity')
stest <- read.csv('git/UCI HAR Dataset/test/subject_test.txt', head=FALSE)
colnames(stest) <- c('Subject')
testdata <- cbind(stest, ytest, xtest)

data <- rbind(traindata, testdata)

#Pare down data to just contain mean and std
cols <- grep('mean|std', featurelist)
cols <- c(1,2, cols+2)
subdata <- data[,cols]

#Use activity names
activities <- read.csv('git/UCI HAR Dataset/activity_labels.txt', sep='', head=FALSE)
colnames(activities) <- c('ActivityID', 'ActivityName')
subdata$Activity <- merge(subdata, activities, by.x='Activity', by.y='ActivityID')$ActivityName

#Use proper formatting for column names
colformat <- function(char){
    tolower(gsub('-', '.', gsub('[()]', '', char)))    
}
colnames(subdata) <- sapply(colnames(subdata), colformat)

#Write subdata to file


#Create alternative data that is averagedfor each activity and subject
datamelt <- melt(data, id=c('Subject', 'Activity'))
avgdata <- dcast(datamelt, Subject+Activity ~ variable, mean)
