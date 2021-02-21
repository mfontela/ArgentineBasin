#ABtrends_theme 

ABtrends_theme <- theme_bw() +
  theme(text = element_text(colour="darkcyan"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.title = element_text(size = rel(1.3)),
        plot.title=element_text(size=rel(1.3), lineheight=.9,
                                face="bold", colour="darkcyan"),
        axis.text = element_text(size = rel(1.30)))