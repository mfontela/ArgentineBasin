#Monthly CO2 from South Pole, Antarctica (SPO)

url <- 'https://www.esrl.noaa.gov/gmd/aftp/data/trace_gases/co2/flask/surface/co2_spo_surface-flask_1_ccgg_month.txt'
file  <- tempfile()
download.file(url,file)
CO2 <- read.table(file, header = F)
CO2<-CO2%>%
  rename(site=V1, year=V2, ppm=V4, month=V3)%>%
  group_by(year)%>%
  summarise_at(c("ppm"), mean, na.rm = TRUE)%>%
  mutate(site="South Pole")


#Problem: we need annual data for 1972 and there is no Southern Hemisphere measurements

#Annual CO2 from Mauna Loa

url <- 'ftp://ftp.cmdl.noaa.gov/ccg/co2/trends/co2_annmean_mlo.txt'
file  <- tempfile()
download.file(url,file)
CO2ml <- read.table(file, header = F)
CO2ml<-CO2ml%>%
  rename(year=V1, ppm=V2, uncertainty=V3)%>%
  mutate(site="Mauna Loa")%>%
  select(-uncertainty)


#Comparative Mauna Loa annual vs South Pole

comp<-bind_rows(CO2, CO2ml)

# ggplot(comp, aes(year, ppm, colour=site))+
#   geom_point()+
#   geom_path()+
#   ABtrends_theme
#   

diff=NA
for (year in (comp$year[comp$site=="South Pole"])) {
  diff[year]=(comp$ppm[comp$site=="Mauna Loa" & comp$year==year])-(comp$ppm[comp$site=="South Pole" & comp$year==year])
}
diff=diff[min(CO2$year):max(CO2$year)]



#Add a new observation to CO2 dataframe with the value for 1972 (Mauna Loa 1972 - median(diff))
CO2<-rbind(CO2,
           data.frame(year=1972, ppm=CO2ml$ppm[CO2ml$year==1972] - median(diff, na.rm=T), site="South Pole"))
