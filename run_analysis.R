#By Saide
#Please see README_Tidy_Data_Project.txt for details

myRawdatapath<-"~/Courses/Getting and Cleaning Data 2015/Project/ProjectDataCleaning"
myTestpath<-"~/Courses/Getting and Cleaning Data 2015/Project/ProjectDataCleaning/UCI HAR Dataset/test"
myTrainpath<-"~/Courses/Getting and Cleaning Data 2015/Project/ProjectDataCleaning/UCI HAR Dataset/train"
myUCIPath<-"~/Courses/Getting and Cleaning Data 2015/Project/ProjectDataCleaning/UCI HAR Dataset"


data_url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

  if(!file.exists(myUCIPath)){
    download.file(data_url, destfile="./raw_data")
    unzip("raw_data")
  }


ptm <- proc.time()


library(plyr)
library(dplyr)


Subject_Activity_Temp_df <- function (df, Row_list,i,j ){
  
  Num_indexed_rows<-length( Row_list)
  Num_Col<-ncol(df)
  Temp_df<-data.frame(matrix(ncol = Num_Col, nrow = Num_indexed_rows)) 
  rownames(Temp_df) <- 1:Num_indexed_rows  
  colnames(Temp_df)<- colnames(df)
  
  
  for(row_index in 1:Num_indexed_rows){
   
    Temp_df[row_index,]<-  df[ Row_list[row_index],]
    
  }  
  
  return (Temp_df)
  
}

Calc_Summary_Row<- function  (df){
  
  Num_Col<-ncol(df)
  Summary_row_S_A<-data.frame( matrix(ncol = Num_Col, nrow = 1) ) 
  Summary_row_S_A[1,1]<-df[1,1]
  Summary_row_S_A[1,2]<-df[1,2]
  Summary_row_S_A[1,3:Num_Col]<-colMeans(df[,3:Num_Col], na.rm = FALSE)
  colnames(Summary_row_S_A)<-colnames(df)
  
  return(Summary_row_S_A)
}


Update_Tidy_Data_Final <- function (df, summary_row,m){
  
  df<-rbind(summary_row,df)
  
  return(df)    
}

Reduce_df_by_processed_Rows<- function (row_index_list,df){
  
  df<-df[-row_index_list,]
  
  return(df)
  
}


Formulate_row_index_list<- function (df,i,j,key) {
  
  row_index<-NULL  
  z<-nrow(df)
    
  for(k in 1:z) {
    if( df$Subject[k]==i & df[k,2]==key[j,2] ) {   
      row_index<-c(row_index,k)       
    }
  }
  row_index
  return (row_index)
}

Clean_Up<- function (df){
  library(dplyr)
  df<- df[complete.cases(df),]
  df<-arrange(df,Subject,Activity)
  return (df)
}

setwd(myUCIPath)
Features <- read.csv("features_my.txt",header=F,sep=",")

my_Col_Lbls<-as.vector(Features)



setwd(myTrainpath)
Training_df<- read.csv("x_train.txt",header=F,sep="")

colnames(Training_df)<-my_Col_Lbls$V1

Subject_Training<-read.csv("subject_train.txt",header=F,sep="")
ACtivity_Training<-read.csv("y_train.txt",header=F,sep="")

Training_df_master<-Training_df
Training_df_master<-cbind(Activity=ACtivity_Training,Training_df_master)
names(Training_df_master)[1]<-"Activity"
Training_df_master<-cbind(subject=Subject_Training,Training_df_master)
names(Training_df_master)[1]<-"Subject"

setwd(myTestpath)
Test_df<- read.csv("x_test.txt",header=F,sep="")

colnames(Test_df)<-my_Col_Lbls$V1

Subject_Test<-read.csv("subject_test.txt",header=F,sep="")
ACtivity_Test<-read.csv("y_test.txt",header=F,sep="")


Test_df_master<-Test_df

Test_df_master<-cbind(Activity=ACtivity_Test,Test_df_master)
names(Test_df_master)[1]<-"Activity"
Test_df_master<-cbind(subject=Subject_Test,Test_df_master)
names(Test_df_master)[1]<-"Subject"

x<-Test_df_master

y<-Training_df_master

Master_df<-rbind(x,y)


setwd(myUCIPath)
Activities_key<-read.csv("activity_labels.txt", header=F, sep="")


tidy_data<-Master_df


revalue(factor(tidy_data$Activity), c("1" = "WALKING")) -> tidy_data$Activity
revalue(factor(tidy_data$Activity), c("2" = "WALKING_UPSTAIRS")) -> tidy_data$Activity
revalue(factor(tidy_data$Activity), c("3" = "WALKING_DOWNSTAIRS")) -> tidy_data$Activity
revalue(factor(tidy_data$Activity), c("4" = "SITTING")) -> tidy_data$Activity
revalue(factor(tidy_data$Activity), c("5" = "STANDING")) -> tidy_data$Activity
revalue(factor(tidy_data$Activity), c("6" = "LAYING")) -> tidy_data$Activity

m<-grep("mean()", colnames(tidy_data))
s<-grep("std()", colnames(tidy_data))

indeces_means_std_cols<-c(m,s,1,2)

tidy_data2_indeces<-sort(indeces_means_std_cols)
 
tidy_data2<- tidy_data[,tidy_data2_indeces]

tidy_data2<-arrange(tidy_data2,Subject, Activity)

m<-0

data_subset_indices<-list()
data_subset_indices[1:180]<-1:180
num_rows<-nrow(tidy_data2)
number_columns_tidy_data2<-ncol(tidy_data2)

Tidy_Data_Final<-data.frame( (matrix(ncol =number_columns_tidy_data2 , nrow = 1) ) )
rownames(Tidy_Data_Final) <- 1
colnames(Tidy_Data_Final)<- colnames(tidy_data2)


for (i in 1:30){                          
  
  for(j in 1:6){                          
    
      
    row_index_list<-Formulate_row_index_list(tidy_data2,i,j,Activities_key)

    
    Temp_S_A_df<-Subject_Activity_Temp_df (tidy_data2, row_index_list,i,j )
    
   
    Current_Summary_Row_S_A<-Calc_Summary_Row(Temp_S_A_df)
    
    Tidy_Data_Final<-Update_Tidy_Data_Final(Tidy_Data_Final, Current_Summary_Row_S_A,m)
    
    
    tidy_data2<-Reduce_df_by_processed_Rows(row_index_list,tidy_data2)
        
  }        
}



Tidy_Data_Final<-Clean_Up(Tidy_Data_Final)


write.table(Tidy_Data_Final, file="./Saide_Tidy_Data", row.name=FALSE)





