rm(list = ls())
library(nlme)
library(lme4)
library(splines2)
library(lmerTest)
library(effects)
library(segmented)
library(dplyr)

############## load files #################

alldata <- read.csv("mls_sd_age_merged_cleaned.csv")
alldata$Target <- as.factor(alldata$Target)
alldata$sex <- as.factor(alldata$sex)

############## identify transition points #################

model1 <- lme(sd1 ~ sex * ScanAge , random = ~1|Target, data = alldata, na.action = na.omit)
pw_model1.seg <- segmented.lme(model1, seg.Z= ~ ScanAge, npsi = 1,psi=18,
                               random=list(sex=pdDiag(~1 + U + G0)),
                               control=seg.control(n.boot=0, display=TRUE))
fixation_vals <-unique(pw_model1.seg$psi.i)  # give turninging point

model2 <- lme(sd2 ~ sex * ScanAge , random = ~1|Target, data = alldata, na.action = na.omit)
pw_model2.seg <- segmented.lme(model2, seg.Z= ~ ScanAge, npsi = 1,psi=18,
                               random=list(sex=pdDiag(~1 + U + G0)),
                               control=seg.control(n.boot=0, display=TRUE))
highcog_vals <-unique(pw_model2.seg$psi.i)  # give turninging point

model3 <- lme(sd3 ~ sex * ScanAge , random = ~1|Target, data = alldata, na.action = na.omit)
pw_model3.seg <- segmented.lme(model3, seg.Z= ~ ScanAge, npsi = 1,psi=18,
                               random=list(sex=pdDiag(~1 + U + G0)),
                               control=seg.control(n.boot=0, display=TRUE))
lowcog_vals <-unique(pw_model3.seg$psi.i)  # give turninging point

model4 <- lme(sd4 ~ sex * ScanAge , random = ~1|Target, data = alldata, na.action = na.omit)
pw_model4.seg <- segmented.lme(model4, seg.Z= ~ ScanAge, npsi = 1,psi=18,
                               random=list(sex=pdDiag(~1 + U + G0)),
                               control=seg.control(n.boot=0, display=TRUE))
cue_vals <-unique(pw_model4.seg$psi.i)  # give turninging point


