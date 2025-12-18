# install.packages("pacman")
pacman::p_load(dplyr, baseballr, readr, lubridate, tidyr)

# read in raw tommy john surgery list file
tj_data_raw <- read_csv("../data/tj_surgery_list.csv")

# only MLB pitchers
tj_data <- tj_data_raw %>%
  filter(Position == "P", Level == "MLB")

# convert surgery and return dates into DATE data type and add year into a separate column
tj_data <- tj_data %>%
  mutate(
    surgery_date = mdy(`TJ Surgery Date`),  # converts "9/19/2017" to date
    surgery_year = year(surgery_date),   # extracts just the year
    return_date = mdy(`Return Date (same level)`),  
    return_year = year(return_date)  
  )
# grab surgeries on in between 2018-2023 for return dates to have before/after data
tj_data <- tj_data %>%
  filter(return_year >= 2018 & return_year <= 2023)

# split player name into first and last
tj_data <- tj_data %>%
  separate(Player, 
           into = c("first_name", "last_name"), 
           sep = " ", 
           remove = FALSE)  # keep original column

# only pitchers that have returned
tj_data <- tj_data %>%
  filter(!is.na(return_date))

# player id joins ----
# player_ids <- chadwick_player_lu()

# Left join using mlbamid and key_mlbam
tj_data <- tj_data %>%
  left_join(player_ids, by = c("mlbamid" = "key_mlbam"))

# only relevant columns
tj_data <- tj_data %>%
  select(Player, name_first, name_last, mlbamid, key_fangraphs, Team, Throws, Country, Age, surgery_date, surgery_year, return_date, return_year, `Surgeon(s)`)
