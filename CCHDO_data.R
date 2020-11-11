#Data from CCHDO
# (that is not in G2)

library(readr)
library(tidyverse)
local=0 #1 load from local file / 0 load from the CCHDO web
# 318MSAVE5 ---------------------------------------------------------------
if (local==0) {
  url <- 'https://cchdo.ucsd.edu/data/2327/a16s_hy1.csv'
  file  <- tempfile()
  download.file(url,file)
} else {
  file<-'~/a16s_hy1.csv'
}

SAVE5 <- read_csv(file, skip=10,
                  col_types = cols(DEPTH = col_number(), CTDRAW = col_number(), CTDPRS = col_number(),
                                   REVPRS = col_number(), REVTMP = col_number(), TIME= col_number(),CTDTMP= col_number(),
                                   CTDSAL= col_number(),SALNTY= col_number(),CTDOXY= col_number(),OXYGEN= col_number(),
                                   SILCAT= col_number(),NITRAT= col_number(),NITRIT= col_number(), PHSPHT= col_number(),
                                   TCARBN= col_number(),ALKALI= col_number(),PCO2= col_number(),THETA= col_number()))
SAVE5<-SAVE5[-1,] #to delete the units row
SAVE5<-SAVE5[-nrow(SAVE5),] #to delete the END_DATA row

# 318MSAVE4 ---------------------------------------------------------------
if (local==0) {
url <- 'https://cchdo.ucsd.edu/data/9581/save4_318M19881207_hy1.csv'
file  <- tempfile()
download.file(url,file)
} else {
  file<-'~/save4_318M19881207_hy1.csv'
}
SAVE4 <- read_csv(file, skip=6, 
                  col_types = cols(DEPTH = col_number(), CTDRAW = col_number(), CTDPRS = col_number(),
                                   REVPRS = col_number(), REVTMP = col_number(), TIME= col_number(),CTDTMP= col_number(),
                                   CTDSAL= col_number(),SALNTY= col_number(),CTDOXY= col_number(),OXYGEN= col_number(),
                                   SILCAT= col_number(),NITRAT= col_number(),NITRIT= col_number(), PHSPHT= col_number(),
                                   TCARBN= col_number(),ALKALI= col_number(),PCO2= col_number(),THETA= col_number()))
SAVE4<-SAVE4[-1,] #to delete the units row
SAVE4<-SAVE4[-nrow(SAVE4),] #to delete the END_DATA row


# 318MHYDROS4 -------------------------------------------------------------
if (local==0) {
url <- 'https://cchdo.ucsd.edu/data/7737/a16c_hy1.csv'
file  <- tempfile()
download.file(url,file)
} else {
  file<-'~/a16c_hy1.csv'
}
HYDROS4 <- read_csv(file, skip=4, 
                    col_types = cols(DEPTH = col_number(), CTDRAW = col_number(), CTDPRS = col_number(),
                                     REVPRS = col_number(), REVTMP = col_number(), TIME= col_number(),CTDTMP= col_number(),
                                     CTDSAL= col_number(),SALNTY= col_number(),CTDOXY= col_number(),OXYGEN= col_number(),
                                     SILCAT= col_number(),NITRAT= col_number(),NITRIT= col_number(), PHSPHT= col_number(),
                                     TCARBN= col_number(),ALKALI= col_number(),PCO2= col_number(),THETA= col_number()))
HYDROS4<-HYDROS4[-1,] #to delete the units row
HYDROS4<-HYDROS4[-nrow(HYDROS4),] #to delete the END_DATA row

# Join'em all -------------------------------------------------------------


fromCCHDO<-full_join(
  full_join(SAVE4, SAVE5), 
  HYDROS4)

# ... and clean the lightning! --------------------------------------------
library(oce)
library(lubridate)
#the box definition (ABasin)
source(file = 'ABasin_definition.R')

fromCCHDO<-fromCCHDO%>%
  filter(LATITUDE>=(min(ABasin$lat)) & LATITUDE<=(max(ABasin$lat)))%>%
  filter(LONGITUDE>=(min(ABasin$lon)) & LONGITUDE<=(max(ABasin$lon)))%>% #Un box de latitude y longitude
  mutate_all(.funs = funs(ifelse(. < (-998), NA, .)))%>% #because -999 is the no-number 
  mutate(DATE=as.Date(as.character(DATE), "%Y%m%d"))%>%
  #calcular las densidades potenciales para poder separar en layers
  mutate(G2sigma0=swSigma0(salinity = SALNTY, temperature = CTDTMP, pressure = CTDPRS))%>%
  mutate(G2sigma1=swSigma1(salinity = SALNTY, temperature = CTDTMP, pressure = CTDPRS))%>%
  mutate(G2sigma2=swSigma2(salinity = SALNTY, temperature = CTDTMP, pressure = CTDPRS))%>%
  mutate(G2sigma3=swSigma3(salinity = SALNTY, temperature = CTDTMP, pressure = CTDPRS))%>%
  mutate(G2sigma4=swSigma4(salinity = SALNTY, temperature = CTDTMP, pressure = CTDPRS))%>%
  #layer separation
  mutate(layer=ifelse(CTDPRS>=100 & G2sigma0<=26.5, "SACW",
                      ifelse(G2sigma0>26.5 & G2sigma0<=27.1,"SAMW",
                             ifelse(G2sigma0>27.1 & G2sigma0<=27.4, "AAIW",
                                    ifelse(G2sigma0>27.4 & G2sigma4<=45.9, "CDW-NADW",
                                                  ifelse(G2sigma4>45.9,"AABW",NA))))))%>%
  filter(!is.na(layer))

ord <- c("SACW", "SAMW", "AAIW", "CDW-NADW", "AABW")
fromCCHDO$layer <- factor(fromCCHDO$layer,levels=ord)


# CO2 system calculations ---------------------------------------------
library(seacarb)
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


fromCCHDO<-fromCCHDO%>% # ADD THE FLAG
  mutate(flag=ifelse(ALKALI_FLAG_W!=9 & TCARBN_FLAG_W!=9, 15, NA))%>% #591 flag 15 Alk & DIC
                     # ifelse(PCO2_FLAG_W!=9 & ALKALI_FLAG_W==9 & TCARBN_FLAG_W!=9,25,NA)))%>% #33 flag 25 pCO2 & DIC
  #something does not work well for the pCO2&DIC combination
  arrange(flag)


# CO2 calculations with seacarb


extendedCCHDO<-bind_cols(fromCCHDO[,1:ncol(fromCCHDO)-1], #para que quite la columna de flag
                     carb(flag=fromCCHDO$flag, 
                          var1=ifelse(fromCCHDO$flag==15, fromCCHDO$ALKALI/10^6, 
                                      ifelse(fromCCHDO$flag==25,fromCCHDO$PCO2,NA)),
                          var2=ifelse(fromCCHDO$flag==15, fromCCHDO$TCARBN/10^6, 
                                      ifelse(fromCCHDO$flag==25,fromCCHDO$TCARBN/10^6,NA)),                                 
                          fromCCHDO$SALNTY, 
                          fromCCHDO$THETA, 
                          fromCCHDO$CTDPRS/10, #pressure in bar!
                          Patm=1.0, 
                          Pt=fromCCHDO$PHSPHT/10^6, #Nutrientes tambien tienen que estar en moles/Kg
                          Sit=fromCCHDO$SILCAT/10^6,
                          pHscale="T", kf="pf", k1k2="l", ks="d", b="u74"))

# compute xcCO3 -----------------------------------------------------------

extendedCCHDO<-extendedCCHDO%>%
  mutate(xcCO3=CO3-(CO3/OmegaAragonite), G2year=year(DATE), G2month=month(DATE))%>%
  #Rename variables to ease things in the posterior join
  rename(G2station=STNNBR, G2cast=CASTNO, G2bottle=SAMPNO, G2latitude=LATITUDE, G2longitude=LONGITUDE,
         G2salinity=SALNTY, G2theta=THETA, G2pressure=CTDPRS, G2oxygen=OXYGEN, G2nitrate=NITRAT, G2phosphate=PHSPHT, G2silicate=SILCAT)%>%
  mutate(G2depth=swDepth(G2pressure,G2latitude)) #compute depth from pressure (oce package swDepth)



finalCCHDO<-extendedCCHDO %>%
  group_by(G2year, layer)%>%
  summarise_at(vars(DEPTH:xcCO3), mean, na.rm = TRUE)

library(plotrix)
finalCCHDOerror<-extendedCCHDO %>%
  group_by(G2year, layer)%>%
  summarise_at(vars(DEPTH:xcCO3), std.error, na.rm = TRUE)