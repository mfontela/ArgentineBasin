#Plots for the supp info

# histogram samples by month ----------------------------------------------
all%>%
  filter(!is.na(cAntPhiCt0ML))%>%
ggplot(., aes(G2month))+
  geom_bar()+
  scale_y_log10(expand=c(0,0))+
  scale_x_continuous(expand=c(0,0), breaks=seq(1,12), labels = c("J", "F", "M", "A", "M", "J" , "J", "A", "S", "O", "N", "D"))+
  ABtrends_theme+
  labs(x="Month", y="Number of samples (log scale)")+
  theme(legend.position = "none",
        text = element_text(colour="black"),
        axis.text.x.top = element_text(angle = 45, hjust = 0, size=8))

