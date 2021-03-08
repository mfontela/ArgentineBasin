# Final plot xcCO3 --------------------------------------------------------------
source("metafunction_weighted.R")

table_xcCO3<-left_join(finalA, 
                  metafunction_weighted(finalA, finalA$xcCO3, finalAerror$xcCO3)%>%
                    mutate(tracer="xcCO3"),
                  by="layer")
table_xcCO3$layer <- factor(table_xcCO3$layer,levels=ord)



# Do the plot -------------------------------------------------------------


plot_xcCO3<-ggplot(table_xcCO3,aes(ppm, xcCO3*10^6, group=layer, color=layer))+
  geom_hline(aes(yintercept=0), colour="red", linetype="dashed", size=1.75)+
  geom_rect(colour="pink",fill="pink",xmin = -Inf,xmax = Inf,ymin = -140,ymax = 0,alpha=0.1)+
  geom_jitter(data=all, alpha=.7, shape=4, size=.7)+
  geom_smooth(data=table_xcCO3[table_xcCO3$pvalue<0.05,], method = MASS::rlm, aes(colour=layer), alpha=0.5, size=.85)+
  geom_errorbar(aes(ymin=(xcCO3*10^6)-(finalAerror$xcCO3*10^6),ymax=(xcCO3*10^6)+(finalAerror$xcCO3*10^6)),size=.95, colour="black")+
  geom_point(size=2.5, shape=15)+
  geom_point(size=2.5, shape=0, color="black", stroke=1.3)+
  scale_x_continuous(expand = c(0,0), 
                     limits = c(min(table_xcCO3$ppm)-2, max(table_xcCO3$ppm)+2),
                     breaks = c(round(min(table_xcCO3$ppm)), 350, 375, 400, round(max(table_xcCO3$ppm))),
                     labels = c(round(min(table_xcCO3$ppm)), 350, 375, 400, round(max(table_xcCO3$ppm))),
                     sec.axis = sec_axis(~.,breaks=unique(table_Cant$ppm[!is.na(table_Cant$cAntPhiCt0ML)]), labels = unique(table_Cant$G2year[!is.na(table_Cant$xcCO3)])))+
  scale_y_continuous(expand = c(0,0), 
                     limits = c(-140, 180), 
                     breaks = c(150,100, 50, 0, -50, -100))+
  labs(x=expression(paste(CO[2]^{atm}~(ppm))),y=expression(paste(xc,"[",CO[3]^2^"-","]"," ",(µmolkg^{-1}))))+
  scale_color_brewer(type="qual", palette = "Dark2", direction=1)+
  ABtrends_theme+
  theme(legend.position = "none",
        text = element_text(colour="black"),
        axis.text.x.top = element_text(angle = 45, hjust = 0, size=8))


if (savefigure) {
  ggsave(filename = "Fontela_ABtrends_xcCO3.pdf",
         plot= plot_xcCO3, dpi = 300, width = 17, height = 12, units="cm")
}
if (viewfigure) {
  shell.exec("Fontela_ABtrends_xcCO3.pdf")
  }
