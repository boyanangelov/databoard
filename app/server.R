# Server
server <- shinyServer(function(input, output) {
    
    theData <- reactive({
        # choose ggtheme
        ggthemr('fresh')
        
        # capture file
        inFile <- input$file1
        if (is.null(inFile))
            return(NULL)
        
        # capture date inputs
        date_1 <- as.Date(input$dateRange[[1]])
        date_2 <- as.Date(input$dateRange[[2]])
        
        # clean dataframe
        pre_df <- read_csv(inFile$datapath)
        df <- data.frame(pre_df[1:4])
        df[2:4] <- sapply(pre_df[2:4], as.numeric)
        names(df) <- c("date_main", "total_likes", "daily_new_likes", 
                                    "daily_new_unlikes")
        df <- df[-1,]
        rownames(df) <- df[[1]]
        rows <- rownames(df)
        subset_rows <- rows[rows >= date_1 & rows <= date_2]
        df <- df[df$date_main %in% as.Date(subset_rows),]
        df
    })
    
    
    output$forecasts <- renderPlot({
        df <- theData()
        
        plot_1 <- predictPlot(df[2], 12, "Total Fans", "Days", "Fan number")
        plot_2 <- predictPlot(df[3], 12, 'Daily New Likes', "Days", "New likes")
        plot_3 <- predictPlot(df[4], 12, "Daily New Unlikes", 'Days', "New Unlikes")
        
        multiplot(plot_1, plot_2, plot_3, cols = 2)
    })
    
    output$time_series <- renderDygraph({
        df <- theData()
        
        rownames(df) <- df[[1]]
        df <- df[2:4]
        
        df_just_total <- df[1]
        
        dygraph(df_just_total) %>%
            dyOptions(stackedGraph = TRUE) %>%
            dyRangeSelector(height = 20)
    })
    
    output$visualisations <- renderPlot({
        df <- theData()
        
        plot_1 <- ggplot(df, aes(x = factor(0), daily_new_likes)) + 
            geom_boxplot() + ggtitle("Distribution of daily new likes") + 
            ylab("New likes")
        
        plot_2 <- ggplot(df, aes(x = factor(0), daily_new_unlikes)) + 
            geom_boxplot() + ggtitle("Distribution of daily new unlikes") + 
            ylab("New unlikes")
        
        plot_3 <- ggplot(df, aes(daily_new_likes, daily_new_unlikes)) + 
            geom_point() + geom_smooth() + ggtitle("Correlation between daily likes and unlikes") + 
            xlab("Likes") + ylab("Unlikes")

        multiplot(plot_1, plot_2, plot_3, cols = 3)
    })
    
    
})
