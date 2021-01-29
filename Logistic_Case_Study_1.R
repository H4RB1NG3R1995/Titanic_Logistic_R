#Logistic Regression Case Study 1

#calling libraries
library(caret)# LOGISTIC MODEL
library(ggplot2)# VISUALIZATION
library(MASS)# VIF CALCULATION
library(car)# VIF CALCULATION
library(mlogit)# LOGISTIC MODEL
library(sqldf)#WOE & IV
library(Hmisc)#WOE & IV
library(aod)#WALD TEST
library(BaylorEdPsych)#R-SQUARE
library(ResourceSelection)#HOSMER LEMESHOW TEST
library(pROC)#ROC CURVE
library(ROCR)#ROC CURVE
library(caTools)#TRAIN AND TEST SPLIT

#setting working directory
Path<-"E:/IVY PRO SCHOOL/R/05 PREDICTIVE ANALYTICS PROJECTS/03 LOGISTIC REGRESSION/CASE STUDY1/02DATA"
setwd(Path)
getwd()

traindata<-read.csv("train.csv", header = TRUE)
testdata<-read.csv("test.csv", header = TRUE)
traindata1<-traindata
testdata1<-testdata

#basic exploration of the data
str(traindata1)
summary(traindata1)
traindata2<-select(traindata1, -c("PassengerId", "Cabin", "Ticket", "Name"))
str(traindata2)
summary(traindata2)


#checking missing values
data.frame(colSums(is.na(traindata2)))

#imputing missing values
traindata2[is.na(traindata2$Age),4]<-mean(traindata2$Age, na.rm = TRUE)
data.frame(colSums(is.na(traindata2)))
str(traindata2)
summary(traindata2)

#Making Survived, Pclass, Sex and Embarked factor variables
traindata2$Survived<-as.factor(traindata2$Survived)
traindata2$Pclass<-as.factor(traindata2$Pclass)
traindata2$Embarked<-as.factor(traindata2$Embarked)
traindata2$Sex<-as.factor(traindata2$Sex)

#Logistic Regression model building
set.seed(143)

#Iteration 1:taking all variables
model<-glm(Survived~., data = traindata2, family = binomial())
summary(model)

#Iteration 2:dropping embarked
model2<-glm(Survived~.-Embarked, data = traindata2, family = binomial())
summary(model2)

#Iteration 3:dropping Parch
model3<-glm(Survived~.-Embarked-Parch, data = traindata2, family = binomial())
summary(model3)

#Iteration 4: dropping fare
model4<-glm(Survived~.-Embarked-Parch-Fare, data = traindata2, family = binomial())
summary(model4) #Final Model

#checking VIF:
as.data.frame(vif(model4))

#CHECKING OVERALL FITNESS
wald.test(b=coef(model4), Sigma= vcov(model4), Terms=1:4)

#predicting power of model
PseudoR2(model4)

#lackfit deviance
residuals(model4) # deviance residuals
residuals(model4, "pearson") # pearson residuals

sum(residuals(model4, type = "pearson")^2)
deviance(model4)

#########Larger p value indicate good model fit
1-pchisq(deviance(model4), df.residual(model4))
#Thus, we accept the Null Hypthesis Ho thet Observed Frequencies = Expected Frequencies


# Coefficients (Odds)
model4$coefficients
# Coefficients (Odds Ratio)
exp(model4$coefficients)#Interpret 


# Variable Importance of the model
varImp(model4)

# Predicted Probabilities
prediction <- predict(model4,newdata = traindata2,type="response")
prediction
max(prediction)
min(prediction)

write.csv(prediction,"pred.csv")


rocCurve   <- roc(response = traindata2$Survived, predictor = prediction, 
                  levels = rev(levels(traindata2$Survived)))

#Metrics - Fit Statistics

predclass <-ifelse(prediction>coords(rocCurve,"best", transpose = TRUE)[1],1,0)
Confusion <- table(Predicted = predclass,Actual = traindata2$Survived)
AccuracyRate <- sum(diag(Confusion))/sum(Confusion)
Gini <-2*auc(rocCurve)-1

AUCmetric <- data.frame(c(coords(rocCurve,"best", transpose = TRUE),AUC=auc(rocCurve),AccuracyRate=AccuracyRate,Gini=Gini))
AUCmetric <- data.frame(rownames(AUCmetric),AUCmetric)
rownames(AUCmetric) <-NULL
names(AUCmetric) <- c("Metric","Values")
AUCmetric

Confusion 
plot(rocCurve)


### KS statistics calculation
traindata2$m1.yhat <- predict(model, traindata2, type = "response")
m1.scores <- prediction(traindata2$m1.yhat, traindata2$Survived)

plot(performance(m1.scores, "tpr", "fpr"), col = "red")
abline(0,1, lty = 8, col = "grey")

m1.perf <- performance(m1.scores, "tpr", "fpr")
ks1.logit <- max(attr(m1.perf, "y.values")[[1]] - (attr(m1.perf, "x.values")[[1]]))
ks1.logit # Thumb rule : should lie between 0.4 - 0.7

###VALIDATION ON TEST DATA

#Processing test data
str(testdata1)
summary(testdata1)
testdata2<-select(testdata1, -c("PassengerId", "Cabin", "Ticket", "Name"))
str(testdata2)
summary(testdata2)

#Coverting relevant variables into factors
names<-c("Sex", "Pclass", "Embarked")
testdata2[,names]<-lapply(testdata2[,names], factor)


#checking missing values
data.frame(colSums(is.na(testdata2)))

#imputing missing values
testdata2[is.na(testdata2$Age),3]<-mean(testdata2$Age, na.rm = TRUE)
testdata2[is.na(testdata2$Fare),6]<-mean(testdata2$Fare, na.rm = TRUE)
data.frame(colSums(is.na(testdata2)))
write.csv(testdata2, "tdata2.csv")
str(testdata2)
summary(testdata2)

#predicting survival of passengers
predicted_survival <- predict(model4,newdata = testdata2,type="response")
predicted_survival

Finaldata<-cbind(testdata2, predicted_survival)
Pred_survival_round<-round(Finaldata$predicted_survival, 1)
Finaldata<-cbind(Finaldata, Pred_survival_round)



Finaldata$Survived<-NULL
Finaldata$Survived<-ifelse(Finaldata$predicted_survival>0.5, Finaldata$Survived<-1, Finaldata$Survived<-0)

write.csv(Finaldata, "finaldata.csv")

