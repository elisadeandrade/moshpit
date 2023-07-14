mydata <- read.csv("GOODTable.csv",TRUE, ",", skip = 6 )

library(ggplot2)

data_active1 <- mydata[mydata[["activeMoshpitters"]] %in% c(1),]
data_active2 <- mydata[mydata[["activeMoshpitters"]] %in% c(2),]
data_active4 <- mydata[mydata[["activeMoshpitters"]] %in% c(4),]
data_venue_kwart <- mydata[mydata[["inactiveMoshpitters"]] %in% c(162),]
data_venue_half <- mydata[mydata[["inactiveMoshpitters"]] %in% c(325),]
data_venue_full <- mydata[mydata[["inactiveMoshpitters"]] %in% c(650),]

one_sv <- mydata[(mydata[["activeMoshpitters"]] %in% c(1)) & (mydata[["inactiveMoshpitters"]] %in% c(162)),]
one_mv <- mydata[(mydata[["activeMoshpitters"]] %in% c(1)) & (mydata[["inactiveMoshpitters"]] %in% c(325)),]
one_fv  <- mydata[(mydata[["activeMoshpitters"]] %in% c(1)) & (mydata[["inactiveMoshpitters"]] %in% c(650)),]

two_sv <- mydata[(mydata[["activeMoshpitters"]] %in% c(2)) & (mydata[["inactiveMoshpitters"]] %in% c(162)),]
two_mv <- mydata[(mydata[["activeMoshpitters"]] %in% c(2)) & (mydata[["inactiveMoshpitters"]] %in% c(325)),]
two_fv  <- mydata[(mydata[["activeMoshpitters"]] %in% c(2)) & (mydata[["inactiveMoshpitters"]] %in% c(650)),]

four_sv <- mydata[(mydata[["activeMoshpitters"]] %in% c(4)) & (mydata[["inactiveMoshpitters"]] %in% c(162)),]
four_mv <- mydata[(mydata[["activeMoshpitters"]] %in% c(4)) & (mydata[["inactiveMoshpitters"]] %in% c(325)),]
four_fv  <- mydata[(mydata[["activeMoshpitters"]] %in% c(4)) & (mydata[["inactiveMoshpitters"]] %in% c(650)),]










filtered_data <- rbind(one_sv, two_sv, four_sv)
ggplot(filtered_data, aes(x = X.step., y = avg.moshpit.time, color = as.factor(activeMoshpitters))) + 
  geom_line(size = 1) + 
  labs(x = "Ticks", y = "Average Time") + 
  ggtitle("Average Moshpit Time with 1/4 Full Venue") +
  scale_color_discrete(name = "Active Moshpitters")

# Filter data for active moshpitter counter going from 1 to 2
one_to_two <- one_sv %>% 
  filter(active.moshpitter.counter >= 1 & active.moshpitter.counter <= 2)

# Calculate average moshpit time
avg_moshpit_time <- mean(one_to_two$avg.moshpit.time)

filtered_data_mv <- rbind(one_mv, two_mv, four_mv)
ggplot(filtered_data, aes(x = X.step., y = avg.moshpit.time, color = as.factor(activeMoshpitters))) + 
  geom_line(size = 1) + 
  labs(x = "Ticks", y = "Average Time") + 
  ggtitle("Average Moshpit Time with 1/2 Full Venue") +
  scale_color_discrete(name = "Active Moshpitters")

filtered_data_mv <- rbind(one_fv, two_fv, four_fv)
ggplot(filtered_data, aes(x = X.step., y = avg.moshpit.time, color = as.factor(activeMoshpitters))) + 
  geom_line(size = 1) + 
  labs(x = "Ticks", y = "Average Time") + 
  ggtitle("Average Moshpit Time with a Full Venue") +
  scale_color_discrete(name = "Active Moshpitters")


# BAR CHARTS


grouped_data_sv <- one_sv %>%
  group_by(active.moshpitter.counter) %>%
  summarize(avg_total_time = mean(total.time.to.become.active))

# 1/4 FULL VENUE

# Calculate the difference between consecutive avg_total_time values
grouped_data_sv$difference <- c(NA, diff(grouped_data_sv$avg_total_time))

# Filter the data to only include every two consecutive active.moshpitter.counter
grouped_data_filtered <- grouped_data_sv[seq(2, nrow(grouped_data_sv), by = 2), ]

# Plot the bar chart
ggplot(grouped_data_filtered, aes(x = active.moshpitter.counter, y = difference, fill = difference)) +
  geom_col() +
  geom_smooth(method = "loess", se = FALSE, color = "red") +
  xlab("Active Moshpitter") +
  ylab("Average Time") +
  scale_fill_gradient(low = "blue", high = "red") + 
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
ggtitle("Difference in Average Time for 1/4 Full Venue ")






# 1/2 FULL VENUE 

grouped_data_mv <- one_mv %>%
  group_by(active.moshpitter.counter) %>%
  summarize(avg_total_time = mean(total.time.to.become.active))

# Calculate the difference between consecutive avg_total_time values
grouped_data_mv$difference <- c(NA, diff(grouped_data_mv$avg_total_time))

# Filter the data to only include every two consecutive active.moshpitter.counter
grouped_data_filtered <- grouped_data_mv[seq(2, nrow(grouped_data_mv), by = 2), ]

# Plot the bar chart
ggplot(grouped_data_filtered, aes(x = active.moshpitter.counter, y = difference, fill = difference)) +
  geom_col() +
  geom_smooth(method = "loess", se = FALSE, color = "red") +
  xlab("Active Moshpitter") +
  ylab("Average Time") +
  scale_fill_gradient(low = "blue", high = "red") + 
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ggtitle("Difference in Average Time for 1/2 Full Venue ")




# FULL VENUE 

grouped_data_fv <- one_fv %>%
  group_by(active.moshpitter.counter) %>%
  summarize(avg_total_time = mean(total.time.to.become.active))

# Calculate the difference between consecutive avg_total_time values
grouped_data_fv$difference <- c(NA, diff(grouped_data_fv$avg_total_time))

# Filter the data to only include every two consecutive active.moshpitter.counter
grouped_data_filtered <- grouped_data_fv[seq(2, nrow(grouped_data_fv), by = 2), ]

# Plot the bar chart
ggplot(grouped_data_filtered, aes(x = active.moshpitter.counter, y = difference, fill = difference)) +
  geom_col() +
  geom_smooth(method = "loess", se = FALSE, color = "red") +
  xlab("Active Moshpitter") +
  ylab("Average Time") +
  scale_fill_gradient(low = "blue", high = "red") + 
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ggtitle("Difference in Average Time for Full Venue ")















  