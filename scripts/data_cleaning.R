# install.packages("pacman")
pacman::p_load(dplyr, baseballr, readr, lubridate)

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

# only relevant columns
tj_data <- tj_data %>%
  select(Player, mlbamid, fgid, Team, Throws, Country, `High School`, `College(s)`, Age, surgery_date, surgery_year, return_date, return_year, `Surgeon(s)`)

tj_data <- tj_data %>%
  filter(!is.na(return_date))

