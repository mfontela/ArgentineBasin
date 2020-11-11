# Number of samples by layer and year -------------------------------------

samplesbyyear<-all%>%
  group_by(G2year, layer)%>%
  filter(!is.na(cAntPhiCt0ML))%>%
  count(layer)


table_Cant<-left_join(table_Cant, samplesbyyear, by=c("G2year", "layer"))
  
  ggplot(table_Cant,aes(ppm, cAntPhiCt0ML, group=layer, color=layer))+
    geom_smooth(data=table_Cant[table_Cant$pvalue<0.05,], method = MASS::rlm, aes(colour=layer), alpha=0.5, size=.5, se=F)+
    geom_errorbar(aes(ymin=(cAntPhiCt0ML)-(finalAerror$cAntPhiCt0ML),ymax=(cAntPhiCt0ML)+(finalAerror$cAntPhiCt0ML)),size=.95, colour="black")+
    geom_point(size=2.5, shape=15)+
    geom_point(size=2.5, shape=0, color="black", stroke=1.3)+
    geom_point(data=table_Cant[table_Cant$layer=="AABW",], size=2.5, shape=15, color="#66a61e")+
    ggrepel::geom_text_repel(aes(label=n, color=layer), fontface="bold")+
    annotate("text", x=328, y=78, label=sum(table_Cant$n[table_Cant$G2year==1972], na.rm=T), angle=45)+
    annotate("text", x=350, y=78, label=sum(table_Cant$n[table_Cant$G2year==1988], na.rm=T), angle=45)+
    annotate("text", x=354, y=78, label=sum(table_Cant$n[table_Cant$G2year==1989], na.rm=T), angle=45)+
    annotate("text", x=360, y=78, label=sum(table_Cant$n[table_Cant$G2year==1994], na.rm=T), angle=45)+
    annotate("text", x=370, y=78, label=sum(table_Cant$n[table_Cant$G2year==2001], na.rm=T), angle=45)+
    annotate("text", x=373, y=78, label=sum(table_Cant$n[table_Cant$G2year==2002], na.rm=T), angle=45)+
    annotate("text", x=387, y=78, label=sum(table_Cant$n[table_Cant$G2year==2009], na.rm=T), angle=45)+
    annotate("text", x=397, y=78, label=sum(table_Cant$n[table_Cant$G2year==2013], na.rm=T), angle=45)+
    annotate("text", x=406, y=78, label=sum(table_Cant$n[table_Cant$G2year==2017], na.rm=T), angle=45)+
    annotate("text", x=412, y=78, label=sum(table_Cant$n[table_Cant$G2year==2019], na.rm=T), angle=45)+
    annotate("text", x=423, y=71, label=paste("(",sum(table_Cant$n[table_Cant$layer=="SACW"], na.rm=T),")", sep=""), fontface="bold", color="#1b9e77")+
    annotate("text", x=423, y=53, label=paste("(",sum(table_Cant$n[table_Cant$layer=="SAMW"], na.rm=T),")", sep=""), fontface="bold", color="#d95f02")+
    annotate("text", x=423, y=30, label=paste("(",sum(table_Cant$n[table_Cant$layer=="AAIW"], na.rm=T),")", sep=""), fontface="bold", color="#7570b3")+
    annotate("text", x=423, y=10, label=paste("(",sum(table_Cant$n[table_Cant$layer=="CDW-NADW"], na.rm=T),")", sep=""), fontface="bold", color="#e7298a")+
    annotate("text", x=423, y=16, label=paste("(",sum(table_Cant$n[table_Cant$layer=="AABW"], na.rm=T),")", sep=""), fontface="bold", color="#66a61e")+
    scale_x_continuous(expand = c(0,0), limits = c(min(finalA$ppm, na.rm=T)-2, max(finalA$ppm, na.rm=T)+17), breaks = c(round(min(table_Cant$ppm)), 350, 375, 400, round(max(table_Cant$ppm))))+
    scale_y_continuous(expand = c(0,0), limits = c(0, 82))+
    labs(x=expression(paste(CO[2]^{atm}~(ppm))),y=expression(paste(C[ant]," ",(µmolkg^{-1}))))+
    scale_color_brewer(type="qual", palette = "Dark2", direction=1)+
    ABtrends_theme+
    theme(legend.position = "none",
          text = element_text(colour="black"))

