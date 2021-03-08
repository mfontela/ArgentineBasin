metafunction_weighted<-function(table,tracer, weight){

for (i in 1:length(unique(table$layer))) {
  if (i==1){pvalue<-vector(length = length(unique(table$layer)))
  ordenada<-vector(length = length(unique(table$layer)))
  eordenada<-vector(length = length(unique(table$layer)))
  slope<-vector(length = length(unique(table$layer)))
  eslope<-vector(length = length(unique(table$layer)))  
  r2<-vector(length = length(unique(table$layer)))
  names(pvalue)<-unique(table$layer)
  names(ordenada)<-unique(table$layer)
  names(eordenada)<-unique(table$layer)
  names(slope)<-unique(table$layer)
  names(eslope)<-unique(table$layer)}

model<-(table%>% #Delete summary
          MASS::rlm(tracer[layer==unique(layer)[i]] ~ ppm[layer==unique(layer)[i]],., weights=(1/weight[layer==unique(layer)[i]]))%>%
          summary())

  ordenada[i]<-model[["coefficients"]][1,1]
  eordenada[i]<-model[["coefficients"]][1,2]
  slope[i]<-model[["coefficients"]][2,1]
  eslope[i]<-model[["coefficients"]][2,2]
  pvalue[i]<-pnorm(
    abs(
      broom::tidy(
        table%>%
          MASS::rlm(tracer[layer==unique(layer)[i]] ~ ppm[layer==unique(layer)[i]],., weights=(1/weight[layer==unique(layer)[i]]))
      )
      [2, "statistic", drop = TRUE]), lower.tail = FALSE)*2

}

# Add statistical results to the finaltable
statistical_results<-data.frame(layer=unique(table$layer), ordenada,eordenada, slope, eslope, pvalue)
statistical_results$layer <- factor(statistical_results$layer,levels=ord)
statistical_results<-arrange(statistical_results, layer)

return(statistical_results)}
