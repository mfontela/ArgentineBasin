# Table with trends and statistics--------------------------------------------------------------
t_trend<-Sys.time()
source("metafunction_weighted.R")

#one by one
Trends_xcCO3<-metafunction_weighted(finalA, finalA$xcCO3, finalAerror$xcCO3)%>%
              mutate(tracer="xcCO3")
Trends_Cant<-metafunction_weighted(finalA, finalA$cAntPhiCt0ML, finalAerror$cAntPhiCt0ML)%>%
  mutate(tracer="Cant")

#or at once:
TableStats<-bind_rows(metafunction_weighted(finalA, finalA$xcCO3, finalAerror$xcCO3)%>%
                        mutate(tracer="xcCO3"),
                      metafunction_weighted(finalA, finalA$cAntPhiCt0ML, finalAerror$cAntPhiCt0ML)%>%
                        mutate(tracer="Cant"),
                      metafunction_weighted(finalA, finalA$DIC, finalAerror$DIC)%>%
                        mutate(tracer="DIC"),
                      metafunction_weighted(finalA, finalA$G2phtsinsitutp, finalAerror$G2phtsinsitutp)%>%
                        mutate(tracer="G2pHis"),  
                      metafunction_weighted(finalA, finalA$pH, finalAerror$pH)%>%
                        mutate(tracer="pH"), 
                      metafunction_weighted(finalA, finalA$ALK, finalAerror$ALK)%>%
                        mutate(tracer="ALK"),
                      metafunction_weighted(finalA, finalA$CO3, finalAerror$CO3)%>%
                        mutate(tracer="CO3"),
                      metafunction_weighted(finalA, finalA$OmegaAragonite, finalAerror$OmegaAragonite)%>%
                        mutate(tracer="OmegaAragonite"),
                      metafunction_weighted(finalA, finalA$OmegaCalcite, finalAerror$OmegaCalcite)%>%
                        mutate(tracer="OmegaCalcite"),
                      metafunction_weighted(finalA, finalA$G2pressure, finalAerror$G2pressure)%>%
                        mutate(tracer="Pressure"),
                      metafunction_weighted(finalA, finalA$G2theta, finalAerror$G2theta)%>%
                        mutate(tracer="G2theta"),
                      metafunction_weighted(finalA, finalA$G2salinity, finalAerror$G2salinity)%>%
                        mutate(tracer="G2salinity"),
                      metafunction_weighted(finalA, finalA$G2oxygen, finalAerror$G2oxygen)%>%
                        mutate(tracer="G2oxygen"),
                      metafunction_weighted(finalA, finalA$G2aou, finalAerror$G2aou)%>%
                        mutate(tracer="G2aou"),
                      metafunction_weighted(finalA, finalA$G2nitrate, finalAerror$G2nitrate)%>%
                        mutate(tracer="G2nitrate"),
                      metafunction_weighted(finalA, finalA$G2phosphate, finalAerror$G2phosphate)%>%
                        mutate(tracer="G2phosphate"),
                      metafunction_weighted(finalA, finalA$G2silicate, finalAerror$G2silicate)%>%
                        mutate(tracer="G2silicate"),
                      metafunction_weighted(finalA, finalA$DICnat, finalAerror$DICnat)%>%
                        mutate(tracer="DICnat"),
                      metafunction_weighted(finalA, finalA$nDIC, finalAerror$DIC)%>%
                        mutate(tracer="nDIC"))


print(paste("Done in",ceiling(Sys.time()-t_trend), "seconds"))