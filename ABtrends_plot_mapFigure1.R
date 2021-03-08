# Picture the base map ----------------------------------------------------------
t0<-Sys.time()

stations<-all%>%
  filter(!is.na(xcCO3))%>%
  select(G2longitude, G2latitude, G2year)%>%
  dplyr::distinct(G2longitude, G2latitude,.keep_all = TRUE)
  

#m from map!
m <- getNOAA.bathy(lon1 = ABasin[1,1]-4, lon2 = ABasin[2,1]+5,
                     lat1 = ABasin[1,2]-5, lat2 = ABasin[2,2]+3, resolution = 1) #Subiendo la resoluci?n va m?s r?pido. El uno es el menor. 

# when m already exists -----------------------------------------------------

  
  #el ploteo
  (basemap<-ggplot(m, aes(x=x, y=y)) + 
      coord_quickmap() +
      # background
     geom_raster(aes(fill=z)) +
     # scale_fill_etopo() +
      scale_fill_gradient2(low="cadetblue1", mid="white", high="darkgreen", midpoint=0, guide=F)+
     # countours
      geom_contour(aes(z=z),breaks=c(-1000, -2000, -3000,-4000,-5000),colour="gray", size=0.5) +
      geom_contour(aes(z=z),breaks=c(0),colour="black", size=1) +  
      # geom_point(data=stations, aes(x=G2longitude, y = G2latitude, color=as.character(G2year),shape=as.character(G2year)), size=2)+
     geom_point(data=stations[stations$G2year==1994,], aes(x=G2longitude, y = G2latitude), color="#fc9272", size=4)+ #FICARAM
     geom_point(data=stations[stations$G2year==2001,], aes(x=G2longitude, y = G2latitude), color="#fb6a4a", size=4)+ #FICARAM
     geom_point(data=stations[stations$G2year==2002,], aes(x=G2longitude, y = G2latitude), color="#ef3b2c", size=4)+ #FICARAM
     geom_point(data=stations[stations$G2year==2013,], aes(x=G2longitude, y = G2latitude), color="#cb181d", size=4)+ #FICARAM
     geom_point(data=stations[stations$G2year==2019,], aes(x=G2longitude, y = G2latitude), color="#99000d", size=4)+ #FICARAM
     geom_point(data=stations[stations$G2year==1972,], aes(x=G2longitude, y = G2latitude), color="black", size=4, shape=17)+
     geom_point(data=stations[stations$G2year==1988,], aes(x=G2longitude, y = G2latitude), color="#1f78b4", size=4, shape=6)+
     geom_point(data=stations[stations$G2year==1989,], aes(x=G2longitude, y = G2latitude), color="chartreuse4", size=4, shape=9)+
     geom_point(data=stations[stations$G2year==2009,], aes(x=G2longitude, y = G2latitude), color="#fdbf6f", size=4, shape=8)+
     geom_point(data=stations[stations$G2year==2017,], aes(x=G2longitude, y = G2latitude), color="#6a3d9a", size=4, shape=18)+
      scale_shape_manual(values=seq(15,25))+ 
      scale_x_continuous(expand=c(0,0), breaks = c(-30, -40, -50, -60), labels = c("30ºW", "40ºW", "50ºW", "60ºW"))+
      scale_y_continuous(expand=c(0,0), breaks = c(-30, -35, -40, -45, -50), labels = c("30ºS", "35ºS", "40ºS", "45ºS", "50ºS"))+
      labs(x="", y="")+
      theme(
        panel.border = element_rect(colour="black", fill=NA, size=4),
        text = element_text(size=28, colour="black"),
        legend.title = element_blank())
  )

savefigure=0
if (savefigure) {
ggsave(filename = "ABtrends_map.pdf",
       plot=basemap, dpi = 300, width = 20, height = 23, units="cm")
}
abrirfigura=0
if (abrirfigura) {
  shell.exec("ABtrends_map.pdf")
}

print(paste("Done in", ceiling(Sys.time()-t0)))

