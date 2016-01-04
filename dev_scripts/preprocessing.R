# Dependencies ------------------------------------------------------------
library(readr)
library(data.table)
library(dplyr)
library(tidyr)
library(formatR)
library(ggplot2)
library(ggthemr)

# Load data ---------------------------------------------------------------
df <- tbl_df(read_csv("../data/amst.csv"))

# sanity checks
dim(df)
str(df)
glimpse(df)

# Data cleaning -----------------------------------------------------------
# not necessary for new facebook insights format

fbCleanHeader <- function(dataframe) {
    # store info
    headerInfo <- dataframe[1,]
    
    # clean dataframe
    dataframe <- dataframe[-1,]
    dataframe <- dataframe[-c(2, 3)]
    
    print("Data cleaned.")
    print("Information stored in <headerInfo>.")
    return(list(dataframe, headerInfo))
}


# Helper functions --------------------------------------------------------

multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
    library(grid)
    
    # Make a list from the ... arguments and plotlist
    plots <- c(list(...), plotlist)
    
    numPlots = length(plots)
    
    # If layout is NULL, then use 'cols' to determine layout
    if (is.null(layout)) {
        # Make the panel
        # ncol: Number of columns of plots
        # nrow: Number of rows needed, calculated from # of cols
        layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                         ncol = cols, nrow = ceiling(numPlots/cols))
    }
    
    if (numPlots==1) {
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


# End helper functions ----------------------------------------------------

output <- fbCleanHeader(df)

df <- output[[1]]
header_info <- (output[[2]]) %>% t() # transpose header info
write.csv(header_info, "data/fb_variables.csv")
write.csv(df, "data/clean_df.csv")

# Subsetting --------------------------------------------------------------

df <- data.frame(df[1:4])
df[2:4] <- sapply(df[2:4], as.numeric)
names(df) <- c("date", "total_likes", "daily_new_likes", "daily_new_unlikes")


# Plots -------------------------------------------------------------------
ggthemr('light')
plot_1 <- ggplot(first_dataframe, aes(date, total_likes)) +
    geom_point(size = 4) +
    geom_segment(aes(xend=date), yend=0, colour = "brown") +
    ggtitle("How many fans do you have?") +
    xlab("Date") +
    ylab("Number of fans")

plot_2 <- ggplot(first_dataframe, aes(date, total_likes)) +
    geom_line() +
    ggtitle("How many fans do you have?") +
    xlab("Date") +
    ylab("Number of fans")

plot_3 <- ggplot(first_dataframe, aes(x = factor(0), daily_new_likes)) +
    geom_boxplot() +
    ggtitle("Distribution of daily new likes") +
    ylab("New likes")

plot_4 <- ggplot(first_dataframe, aes(daily_new_likes, daily_new_unlikes)) +
    geom_point() +
    geom_smooth() +
    ggtitle("Correlation between daily likes and unlikes") +
    xlab("Likes") +
    ylab("Unlikes")

multiplot(plot_1, plot_2, plot_3, plot_4, cols = 2)
