rm(list=ls())
Sys.setlocale("LC_TIME", "Norwegian")
options(encoding = "UTF-8")
setwd("C:/Users/video/Desktop/flom")
library(ggplot2)
library(tidyverse)
library(chron)
library(lubridate)
rawdata <- readr::read_lines("https://www2.nve.no/h/hd/plotreal/H/0196.00035.000/knekkpunkt.csv")
data <- rawdata
data <- data[-c(1,2)]
data <- sub(",",".",data)
data <- sub(";",",",data)
data <- as.factor(data)
mat1 <- matrix(data,ncol=1,byrow=T)
mat1 <- mat1[-c(1,2),]
d <- as.data.frame(mat1)
d <- separate(d,mat1,into=c("Dato","Vannstand"),sep = "([,])")
d$Vannstand <- as.numeric(d$Vannstand)
d$Dato <- as.POSIXct(d[,1], format="%Y-%m-%d %H:%M")
colnames(d) <- c("Dato","Vannstand")
d <- tibble::rowid_to_column(d, "id")
d$Vannstand <- ifelse(d$id <= 1300, NA,d$Vannstand)
d <- na.omit(d)
plot1 <- ggplot(d,aes(x=Dato,y=Vannstand, group=1)) +
    geom_line(colour="1380A1", size=1) +
    geom_hline(yintercept = 3.68, size = 1, colour = "red", linetype = "dashed") +
    ylab("Vannstand (meter)") +
    ylim(0,5) +
    xlab("") +
    scale_x_datetime(expand=c(0,0),date_labels = "%d. %b") +
    theme_classic() +
    labs(caption="Data: Norges vassdrags- og energidirektorat. Stiplet linje viser vannstand ved middelflom")
ggsave("plot.png",width=5, height=3, units="in",plot=plot1)
