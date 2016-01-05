# Helper functions
fbCleanHeader <- function(dataframe) {
    # store info
    headerInfo <- dataframe[1, ]
    
    # clean dataframe
    dataframe <- dataframe[-1, ]
    dataframe <- dataframe[-c(2, 3)]
    
    print("Data cleaned.")
    print("Information stored in <headerInfo>.")
    return(list(dataframe, headerInfo))
}

multiplot <- function(..., plotlist = NULL, file, cols = 1, layout = NULL) {
    library(grid)
    
    # Make a list from the ... arguments and plotlist
    plots <- c(list(...), plotlist)
    
    numPlots = length(plots)
    
    # If layout is NULL, then use 'cols' to determine layout
    if (is.null(layout)) {
        # Make the panel ncol: Number of columns of plots nrow: Number of rows
        # needed, calculated from # of cols
        layout <- matrix(seq(1, cols * ceiling(numPlots/cols)), ncol = cols, 
                         nrow = ceiling(numPlots/cols))
    }
    
    if (numPlots == 1) {
        print(plots[[1]])
        
    } else {
        # Set up the page
        grid.newpage()
        pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
        
        # Make each plot, in the correct location
        for (i in 1:numPlots) {
            # Get the i,j matrix positions of the regions that contain this subplot
            matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
            
            print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row, 
                                            layout.pos.col = matchidx$col))
        }
    }
}

# arima plot helper function
autoplot.forecast <- function(forecast, title, xtitle, ytitle, ...){
    # data wrangling
    time <- attr(forecast$x, "tsp")
    time <- seq(time[1], attr(forecast$mean, "tsp")[2], by=1/time[3])
    lenx <- length(forecast$x)
    lenmn <- length(forecast$mean)
    
    df <- data.frame(time=time,
                     x=c(forecast$x, forecast$mean),
                     forecast=c(rep(NA, lenx), forecast$mean),
                     low1=c(rep(NA, lenx), forecast$lower[, 1]),
                     upp1=c(rep(NA, lenx), forecast$upper[, 1]),
                     low2=c(rep(NA, lenx), forecast$lower[, 2]),
                     upp2=c(rep(NA, lenx), forecast$upper[, 2])
    )
    
    ggplot(df, aes(time, x)) +
        geom_ribbon(aes(ymin=low2, ymax=upp2), fill="yellow") +
        geom_ribbon(aes(ymin=low1, ymax=upp1), fill="orange") +
        geom_line() +
        geom_line(data=df[!is.na(df$forecast), ], aes(time, forecast), color="blue", na.rm=TRUE) +
        scale_x_continuous("") +
        scale_y_continuous("") +
        ggtitle(title) +
        xlab(xtitle) + 
        ylab(ytitle)
}

predictPlot <- function(data, period, title, xtitle, ytitle) {
    data.fit <- auto.arima(data)
    data.predictions <- forecast(data.fit, period)
    return(autoplot(data.predictions, title, xtitle, ytitle))
}
