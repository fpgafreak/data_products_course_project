library(shiny)

shinyUI(pageWithSidebar(  
  headerPanel("RF match example"),  
  sidebarPanel(    
    sliderInput('Rs', 'Source Resistance [Ohms]', value = 50, min = 30, max = 100, step = 0.1),
    sliderInput('Rl', 'Load Resistance [Ohms]', value = 5, min = 2.5, max = 25, step = 0.1),
    HTML('This application calculates simple LC-circuit to match'),
    HTML('lower impedance radio frequency load to higher impedance source.'),
    HTML('Results are presented as a circuit quality factor (Q), component values (L and C)'),
    HTML('and as a Smith chart (standard way to plot radio circuit properties).'),
    HTML('Smith chart is normalized to source resistance, so it always stays'),
    HTML('at the center of the chart (blue dot).'),
    HTML('Red dot shows initial load resistance, green line and dot show how'),
    HTML('impedance changes with added series inductor (L), and blue line shows'),
    HTML('further impedance change due to parallel capacitor (C).'),
    HTML('All calculations are done for 13.56MHz frequency.')
  ),
  mainPanel(    
    plotOutput('SmithChart'),
    textOutput('Fmatch'),
    textOutput('Qmatch'),
    textOutput('Lmatch'),
    textOutput('Cmatch')
  )
))
