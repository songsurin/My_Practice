#install.packages("shiny")
library(shiny)
ui<-fluidPage(
  titlePanel("샤이니 1번 샘플"),
  sidebarLayout(
    sidebarPanel(
      sliderInput(inputId='bins',
                 label="막대(bins)개수",
                 min=1, max=50,
                 value=30)),
    mainPanel(
      plotOutput(outputId="distPlot"))
  ))
server<-function(input, output, session){
  output$distPlot<-renderPlot({
    x<-faithful$waiting
    bins<-seq(min(x), max(x), length.out=input$bins+1)
    hist(x, breaks=bins, col="#75AADB", border="white",
         xlab="다음 분출 때까지 대기 시간(분)",
         main="대기 시간 히스토그램")
  })
}

shinyApp(ui, server)
rm(list=ls())

ui<-fluidPage(
  sliderInput("range","연비",min=0,max=35,value=c(0,10)),
  textOutput("value"))
server<-function(input, output, session){
  output$value<-renderText((input$range[1]+input$range[2]))
}
shinyApp(ui, server)
