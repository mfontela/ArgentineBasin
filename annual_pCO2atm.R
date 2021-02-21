#Annual CO2 from Mauna Loa

url <- 'ftp://ftp.cmdl.noaa.gov/ccg/co2/trends/co2_annmean_mlo.txt'
file  <- tempfile()
download.file(url,file)
CO2 <- read.table(file, header = F)
CO2<-CO2%>%
  rename(year=V1, ppm=V2, uncertainty=V3)%>%
  mutate(site="ML")


#Monthly CO2 from Ushuaia

url <- 'https://www.esrl.noaa.gov/gmd/aftp/data/trace_gases/co2/flask/surface/co2_ush_surface-flask_1_ccgg_month.txt'
file  <- tempfile()
download.file(url,file)
uCO2 <- read.table(file, header = F)
uCO2<-rename(uCO2, year=V2, ppm=V4, month=V3)

uCO2p<-uCO2%>%
  group_by(year)%>%
  select(-V1)%>%
  summarise_all(mean, na.rm = TRUE)%>%
  mutate(site="USH")

#Comparative Mauna Loa annual vs USH

comp<-full_join(uCO2p, CO2, by=c("year", "site", "ppm"))

ggplot(comp, aes(year, ppm, colour=site))+geom_point()+geom_path()


#Comparative Mauna Loa annual vs USH vs CapeGrim (1976)
cg <- read_delim("C:/Users/MFontela/Downloads/CapeGrim_CO2_data_download.csv",
                 ";", escape_double = FALSE, trim_ws = TRUE)
cg<-cg%>%
  group_by(year)%>%
  select(-Source)%>%
  summarise_all(mean, na.rm = TRUE)%>%
  mutate(site="CG")

comp<-full_join(full_join(uCO2p, CO2, by=c("year", "site", "ppm")), cg, by=c("year", "site", "ppm"))

ggplot(comp, aes(year, ppm, colour=site))+geom_point()+geom_path()

diff=NA
for (year in 1976:2020) {
  diff[year]=(comp$ppm[comp$site=="ML" & comp$year==year])-(comp$ppm[comp$site=="CG" & comp$year==year])
}
diff=diff[1976:2020]
plot(seq(1976, 2020),diff)