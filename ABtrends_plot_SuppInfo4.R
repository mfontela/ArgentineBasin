#ABtrends_DICnat
# R1: Perhaps this could be discussed in more details 
# (it is mentioned in Highlight H2). For example, showing and 
# interpreting the natural DIC changes  (Cnat = DIC-Cant).

# Final plot DICnat --------------------------------------------------------------
source("metafunction_weighted.R")

table_DICnat<-left_join(finalA, 
                      metafunction_weighted(finalA, finalA$DICnat, finalAerror$DICnat)%>%
                        mutate(tracer="DICnat"),
                      by="layer")
table_DICnat$layer <- factor(table_DICnat$layer,levels=ord)


# Do the plot -------------------------------------------------------------

plot_DICnat<-ggplot(table_DICnat,aes(ppm, DICnat, group=layer, color=layer))+
  geom_jitter(data=all, alpha=.7, shape=4, size=.7)+
  geom_smooth(data=table_DICnat[table_DICnat$pvalue<0.05,], method = MASS::rlm, aes(colour=layer), alpha=0.5, size=.85)+
  geom_errorbar(aes(ymin=(DICnat)-(finalAerror$DICnat),ymax=(DICnat)+(finalAerror$DICnat)),size=.95, colour="black")+
  geom_point(size=2.5, shape=15)+
  geom_point(size=2.5, shape=0, color="black", stroke=1.3)+
  geom_point(data=table_DICnat[table_DICnat$layer=="AABW",], size=2.5, shape=15, color="#66a61e")+
  geom_point(data=table_DICnat[table_DICnat$layer=="AABW",], size=2.5, shape=0, color="black", stroke=1.3)+ #To put AABW over the CDW layer
  scale_x_continuous(expand = c(0,0), 
                     limits = c(min(finalA$ppm, na.rm=T)-2, max(finalA$ppm, na.rm=T)+2),
                     breaks = c(round(min(table_DICnat$ppm)), 350, 375, 400, round(max(table_DICnat$ppm))),
                     sec.axis = sec_axis(~.,breaks=unique(table_DICnat$ppm[!is.na(table_DICnat$cAntPhiCt0ML)]), labels = unique(table_DICnat$G2year[!is.na(table_DICnat$DICnat)])))+
  scale_y_continuous(expand = c(0,0), limits = c(2020, 2260))+
  labs(x=expression(paste(CO[2]^{atm}~(ppm))),y=expression(paste(DIC[nat]," ",(µmolkg^{-1}))))+
  scale_color_brewer(type="qual", palette = "Dark2", direction=1)+
  ABtrends_theme+
  theme(legend.position = "none",
        text = element_text(colour="black"),
        axis.text.x.top = element_text(angle = 45, hjust = 0, size=8))



if (savefigure) {
  ggsave(filename = "Fontela_ABtrends_DICnat.pdf",
         plot=plot_DICnat, dpi = 300, width = 17, height = 12, units = "cm")
}

if (viewfigure) {
  shell.exec("Fontela_ABtrends_DICnat.pdf")
}