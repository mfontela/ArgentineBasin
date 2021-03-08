#ABtrends_xcCO3_Cant_verticalplot
# R1: Line 252: Do you have data at depth > 6000m ? It would be interesting 
# to show a profile of Cant and xCO3 at one or two selected stations (in Supp Mat).

ggplot(all, aes(xcCO3*10^6, -G2depth))+
  geom_point(size=.75, alpha=.52)+
  geom_point(aes(x=cAntPhiCt0ML),size=.75, alpha=.52, colour="red")+
  scale_x_continuous(expand = c(0,0), limits = c(-155, 155), position = "top")+
  scale_y_continuous(expand = c(0,0),limits = c(-6250, 0), breaks = seq(0,-6000, by=-1000), labels = c("0","1000","2000","3000","4000","5000","6000"))+
  labs(y="Depth (m)", x=expression(paste(µmolkg^{-1})))+
  annotate("text", 85, -2500, label=expression(paste(C[ant]," ")), colour="red",size=7)+
  annotate("text", 87, -3000, label=expression(paste(xc,"[",CO[3]^2^"-","]"," ")), colour="black",size=7)+
  ABtrends_theme
