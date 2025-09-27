#### Final Project
### Darknet Sales Reviews - Trust in illicit markets

# setting working directory
setwd("~/Documents/Classes/Fall 2025/SOCI 318/Final Project")

# loading in data
load("~/Documents/Classes/Fall 2025/SOCI 318/Data_export/Darknet sales reviews.RData")

# basic eda
View(darknet_text)
head(darknet_text)

# getting csv data for more eda
write.csv(darknet_text, "darknet_sales_reviews.csv", row.names = FALSE)

total_entries <- nrow(darknet_text)

# categories of Seller, Buyer, meta_category
unique(darknet_text$Seller)
unique(darknet_text$Buyer)
unique(darknet_text$meta_category)

# mean, median, and range of prices
mean(darknet_text$price_USD)
median(darknet_text$price_USD)
range(darknet_text$price_USD)

# mean, median, and range of ratings
mean(darknet_text$rating)
median(darknet_text$rating)
range(darknet_text$rating)

# top sellers
seller_counts <- table(darknet_text$Seller)
sorted_counts <- sort(seller_counts, decreasing = TRUE)
top_20_sellers <- head(sorted_counts, 20)
barplot(top_20_sellers,
        main = "Top 20 Sellers by Number of Reviews",
        ylab = "Number of Reviews",
        col = "skyblue",
        las = 2)

