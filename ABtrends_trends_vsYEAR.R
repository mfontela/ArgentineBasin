# Table with trends and statistics--------------------------------------------------------------
t0<-Sys.time()
source("metafuncion_weighted_vsYEAR.R")
# #o todos de golpe
TableStats<-bind_rows(metafuncion_weighted_vsYEAR(finalA, finalA$xcCO3, finalAerror$xcCO3)%>%
                        mutate(tracer="xcCO3"),
                      metafuncion_weighted_vsYEAR(finalA, finalA$cAntPhiCt0ML, finalAerror$cAntPhiCt0ML)%>%
                        mutate(tracer="Cant"),
                      metafuncion_weighted_vsYEAR(finalA, finalA$DIC, finalAerror$DIC)%>%
                        mutate(tracer="DIC"),
                      metafuncion_weighted_vsYEAR(finalA, finalA$G2phtsinsitutp, finalAerror$G2phtsinsitutp)%>%
                        mutate(tracer="G2pHis"),
                      metafuncion_weighted_vsYEAR(finalA, finalA$pH, finalAerror$pH)%>%
                        mutate(tracer="pH"),
                      metafuncion_weighted_vsYEAR(finalA, finalA$ALK, finalAerror$ALK)%>%
                        mutate(tracer="Alk"),
                      metafuncion_weighted_vsYEAR(finalA, finalA$CO3, finalAerror$CO3)%>%
                        mutate(tracer="CO3"),
                      metafuncion_weighted_vsYEAR(finalA, finalA$OmegaAragonite, finalAerror$OmegaAragonite)%>%
                        mutate(tracer="OmegaAragonite"),
                      metafuncion_weighted_vsYEAR(finalA, finalA$OmegaCalcite, finalAerror$OmegaCalcite)%>%
                        mutate(tracer="OmegaCalcite"),
                      metafuncion_weighted_vsYEAR(finalA, finalA$G2pressure, finalAerror$G2pressure)%>%
                        mutate(tracer="Pressure"),
                      metafuncion_weighted_vsYEAR(finalA, finalA$G2theta, finalAerror$G2theta)%>%
                        mutate(tracer="Tpot"),
                      metafuncion_weighted_vsYEAR(finalA, finalA$G2salinity, finalAerror$G2salinity)%>%
                        mutate(tracer="Sal"),
                      metafuncion_weighted_vsYEAR(finalA, finalA$G2oxygen, finalAerror$G2oxygen)%>%
                        mutate(tracer="O2"),
                      metafuncion_weighted_vsYEAR(finalA, finalA$G2aou, finalAerror$G2aou)%>%
                        mutate(tracer="AOU"),
                      metafuncion_weighted_vsYEAR(finalA, finalA$G2nitrate, finalAerror$G2nitrate)%>%
                        mutate(tracer="NO3"),
                      metafuncion_weighted_vsYEAR(finalA, finalA$G2phosphate, finalAerror$G2phosphate)%>%
                        mutate(tracer="PO4"),
                      metafuncion_weighted_vsYEAR(finalA, finalA$G2silicate, finalAerror$G2silicate)%>%
                        mutate(tracer="SiO4"))


print(paste("Done in",ceiling(Sys.time()-t0), "seconds"))