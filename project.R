#### Final Project
### Darknet Sales Reviews - Trust in illicit markets

# install and load libraries
install.packages("tidytext")
install.packages("textdata")
install.packages("dplyr")
install.packages("stringr")
install.packages("interactions")
install.packages("ggplot2")
install.packages("ggplot")
install.packages("lubridate")

library(tidytext)
library(textdata)
library(dplyr)
library(stringr)
library(interactions)
library(ggplot2)
library(lubridate)

# set working directory
setwd("~/Documents/Classes/Fall 2025/SOCI 318/Final Project")

# load data
# sales reviews
load("~/Documents/Classes/Fall 2025/SOCI 318/Data_export/Darknet sales reviews.RData")
View(darknet_text)
head(darknet_text)

# dea classifications
dea <- read.csv("darknet drugs - sorted-dea-classifications.csv")
View(dea)
head(dea)

# ******************** PART 0: EDA ********************
# getting csv data for more eda
write.csv(darknet_text, "darknet_sales_reviews.csv", row.names = FALSE)

# total entries
nrow(darknet_text)

# total spent within this set of darknet transactions
sum(darknet_text$price_USD)

# mean, median, and range of prices
mean(darknet_text$price_USD)
sd(darknet_text$price_USD)
median(darknet_text$price_USD)
range(darknet_text$price_USD)

# mean, median, and range of ratings
mean(darknet_text$rating)
sd(darknet_text$rating)
median(darknet_text$rating)
range(darknet_text$rating)

# unique values within meta_category column
length(unique(darknet_text$meta_category))
unique(darknet_text$meta_category)

non_drug_categories <- c("Accounts", "Services", "eBooks", "Banks", 
                         "CC/CVV", "PayPal", "Dumps", "Scans", 
                         "Counterfeits", "Unknown", "Others")

# subset to drugs
darknet_drugs <- darknet_text[!darknet_text$meta_category %in% non_drug_categories, ]
unique(darknet_drugs$meta_category)
length(unique(darknet_drugs$meta_category))

write.csv(darknet_drugs, "darknet_drugs_sales_reviews.csv", row.names = FALSE)

# total drug-related entries
nrow(darknet_drugs)

# total spent within this set of drug-related darknet transactions
sum(darknet_drugs$price_USD)

# mean, median, and range of prices
mean(darknet_drugs$price_USD)
sd(darknet_drugs$price_USD)
median(darknet_drugs$price_USD)
range(darknet_drugs$price_USD)

# mean, median, and range of ratings
mean(darknet_drugs$rating)
sd(darknet_drugs$rating)
median(darknet_drugs$rating)
range(darknet_drugs$rating)

# top sellers
seller_counts <- table(darknet_text$Seller)
sorted_counts <- sort(seller_counts, decreasing = TRUE)
top_20_sellers <- head(sorted_counts, 20)

barplot(top_20_sellers,
        main = "Top 20 Sellers by Number of Reviews",
        ylab = "Number of Reviews",
        col = "light blue",
        las = 2,
        cex.names = 0.5)

# drugs counts
drug_counts_all <- darknet_drugs %>%
  group_by(meta_category) %>%
  summarize(n = n()) %>%
  arrange(n)

barplot(
  drug_counts_all$n,
  names.arg = drug_counts_all$meta_category,
  las = 1,
  col = "lightblue",
  horiz = TRUE,
  cex.names = 0.4,
  main = "All Drugs Sold on the Darknet (Total Sales)",
  xlab = "Number of Transactions"
)

# top drugs for top seller
top_3_sellers <- darknet_drugs %>%
  count(Seller, sort = TRUE) %>%
  slice(1:3)

top_3_sellers

seller1 <- top_3_sellers$Seller[1]
seller2 <- top_3_sellers$Seller[2]
seller3 <- top_3_sellers$Seller[3]

top3_seller1 <- darknet_drugs %>%
  filter(Seller == seller1) %>%
  count(meta_category, sort = TRUE) %>%
  slice_head(n = 3)

top3_seller2 <- darknet_drugs %>%
  filter(Seller == seller2) %>%
  count(meta_category, sort = TRUE) %>%
  slice_head(n = 3)

top3_seller3 <- darknet_drugs %>%
  filter(Seller == seller3) %>%
  count(meta_category, sort = TRUE) %>%
  slice_head(n = 3)

barplot(
  top3_seller1$n,
  names.arg = top3_seller1$meta_category,
  las = 2,
  col = "lightblue",
  main = paste("Top 3 Drugs Sold by", seller1),
  ylab = "Number of Transactions"
)

barplot(
  top3_seller2$n,
  names.arg = top3_seller2$meta_category,
  las = 2,
  col = "lightblue",
  main = paste("Top 2 Drugs Sold by", seller2),
  ylab = "Number of Transactions"
)

barplot(
  top3_seller3$n,
  names.arg = top3_seller3$meta_category,
  las = 2,
  col = "lightblue",
  main = paste("Top 2 Drugs Sold by", seller3),
  ylab = "Number of Transactions"
)

# ******************** PART 1: Sentiment analysis ********************
# tokenize into words
darknet_words <- darknet_drugs %>%
  mutate(sales_review = row_number()) %>%
  unnest_tokens(word, review_text)

# load afinn lexicon
afinn <- get_sentiments("afinn")

# join scores to each token
afinn_darknet <- darknet_words %>%
  left_join(afinn, by = "word")

afinn_darknet$value[is.na(afinn_darknet$value)] <- 0

# create positive & negative sentiment fields
afinn_darknet <- afinn_darknet %>%
  mutate(
    positive_sentiment = ifelse(value > 0, value, 0),
    negative_sentiment = ifelse(value < 0, value, 0)
  )

# aggregate sentiment back to transaction level
sent <- afinn_darknet %>%
  group_by(sales_review) %>%
  summarize(
    positive = sum(positive_sentiment),
    negative = sum(negative_sentiment),
    net_tone = sum(value)
  )

# attach sentiment back to original drug data
sent <- sent %>%
  left_join(
    darknet_drugs %>% mutate(sales_review = row_number()),
    by = "sales_review"
  )

# net tone histogram
hist(
  sent$net_tone,
  main = "Distribution of Net Tone (AFINN)",
  xlab = "Net Sentiment Score",
  col = "lightblue"
)

# summary statistics
summary(sent$net_tone)
summary(sent$positive)
summary(sent$negative)

write.csv(sent,
          "sentiment_results_darknet.csv",
          row.names = FALSE)

# most positive review
max_id <- which.max(sent$net_tone)
darknet_drugs$review_text[max_id]

# most negative review
min_id <- which.min(sent$net_tone)
darknet_drugs$review_text[min_id]

# ******************** PART 2: Regression ********************
# cleaning sentiment and dea data
names(sent) <- tolower(names(sent))
names(dea) <- tolower(names(dea))

sent$meta_category <- tolower(trimws(sent$meta_category))
dea$meta_category <- tolower(trimws(dea$meta_category))

# grouping based on main active chemical
sent <- sent %>%
  mutate(
    drug_clean = case_when(
      meta_category %in% c("ecstasy","mdma") ~ "mdma",
      meta_category %in% c("oxycodon","oxycodone","percocet","perocet") ~ "oxycodone",
      TRUE ~ meta_category
    )
  )

# merge DEA schedule onto sentiment dataset
data <- sent %>%
  left_join(dea %>% select(meta_category, schedule),
            by = c("drug_clean" = "meta_category"))

# convert schedule to factor
data$schedule_factor <- factor(
  data$schedule,
  levels = c(1,2,3,4,6),
  labels = c("Schedule I", "Schedule II", "Schedule III", "Schedule IV", "Not Scheduled")
)

# parse dates to determine seller experience
data$date <- mdy(data$date)

# experience = # past transactions
# experience_days = number of days since seller first appeared
data <- data %>%
  group_by(seller) %>%
  arrange(date) %>%
  mutate(
    experience_count = row_number() - 1,
    experience_days = as.numeric(date - min(date))
  ) %>%
  ungroup()

# Model 1 (full model) (experience, risk, sentiment, rating)
model1 <- lm(price_usd ~ experience_count * schedule_factor +
               rating + net_tone, data = data)


# Model 2 (excluding sentiment) (experience, risk, rating)
model2 <- lm(price_usd ~ experience_count * schedule_factor +
               rating, data = data)

# Model 3 (excluding ratings) (experience, risk, sentiment)
model3 <- lm(price_usd ~ experience_count * schedule_factor +
               net_tone, data = data)

# Model 4 (rating x experience)
model4 <- lm(price_usd ~ experience_count * rating +
               net_tone, data = data)

# Model 5 (schedule only)
model5 <- lm(price_usd ~ schedule_factor, data = data)


summary(model1)
summary(model2)
summary(model3)
summary(model4)
summary(model5)

# interactions
interact_plot(
  model1,
  pred = experience_count,
  modx = schedule_factor,
  main.title = "Model 1: Experience × Schedule (Rating + Sentiment)"
)

interact_plot(
  model2,
  pred = experience_count,
  modx = schedule_factor,
  main.title = "Model 2: Experience × Schedule (Rating Only)"
)

interact_plot(
  model3,
  pred = experience_count,
  modx = schedule_factor,
  main.title = "Model 3: Experience × Schedule (Sentiment Only)"
)

# ******************** PART 3: Wrap up ********************
transaction_counts <- data %>%
  count(schedule_factor) %>%
  arrange(schedule_factor)

transaction_counts

par(mar = c(10, 4, 4, 2))

barplot(
  height = transaction_counts$n,
  names.arg = transaction_counts$schedule_factor,
  col = "lightblue",
  las = 2,                 # rotate labels for readability
  main = "Transactions by DEA Schedule",
  ylab = "Number of Transactions",
)

# ******************** PART 4: Testing ********************
vendor_level <- data %>%
  group_by(seller) %>%
  summarize(
    avg_price = mean(price_usd, na.rm = TRUE),
    total_sales = max(experience_count)
  )

cor(vendor_level$avg_price, vendor_level$total_sales, use = "complete.obs")

lm(total_sales ~ avg_price, data = vendor_level)
