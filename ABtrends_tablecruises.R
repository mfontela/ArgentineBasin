# ABtrends_tablecruises

tablecruises<-all%>%
  filter(!is.na(cAntPhiCt0ML))%>%
  select(G2cruise, G2year, EXPOCODE, flag)%>%
  unique()%>%
  arrange(G2year)%>%
  rename(expocodeno=G2cruise, Year=G2year)%>%
  left_join(., expocodes, by="expocodeno")%>%
  mutate(expocode=ifelse(is.na(expocode), EXPOCODE,expocode))%>%
  select(-EXPOCODE, -expocodeno)%>%
  rename(Expocode=expocode)%>%
  mutate(Source=ifelse(Year<1990 & Year>1987, "CCHDO", "GLODAPv2.2020"))%>%
  mutate(pair=ifelse(flag==15, "DIC & TA", 
                     ifelse(flag==8, "pH & TA",
                            ifelse(flag==9, "pH & DIC", NA))))

library("xlsx")
if (export_to_excel) {
  write.xlsx(tablecruises,"ABtrends_Tablecruises.xlsx",
             sheetName = "tablecruises", 
             col.names = TRUE, row.names = FALSE)
  shell.exec("ABtrends_Tablecruises.xlsx")
  }



# 1st review:what carbon variable pairs were used --------

View(all%>%
       filter(!is.na(cAntPhiCt0ML))%>%
       select(G2cruise, G2year, EXPOCODE, flag)%>%
       unique()%>%
       arrange(G2year)%>%
       rename(expocodeno=G2cruise, Year=G2year)%>%
       left_join(., expocodes, by="expocodeno")%>%
       mutate(expocode=ifelse(is.na(expocode), EXPOCODE,expocode))%>%
       select(-EXPOCODE, -expocodeno)%>%
       rename(Expocode=expocode)
)
