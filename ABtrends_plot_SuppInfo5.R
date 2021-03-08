#ABtrends_plot_SuppInfo5.R
# Previous source needed: ABtrends_trends.R
finalAlong<-melt(finalA, id.vars = c("G2year", "layer", "ppm"), measure.vars=3:ncol(finalA))

finalAlong<-inner_join(finalAlong, 
               TableStats%>%rename(variable="tracer"), #to add p-value previously estimated
               by=c("layer", "variable"))

data_facet<-finalAlong%>%
  mutate(value=ifelse(variable=="DIC", value*10^6, value))%>%
  mutate(value=ifelse(variable=="ALK", value*10^6, value))%>%
  mutate(value=ifelse(variable=="CO3", value*10^6, value))%>%
  filter(variable=="G2theta" | variable=="G2salinity" | variable=="G2oxygen" | variable=="G2aou" |
           variable=="G2nitrate" | variable=="G2phosphate" | variable=="G2silicate" |
           variable=="DIC" | variable=="ALK" | variable=="pH"|
           variable=="OmegaAragonite" | variable=="CO3")%>%
  filter(ppm %in% unique(finalA$ppm[!is.na(finalA$xcCO3)])) #only years with cruises with carbon data

#levels in variable to order
data_facet$variable <- factor(data_facet$variable,      # Reordering group factor levels
                         levels = c("G2theta", "G2salinity", "G2oxygen", "G2aou",
                                    "G2nitrate", "G2phosphate", "G2silicate",
                                    "ALK", "DIC", "pH", "OmegaAragonite", "CO3"))
# Do the plot -------------------------------------------------------------

facetplot<-ggplot(data_facet, aes(ppm, value,group=layer, color=layer))+
  facet_wrap(. ~ variable,scales="free_y")+
  geom_point(size=1.5, shape=15)+
  geom_smooth(data=data_facet[data_facet$pvalue<0.05,], method = MASS::rlm, aes(colour=layer), size=1)+
  scale_x_continuous(expand = c(0,0), limits = c(min(finalA$ppm, na.rm=T)-2, max(finalA$ppm, na.rm=T)+2), breaks = c(round(min(table_Cant$ppm)), 350, 375, 400, round(max(table_Cant$ppm))))+
  labs(x=expression(paste(CO[2]^{atm}~(ppm))), y=expression(µmolkg^{-1}))+
  scale_color_brewer(type="qual", palette = "Dark2", direction=1)+
  ABtrends_theme+
  theme(legend.position = "none",
        text = element_text(colour="black", size=8),
        axis.text.x = element_text(angle=45),
        axis.title.x = element_text(size=20),
        axis.title.y = element_text(size=20),
        strip.text = element_text(face="bold", size=rel(1.5)))

if (savefigure) {
  ggsave(filename = "ABtrends_SuppInfoFigure5.pdf",
         plot=facetplot, dpi = 300, width = 25, height = 16, units = "cm")
}

if (viewfigure) {
  shell.exec("ABtrends_SuppInfoFigure5.pdf")
  }
