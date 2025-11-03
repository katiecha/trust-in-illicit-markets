#### Final Project
### Exploratory Data Analysis





### Part 1: All datasets
folder_path <- "~/Documents/Classes/Fall 2025/SOCI 318/Data_export"
file_names <- list.files(path = folder_path)
print(file_names)





### Part 2: Interesting datasets
load("~/Documents/Classes/Fall 2025/SOCI 318/Data_export/2016 House of Reps Twitter network data.RData")
View(house_attributes)
View(house_networks)

load("~/Documents/Classes/Fall 2025/SOCI 318/Data_export/2016 Russia bots tweets.RData")
View(russia_tweets)

load("~/Documents/Classes/Fall 2025/SOCI 318/Data_export/2018 HIV infection rates.RData")
View(HIVdata)

load("~/Documents/Classes/Fall 2025/SOCI 318/Data_export/All of Elon Musk's tweets ever.RData")
View(musk_tweets)

load("~/Documents/Classes/Fall 2025/SOCI 318/Data_export/All of Trump's tweets ever.RData")
View(trump_tweets)

load("~/Documents/Classes/Fall 2025/SOCI 318/Data_export/BLM tweets.RData")
View(blm)

load("~/Documents/Classes/Fall 2025/SOCI 318/Data_export/Darknet sales reviews.RData")
View(darknet_text)

load("~/Documents/Classes/Fall 2025/SOCI 318/Data_export/Darknet vendor locations.Rdata")
View(vendor_geo)

load("~/Documents/Classes/Fall 2025/SOCI 318/Data_export/EU powergrid.RData")
View(eu_powergrid)

load("~/Documents/Classes/Fall 2025/SOCI 318/Data_export/Four cocaine smuggling networks.RData")
View(acero)
View(jake)
View(juanes)
View(mamba)

load("~/Documents/Classes/Fall 2025/SOCI 318/Data_export/Job callbacks by race.RData")
View(callbacks)

load("~/Documents/Classes/Fall 2025/SOCI 318/Data_export/North American powergrid.RData")
View(net)





### Part 3a: Trust and reputation in illicit markets
load("~/Documents/Classes/Fall 2025/SOCI 318/Data_export/Darknet sales reviews.RData")
View(darknet_text)
head(darknet_text)



### Part 3b: Comparing illicit supply chains: physical vs. digital
load("~/Documents/Classes/Fall 2025/SOCI 318/Data_export/Darknet vendor locations.Rdata")
head(vendor_geo)

load("~/Documents/Classes/Fall 2025/SOCI 318/Data_export/Four cocaine smuggling networks.RData")
head(acero)
head(jake)
head(juanes)
head(mambo)



### Part 3c: Did bot activity infiltrate or amplify partisan clusters in the House network?
load("~/Documents/Classes/Fall 2025/SOCI 318/Data_export/2016 House of Reps Twitter network data.RData")
View(house_attributes)
View(house_networks)

load("~/Documents/Classes/Fall 2025/SOCI 318/Data_export/2016 Senator Twitter network data.RData")
View(senate_attributes)
View(senate_networks)

load("~/Documents/Classes/Fall 2025/SOCI 318/Data_export/2016 Russia bots tweets.RData")
View(russia_tweets)

head(house_attributes)
head(house_networks)
head(senate_attributes)
head(senate_networks)
head(russia_tweets)
