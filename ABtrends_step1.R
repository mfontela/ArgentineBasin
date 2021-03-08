# Load GLODAP ------------------------------------------------------------
local_file=0 #Faster when local file is available, obvious.
if (local_file) {
  A<-readMat("GLODAPv2.2020_Atlantic_Ocean.mat") #find your local copy of file GLODAPv2.2020_Atlantic_Ocean.mat 
} else{
  #Alternative: download the .mat file directly from the GLODAPv2 web (https://www.glodap.info/index.php/merged-and-adjusted-data-product/)
  library(utils)
  download.file("https://www.glodap.info/glodap_files/v2.2020/GLODAPv2.2020_Atlantic_Ocean.mat", "GLODAPv2.2020_Atlantic_Ocean.mat")
  A<-readMat("GLODAPv2.2020_Atlantic_Ocean.mat")
}
#Keep the expocode and their correspondence with G2cruise (expocodeno)
expocodes<-data.frame(); expocodes<-as.data.frame(unlist(A$expocode))
expocodes[,2]<-as.data.frame(unlist(A$expocodeno))
names(expocodes)<-c("expocode","expocodeno")
A<-list.remove(A, c("expocode", "expocodeno")) #To ease things when converting from list to data.frame
A<-as.data.frame(A)


# Filtering --------------------------------------------------
source(file = 'ABasin_definition.R')

A<-A%>%
  filter(G2latitude>=(min(ABasin$lat)) & G2latitude<=(max(ABasin$lat)))%>%
  filter(G2longitude>=(min(ABasin$lon)) & G2longitude<=(max(ABasin$lon)))%>% #Un box de latitude y longitude
  mutate_all(.funs = funs(ifelse(. == "NaN", NA, .)))%>% #because it's a .mat file 
  filter(!G2year %in% c(1999, 2003, 2005, 2010, 2011, 2012, 2014))%>% #To remove some years with data that is too much geographical limited
  mutate(layer=ifelse(G2pressure>=100 & G2sigma0<=26.5, "SACW",  #Layer separation
                      ifelse(G2sigma0>26.5 & G2sigma0<=27.1,"SAMW",
                             ifelse(G2sigma0>27.1 & G2sigma0<=27.4, "AAIW",
                                    ifelse(G2sigma0>27.4 & G2sigma4<=45.9, "CDW-NADW",
                                           ifelse(G2sigma4>45.9,"AABW",NA))))))%>%
  filter(!is.na(layer)) #Delete the NA values in layer (surface points)


ord <- c("SACW", "SAMW", "AAIW", "CDW-NADW", "AABW")
A$layer <- factor(A$layer,levels=ord)

# CO2 system calculations ---------------------------------------------

# 1) set the flag
# #set_the_flag (seacarb couple of variables)
# #AIM: 	
# select the couple of variables available. The flags which can be used are:
# flag = 1 pH and CO2 given
# flag = 2 CO2 and HCO3 given
# flag = 3 CO2 and CO3 given
# flag = 4 CO2 and ALK given
# flag = 5 CO2 and DIC given
# flag = 6 pH and HCO3 given
# flag = 7 pH and CO3 given
# flag = 8 pH and ALK given
# flag = 9 pH and DIC given
# flag = 10 HCO3 and CO3 given
# flag = 11 HCO3 and ALK given
# flag = 12 HCO3 and DIC given
# flag = 13 CO3 and ALK given
# flag = 14 CO3 and DIC given
# flag = 15 ALK and DIC given
# flag = 21 pCO2 and pH given
# flag = 22 pCO2 and HCO3 given
# flag = 23 pCO2 and CO3 given
# flag = 24 pCO2 and ALK given
# flag = 25 pCO2 and DIC given


A<-A%>% # ADD THE FLAG
  mutate(flag=ifelse(G2talkf==2 & G2tco2f==2, 15, #3069 flag 15 Alk & DIC
                     ifelse(G2talkf==2 & G2tco2f==0 & G2phtsinsitutpf==2,8, #1868 flag 8 pH & Alk
                            ifelse(G2talkf==0 & G2tco2f==2 & G2phtsinsitutpf==2, 9,NA))))%>% #188 flag 9 pH & DIC
  arrange(flag)


# CO2 calculations with seacarb
A<-filter(A, (!is.na(G2salinity)))
A<-filter(A, (!is.na(G2theta))) #It can't have NA neither in theta or salinity


extendedA<-bind_cols(A[,1:ncol(A)-1], #To delete the flag column
                carb(flag=A$flag, 
                     var1=ifelse(A$flag==15, A$G2talk/10^6, 
                                 ifelse(A$flag==9,A$G2phtsinsitutp,
                                        ifelse(A$flag==8,A$G2phtsinsitutp,NA))),
                     var2=ifelse(A$flag==15, A$G2tco2/10^6, 
                                             ifelse(A$flag==9,A$G2tco2/10^6,
                                                    ifelse(A$flag==8,A$G2talk/10^6,NA))),                                 
                     A$G2salinity, 
                     A$G2theta, 
                     A$G2pressure/10, #pressure in bar!
                     Patm=1.0, 
                     Pt=A$G2phosphate/10^6, #Nutrients in mols/Kg
                     Sit=A$G2silicate/10^6,
                     pHscale="T", kf="pf", k1k2="l", ks="d", b="u74"))

# compute xcCO3 -----------------------------------------------------------

extendedA<-mutate(extendedA,
             xcCO3=CO3-(CO3/OmegaAragonite))


# add CCHDO data ----------------------------------------------------------

source('CCHDO_data.R')

all<-full_join(extendedA, extendedCCHDO)
ord <- c("SACW", "SAMW", "AAIW", "CDW-NADW", "AABW")
all$layer <- factor(all$layer,levels=ord)

# Add atmospheric CO2 -----------------------------------------------------

source("annual_pCO2atm.R")
#A CO2 data.frame with year and ppm annual concentration at South Pole [South Hemisphere representative]
CO2<-rename(CO2, G2year=year) #To match the name in G2
all<-left_join(all, CO2, by="G2year")

source("monthly_pCO2atm.R")
mCO2<-mCO2%>%
  rename(G2year=year, G2month=month, mppm=ppm)%>% #To match the name in G2
  select(G2year, G2month, mppm)
all<-left_join(all, mCO2, by=c("G2year", "G2month"))

#add an unique ID for Cant exportation
all<-mutate(all,ID=seq_len(nrow(all)))

