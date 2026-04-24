# ========================================
# Conor Golson
# Time Series Econometrics Project
#
# Topic: Association between TikTok Engagement & Chess popularity through Google Trends
#
# Objective:
# Examine whether external chess-related search interest
# (Google Trends) is associated with weekly TikTok views and
# follower growth.

# Required packages:
# install.packages(c("tidyverse", "lubridate", "tseries"))
# ========================================

library(tidyverse)
library(lubridate)
library(tseries)

# ========================================


# Read Data
views <- read.csv("viewers_weekly.csv")
followers <- read.csv("followers_weekly.csv")
posts <- read.csv("posts_weekly.csv")
trends <- read.csv("trends_weekly.csv")

# ========================================

# Numeric Values
views$viewers <- as.numeric(views$viewers)
followers$followers <- as.numeric(followers$followers)
posts$posts <- as.numeric(posts$posts)

# ========================================

# Convert Dates
views$week <- as.Date(views$week)
followers$week <- as.Date(followers$week)
posts$week <- as.Date(posts$week)
trends$week <- as.Date(trends$week)

# ========================================

# Aggregate weekly
views <- views %>%
  group_by(week) %>%
  summarise(views = sum(viewers))

followers <- followers %>%
  group_by(week) %>%
  summarise(followers = sum(followers))

posts <- posts %>%
  group_by(week) %>%
  summarise(posts = sum(posts))

trends <- trends %>%
  select(week, chess_weekly, chess.com_weekly, lichess_weekly) %>%
  rename(
    chess = chess_weekly,
    chess_com = `chess.com_weekly`,
    lichess = lichess_weekly
  )


# ========================================

# Merge
data <- merge(views, followers, by = "week", all.x = TRUE)
data <- merge(data, posts, by = "week", all.x = TRUE)
data <- merge(data, trends, by = "week", all.x = TRUE)

# ========================================

# Fix missing values
data$posts[is.na(data$posts)] <- 0

# ========================================

# Add lags
data <- data %>%
  arrange(week) %>%
  mutate(
    chess_lag1 = lag(chess, 1),
    chess_com_lag1 = lag(chess_com, 1),
    lichess_lag1 = lag(lichess, 1)
  )

data <- data %>%
  filter(!is.na(chess_lag1),
         !is.na(views),
         !is.na(posts))

# ========================================

# Visualization

# Views over time
ggplot(data, aes(x = week, y = views)) +
  geom_line(color = "blue", linewidth = 0.8) +
  labs(
    title = "Weekly TikTok Views",
    x = "Week",
    y = "Views",
    color = ""
  ) +
  theme_classic()

# Views vs Chess
ggplot(data, aes(x = week)) +
  geom_line(aes(y = views, color = "Views"), linewidth = 0.8) +
  geom_line(aes(y = chess * max(views)/100, color = "Chess (Scaled)"), linewidth = 0.8) +
  labs(
    title = "Views vs Chess Interest",
    x = "Week",
    y = "Scaled Values",
    color = ""
  ) +
  scale_color_manual(values = c("Views" = "blue", "Chess (Scaled)" = "red")) +
  theme_classic()

# Views vs Chess.com
ggplot(data, aes(x = week)) +
  geom_line(aes(y = views, color = "Views"), linewidth = 0.8) +
  geom_line(aes(y = chess_com * max(views)/10, color = "Chess.com (Scaled)"), linewidth = 0.8) +
  labs(
    title = "Views vs Chess.com Interest",
    x = "Week",
    y = "Scaled Values",
    color = ""
  ) +
  scale_color_manual(values = c("Views" = "blue", "Chess.com (Scaled)" = "darkgreen")) +
  theme_classic()

# Views vs Lichess
ggplot(data, aes(x = week)) +
  geom_line(aes(y = views, color = "Views"), linewidth = 0.8) +
  geom_line(aes(y = lichess * max(views)/15, color = "Lichess (Scaled)"), linewidth = 0.8) +
  labs(
    title = "Views vs Lichess Interest",
    x = "Week",
    y = "Scaled Values",
    color = ""
  ) +
  scale_color_manual(values = c("Views" = "blue", "Lichess (Scaled)" = "purple")) +
  theme_classic()

# ========================================

# Create differenced series for stationarity

# Views
data <- data %>%
  arrange(week) %>%
  mutate(views_diff = views - lag(views)) %>%
  filter(!is.na(views_diff))

# Followers
data <- data %>%
  mutate(followers_diff = followers - lag(followers)) %>%
  filter(!is.na(followers_diff))


# ========================================

# Test Stationarity

# Views
adf.test(data$views)
adf.test(data$views_diff)

# Followers
adf.test(data$followers)
adf.test(data$followers_diff)

# ========================================

# Model Specification & Estimation

# Create lagged variables
data <- data %>%
  arrange(week) %>%
  mutate(
    views_diff_lag1 = lag(views_diff, 1),
    followers_diff_lag1 = lag(followers_diff, 1)
  )

# Filter once
data <- data %>%
  filter(
    !is.na(views_diff_lag1),
    !is.na(followers_diff_lag1)
  )

# Model Views without lagged views
summary(lm(views_diff ~ chess_lag1 + chess_com_lag1 + lichess_lag1 + posts, data = data))

# Model Views with lagged views
summary(lm(views_diff ~ views_diff_lag1 + chess_lag1 + chess_com_lag1 + lichess_lag1 + posts, data = data))

# Model Followers without lagged followers
summary(lm(followers_diff ~ chess_lag1 + chess_com_lag1 + lichess_lag1 + posts, data = data))

# Model Followers with lagged followers
summary(lm(followers_diff ~ followers_diff_lag1 + chess_lag1 + chess_com_lag1 + lichess_lag1 + posts, data = data))

# ========================================

# Robustness Checks

# Remove posting control (identification check) 

# Views no lag
summary(lm(views_diff ~ chess_lag1 + chess_com_lag1 + lichess_lag1, data = data))

# Followers no lag
summary(lm(followers_diff ~ chess_lag1 + chess_com_lag1 + lichess_lag1, data = data))

# Views with lag
summary(lm(views_diff ~ views_diff_lag1 + chess_lag1 + chess_com_lag1 + lichess_lag1, data = data))

# Followers with lag
summary(lm(followers_diff ~ followers_diff_lag1 + chess_lag1 + chess_com_lag1 + lichess_lag1, data = data))

#  Views per post normalization 
data_vpp <- data %>%
  mutate(views_per_post = ifelse(posts > 0, views / posts, NA))

data_vpp <- data_vpp %>%
  filter(!is.na(views_per_post))

summary(lm(views_per_post ~ chess_lag1 + chess_com_lag1 + lichess_lag1, data = data_vpp))

# With Lag
data_vpp <- data_vpp %>%
  mutate(views_per_post_lag1 = lag(views_per_post, 1)) %>%
  filter(!is.na(views_per_post_lag1))

summary(lm(views_per_post ~ views_per_post_lag1 + chess_lag1 + chess_com_lag1 + lichess_lag1, data = data_vpp))

# ========================================

# Diagnostic Tests and Model Validation

# Views
acf(residuals(lm(views_diff ~ chess_lag1 + chess_com_lag1 + lichess_lag1 + posts, data = data)))

# Followers
acf(residuals(lm(followers_diff ~ chess_lag1 + chess_com_lag1 + lichess_lag1 + posts, data = data)))

# Views
Box.test(residuals(lm(views_diff ~ chess_lag1 + chess_com_lag1 + lichess_lag1 + posts, data = data)),
         lag = 5, type = "Ljung-Box")
# Followers
Box.test(residuals(lm(followers_diff ~ chess_lag1 + chess_com_lag1 + lichess_lag1 + posts, data = data)),
         lag = 5, type = "Ljung-Box")

# ========================================

# write.csv(data, "final_dataset.csv", row.names = FALSE)
