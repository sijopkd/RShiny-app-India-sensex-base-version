library(shiny)

setwd("D:/Datasets/Indian cities/India_statistics/bharath")
state_data <-  read.csv("India state wise.csv")

# Define a server for the Shiny app
shinyServer(function(input, output) {
  
  data<-reactive({
    state_data = as.data.frame(state_data[state_data$Name %in% input$states,])
  })
  
  selected <- reactive({ 
    final_plot = as.data.frame(final_plot[,colnames(final_plot) %in% input$feature]) 
  })

  output$caption <- renderText({
    if (input$parameters== "Crimes.reported"){ "Crimes reported"}
    else if(input$parameters== "Population.millions."){ "Population(millions)"}
    else if(input$parameters== "Area.sqkm."){ "Area(sq km)"}
    else if(input$parameters== "Population.density.per.sq.km."){ "Population density"}
    else if(input$parameters== "Literacy.Rate.in.percent"){ "Literacy rate(%)"}
    else if(input$parameters== "Percentage.of.Urban.Population.to.total.Population"){ "Urban population(%)"}
    else { "Sex ratio"}
  })
  
  output$caption1 <- renderText({
    if (input$feature== "Crimes.reported"){ "Crimes reported"}
    else if(input$feature== "Population.millions."){ "Population(millions)"}
    else if(input$feature== "Area.sqkm."){ "Area(sq km)"}
    else if(input$feature== "Population.density.per.sq.km."){ "Population density"}
    else if(input$feature== "Literacy.Rate.in.percent"){ "Literacy rate(%)"}
    else if(input$feature== "Percentage.of.Urban.Population.to.total.Population"){ "Urban population(%)"}
    else { "Sex ratio"}
  })
  # Fill in the spot we created for a plot
  output$barchart <- renderPlot({
    par(mar=c(6,6,3,3),cex.axis=1.5,cex.lab=2)
    barplot(data()[,input$parameters], 
            names.arg = data()$Name, 
            ylab=input$parameters,
            xlab="States",
            col= "navyblue",
            las = 2, cex.axis=1, cex.names=0.75, cex.lab = 1.5)
    
  })
  
  output$chloropleth <- renderPlot({
    
    ggplot() +
      geom_polygon(data = final_plot, 
                   aes(x = long, y = lat, group = group, fill = selected()), 
                   color = "black", size = 0.25) + 
      coord_map()+
      scale_fill_distiller(name= input$feature, palette = "YlOrRd", trans = 'reverse' , breaks = pretty_breaks(n = 5))+
      theme_nothing(legend = TRUE)
    
    
  })
})