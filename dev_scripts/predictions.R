# loading dependencies
p_load(marketeR, forecast)

# Subset just numeric values from df
df <- read_csv("data/bd.csv")
df <- df[-1, ]
rownames(df) <- df[[1]]
df <- df[, -1]
rows <- rownames(df)

plot_1 <- predictPlot(df[2], 12, "Total Fans", "Days", "Fan number")
plot_2 <- predictPlot(df[3], 12, 'Daily New Likes', "Days", "New likes")
plot_3 <- predictPlot(df[3], 12, "Daily New Unlikes", 'Days', "New Unlikes")
plot_4 <- predictPlot(df[4], 12, 'Weekly Page Engaged Users', "Days", "Users" )

multiplot(plot_1, plot_2, plot_3, plot_4, cols = 2)

