#Prepare packages
source("ABtrends_step0.R")
#create database
t0<-Sys.time()
source("ABtrends_step1.R", encoding="utf-8")
source("ABtrends_step2.R", encoding="utf-8") #Post Cant computation

#plots Main text
guardarfigure=0; viewfigure=0
source("ABtrends_plot_mapFigure1.R") #Figure 1 (Basic)
source("Abtrends_plot_Cant.R") #Figure 4
source("Abtrends_plot_xcCO3.R") #Figure 5

#Tables

#Table 2 main text (statistics and trends) // table Supp. Info 2
source("ABtrends_trends.R")
# Table Supp.Info 3
source("ABtrends_trends_vsYEAR.R")


#Table cruises (Supp. Info Table 1)
source("ABtrends_tablecruises.R") #Table Supp. Info 1

#plots Supp. Info
guardarfigure=0; viewfigure=0
source("ABtrends_plot_SuppInfo1.R") #Figure S1
source("ABtrends_plot_SuppInfo2.R") #Figure S2
source("ABtrends_plot_SuppInfo3.R") #Figure S3
source("ABtrends_plot_SuppInfo4.R") #Figure S4
source("ABtrends_plot_SuppInfo5.R") #Figure S5

print(paste("Done in", ceiling(Sys.time()-t0), "seconds"))
