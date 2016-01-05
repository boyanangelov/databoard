library(devtools)
devtools::install_github("ramnathv/htmlwidgets")
devtools::install_github("bokeh/rbokeh")

# Dygraphs
library(dygraphs)

df <- tbl_df(read_csv("../data/bd_new.csv"))
df <- data.frame(df[1:4])
df[2:4] <- sapply(df[2:4], as.numeric)
names(df) <- c("date", "total_likes", "daily_new_likes", "daily_new_unlikes")
df <- df[-1,]
rownames(df) <- df[[1]]
df <- df[2:4]

df_just_total <- df[1]

ggthemr('fresh')
dygraph(df_just_total) %>%
    dyOptions(stackedGraph = TRUE) %>%
    dyRangeSelector(height = 20)

dygraph(df$daily_new_likes) 

plot_1 <- ggplot(df, aes(x = factor(0), daily_new_likes)) + 
    geom_boxplot() + ggtitle("Distribution of daily new likes") + 
    ylab("New likes")

plot_2 <- ggplot(df, aes(daily_new_likes, daily_new_unlikes)) + 
    geom_point() + geom_smooth() + ggtitle("Correlation between daily likes and unlikes") + 
    xlab("Likes") + ylab("Unlikes")

multiplot(plot_1, plot_2, cols = 2)

# RCharts
library(rCharts)
library(lubridate)

df <- df[-1,] # mandatory cleaning

df$date <- format(df$date, format = "%Y-%m-%d")

d1 <- dPlot(total_likes ~ date, type = 'line', data = df)
d2 <- d1 
d2$field(
    'templates',
    modifyList(d2$templates, list(id = "chart2", script = 'http://timelyportfolio.github.io/rCharts_dimple/assets/chart_d3dateaxis.html') )
)
d2
d1

# ggvis
library(ggvis)

df <- df[-1,] 
df %>% 
    ggvis(~ date, ~ total_likes) %>% 
    layer_lines() %>% 
    add_tooltip(function(df) df$total_likes) %>%
    add_axis("x", title = "Date") %>%
    add_axis("y", title = "Total likes")
df %>% 
    ggvis(~ factor(0), ~daily_new_likes) %>% 
    layer_boxplots( )%>%
    add_axis("x", title = "New likes distribution")
df %>% 
    ggvis(~ factor(0), ~daily_new_unlikes) %>% 
    layer_boxplots( )%>%
    add_axis("x", title = "New unlikes distribution")
df %>% 
    ggvis(~ daily_new_likes, ~daily_new_unlikes) %>% 
    layer_points() %>% 
    layer_model_predictions(model = "lm", se = TRUE ) %>%
    add_axis("x", title = "Unlikes") %>%
    add_axis("y", title = "Likes")


# R bokeh 
library(rbokeh)

f1 <- figure(title = "Number of fans",
       xlab = "Date",
       ylab = "Number of fans") %>%
    ly_points(date, total_likes, data = df,
              hover = list(total_likes),
              glyph = 21) %>%
    ly_lines(date, total_likes, data = df)
f2 <- figure(title = "Daily new likes",
       xlab = "",
       ylab = "Distribution") %>%
    ly_boxplot(daily_new_likes, data = df)
f3 <- figure(title = "Likes vs Unlikes correlation",
       xlab = "Likes",
       ylab = "Unlikes") %>%
    ly_points(daily_new_likes, daily_new_unlikes, data = df,
              hover = list(daily_new_likes, daily_new_unlikes), 
              glyph = 21,
              color = "green")
f_list <- list(f1, f2, f3)

grid_plot(f_list)




# Old ggplot 
library(ggthemr)

output$fans_plot <- renderPlot({
    df <- theData()
    
    ggthemr("solarized")
    plot_1 <- ggplot(df, aes(date, total_likes)) + geom_point(size = 4) + 
        geom_segment(aes(xend = date), yend = 0, colour = "brown") + 
        ggtitle("How many fans do you have?") + xlab("Date") + ylab("Number of fans")
    plot_2 <- ggplot(df, aes(date, total_likes)) + geom_line() + 
        ggtitle("How many fans do you have?") + xlab("Date") + ylab("Number of fans")
    plot_3 <- ggplot(df, aes(x = factor(0), daily_new_likes)) + 
        geom_boxplot() + ggtitle("Distribution of daily new likes") + 
        ylab("New likes")
    plot_4 <- ggplot(df, aes(daily_new_likes, daily_new_unlikes)) + 
        geom_point() + geom_smooth() + ggtitle("Correlation between daily likes and unlikes") + 
        xlab("Likes") + ylab("Unlikes")
    
    multiplot(plot_1, plot_2, plot_3, plot_4, cols = 2)
})
