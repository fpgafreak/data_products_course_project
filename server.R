library(shiny)

library(UsingR)
#data(galton)

scale <- 400

dd <- sort(unique(round(c(seq(-100, 100, 1), seq(-10, 10, 0.1), seq(-2, 2, 0.02)), digits = 2)))

cmap <- function(z) { (z-1)/(z+1) }

# Smith chart grid is based on a code from
# http://stackoverflow.com/questions/18689206/plot-smith-chart-in-r
smith_grid <- function (val, step) {
  # applies conformal map to lines having fixed real component
  r_grid <- cmap(outer(1i * dd[dd >= -val & dd <= val], seq(0, val, step), '+'))
  matlines(scale*Re(r_grid), scale*Im(r_grid), lwd = 0.5, col = 1, lty = 1)
  
  # applies conformal map to lines having fixed imaginary component
  x_grid <- cmap(outer(dd[dd >= 0 & dd <= val], 1i * seq(-val, val, step), '+'))
  matlines(scale*Re(x_grid), scale*Im(x_grid), lwd = 0.5, col = 1, lty = 1)
}

ll <- (1:100)/100 
  
react_line <- function(begin, end, col) {
    r_line <- cmap(begin + ll*(end-begin))

    matlines(scale*Re(r_line), scale*Im(r_line), lwd = 2, col = col, lty = 1)  
}

admit_line <- function(begin, end, col) {
  delta <- 1/(1/end - 1/begin)
  a_line <- 1/(1/begin + ll/delta)
  a_line <- cmap(a_line)
  
  matlines(scale*Re(a_line), scale*Im(a_line), lwd = 2, col = col, lty = 1)  
}

shinyServer(  
  function(input, output) {

    output$SmithChart <- renderPlot({      
      
      Fmid <- 13.56e6  # working frequency
      Rs <- input$Rs
      Rl <- input$Rl
      Z0 <- Mod(Rs)
      
      ratio <- Mod(Rs/Rl)
      Q <- sqrt(ratio - 1)
      
      Xind <- 1i*Q*Rl
      Xcap <- -Xind
      
      C <- -1/(2*pi*Fmid*Im(Xcap))     
      L <- Im(Xind)/(2*pi*Fmid)
      
      plot.new()
      plot.window(c(-scale, scale), c(-scale, scale), asp = 1)
      
      smith_grid(50, 10)
      smith_grid(10, 1)
      smith_grid(2, 0.2)
      smith_grid(0.6, 0.1)
      
      matpoints(scale*Re(cmap(Rs/Z0)), scale*Im(cmap(Rs/Z0)), type = "p", lty = 1, lwd = 1, pch = 21, col = 4, bg = 4)
      admit_line((Xind+Rl)/Z0, Rs/Z0, col = 4)
      matpoints(scale*Re(cmap((Xind+Rl)/Z0)), scale*Im(cmap((Xind+Rl)/Z0)), type = "p", lty = 1, lwd = 1, pch = 21, col = 3, bg = 3)
      react_line(Rl/Z0, (Xind+Rl)/Z0, col = 3)
      matpoints(scale*Re(cmap(Rl/Z0)), scale*Im(cmap(Rl/Z0)), type = "p", lty = 1, lwd = 1, pch = 21, col = 2, bg = 2)
    
      output$Fmatch <- renderText(paste("f = ", signif(Fmid/1e6, 4), " MHz"))
      output$Qmatch <- renderText(paste("Q = ", signif(Q, 3)))
      output$Lmatch <- renderText(paste("L = ", signif(L*1e9, 3), " nH"))
      output$Cmatch <- renderText(paste("C = ", signif(C*1e12, 3), " pF"))
    
    }, width = 2*scale, height = 2*scale, res = 150) # renderPlot
  } # function(input, output)
) # shinyServer
