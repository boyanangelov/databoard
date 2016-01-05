df <- tbl_df(read_csv("../data/bd.csv"))
df <- df[-1,]
rownames(df) <- df[[1]]
colnames(df)[1] <- "date_main"

date_1 <- as.Date("2015-08-28")
date_2 <- as.Date("2015-09-02")

rows <- row.names(df)
subset_rows <- rows[rows >= date_1 & rows <= date_2]
subset_df <- df[df$date_main %in% as.Date(subset_rows),]
