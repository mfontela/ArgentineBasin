# Final plot Cant --------------------------------------------------------------
source("metafunction_weighted.R")

table_Cant<-left_join(finalA, 
                       metafunction_weighted(finalA, finalA$cAntPhiCt0ML, finalAerror$cAntPhiCt0ML)%>%
                         mutate(tracer="Cant"),
                       by="layer")
table_Cant$layer <- factor(table_Cant$layer,levels=ord)


# Do the plot -------------------------------------------------------------

plot_Cant<-ggplot(table_Cant,aes(ppm, cAntPhiCt0ML, group=layer, color=layer))+
  geom_jitter(data=all, alpha=.7, shape=4, size=.7)+
  geom_smooth(data=table_Cant[table_Cant$pvalue<0.05,], method = MASS::rlm, aes(colour=layer), alpha=0.5, size=.85)+
  geom_errorbar(aes(ymin=(cAntPhiCt0ML)-(finalAerror$cAntPhiCt0ML),ymax=(cAntPhiCt0ML)+(finalAerror$cAntPhiCt0ML)),size=.95, colour="black")+
  geom_point(size=2.5, shape=15)+
  geom_point(size=2.5, shape=0, color="black", stroke=1.3)+
  geom_point(data=table_Cant[table_Cant$layer=="AABW",], size=2.5, shape=15, color="#66a61e")+
  geom_point(data=table_Cant[table_Cant$layer=="AABW",], size=2.5, shape=0, color="black", stroke=1.3)+ #To put AABW over the CDW layer
  scale_x_continuous(expand = c(0,0), 
                     limits = c(min(finalA$ppm, na.rm=T)-2, max(finalA$ppm, na.rm=T)+2),
                     breaks = c(round(min(table_Cant$ppm)), 350, 375, 400, round(max(table_Cant$ppm))),
                     sec.axis = sec_axis(~.,breaks=unique(table_Cant$ppm[!is.na(table_Cant$cAntPhiCt0ML)]), labels = unique(table_Cant$G2year[!is.na(table_Cant$cAntPhiCt0ML)])))+
  scale_y_continuous(expand = c(0,0), limits = c(0, 80))+
  labs(x=expression(paste(CO[2]^{atm}~(ppm))),y=expression(paste(C[ant]," ",(µmolkg^{-1}))))+
  scale_color_brewer(type="qual", palette = "Dark2", direction=1)+
  ABtrends_theme+
  theme(legend.position = "none",
        text = element_text(colour="black"),
        axis.text.x.top = element_text(angle = 45, hjust = 0, size=8))



if (savefigure) {
  ggsave(filename = "Fontela_ABtrends_Cant.pdf",
         plot=plot_Cant, dpi = 300, width = 17, height = 12, units = "cm")
}

if (viewfigure) {
  shell.exec("Fontela_ABtrends_Cant.pdf")
  }

