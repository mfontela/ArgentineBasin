# Add phiCant -------------------------------------------------------------

computeCant=0
if (computeCant) {
  source("all_to_Cant.R") #Export to Matlab input. phiCant (Vázquez-Rodriguez et al., 2012) is developed in Matlab
  #You can get all the scripts to run the method here: http://oceano.iim.csic.es/_media/cantphict0_toolbox_20190213.zip 
  #Alternative: load "ABtrend_phiCant.xlsx" file, where there are the results.
}

phiCant <- read_excel("ABtrend_phiCant.xlsx", na = 'NaN')

phiCant<-phiCant%>%
  rename(G2year=year)

all<-full_join(all, phiCant, by=c("ID", "G2year","layer"))
all$layer <- factor(all$layer,levels=ord)

# Add DICnat (DIC-Cant) ---------------------------------------------------

all$DICnat=all$ct-all$cAntPhiCt0ML

# Add nDIC ----------------------------------------------------------------

all$nDIC=(all$DIC/all$G2salinity)*35


# Final tables ----------------------------------------------------

finalA<-all %>%
  group_by(G2year, layer)%>%
  summarise_at(vars(G2pressure:nDIC), mean, na.rm = TRUE)

finalAerror<-all %>%
  group_by(G2year, layer)%>%
summarise_at(vars(G2pressure:nDIC), sd, na.rm = TRUE)

#Do not include 2009 data for AABW: very few samples (4-8) and not enough representative for this water mass. See map_year.
finalA$xcCO3[finalA$G2year==2009 & finalA$layer=="AABW"]=NA 
finalA$cAntPhiCt0ML[finalA$G2year==2009 & finalA$layer=="AABW"]=NA
finalA$DIC[finalA$G2year==2009 & finalA$layer=="AABW"]=NA
finalA$G2phtsinsitutp[finalA$G2year==2009 & finalA$layer=="AABW"]=NA
finalA$pH[finalA$G2year==2009 & finalA$layer=="AABW"]=NA
finalA$ALK[finalA$G2year==2009 & finalA$layer=="AABW"]=NA
finalA$CO3[finalA$G2year==2009 & finalA$layer=="AABW"]=NA
finalA$OmegaAragonite[finalA$G2year==2009 & finalA$layer=="AABW"]=NA
finalA$OmegaCalcite[finalA$G2year==2009 & finalA$layer=="AABW"]=NA
finalA$G2pressure[finalA$G2year==2009 & finalA$layer=="AABW"]=NA
finalA$G2theta[finalA$G2year==2009 & finalA$layer=="AABW"]=NA
finalA$G2salinity[finalA$G2year==2009 & finalA$layer=="AABW"]=NA
finalA$G2oxygen[finalA$G2year==2009 & finalA$layer=="AABW"]=NA
finalA$G2aou[finalA$G2year==2009 & finalA$layer=="AABW"]=NA
finalA$G2nitrate[finalA$G2year==2009 & finalA$layer=="AABW"]=NA 
finalA$G2phosphate[finalA$G2year==2009 & finalA$layer=="AABW"]=NA 
finalA$G2silicate[finalA$G2year==2009 & finalA$layer=="AABW"]=NA
finalA$DICnat[finalA$G2year==2009 & finalA$layer=="AABW"]=NA
finalA$nDIC[finalA$G2year==2009 & finalA$layer=="AABW"]=NA