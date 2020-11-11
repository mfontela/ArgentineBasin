# ABtrends_tablecruises

tablecruises<-all%>%
  filter(!is.na(cAntPhiCt0ML))%>%
  select(G2cruise, G2year, EXPOCODE)%>%
  unique()%>%
  arrange(G2year)%>%
  rename(expocodeno=G2cruise, Year=G2year)%>%
  left_join(., expocodes, by="expocodeno")%>%
  mutate(expocode=ifelse(is.na(expocode), EXPOCODE,expocode))%>%
  select(-EXPOCODE, -expocodeno)%>%
  rename(Expocode=expocode)%>%
  mutate(Source=ifelse(Year<1990 & Year>1987, "CCHDO", "GLODAPv2.2020"))
