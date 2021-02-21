#Monthly CO2 (mCO2) from Mauna Loa

url <- 'ftp://ftp.cmdl.noaa.gov/ccg/co2/trends/co2_mm_mlo.txt'
file  <- tempfile()
download.file(url,file)
mCO2 <- read.table(file, header = F)
mCO2<-rename(mCO2, year=V1, month=V2, decimal_year=V3, ppm=V4, interpolated_ppm=V5, trend=V6, ndays=V7)
