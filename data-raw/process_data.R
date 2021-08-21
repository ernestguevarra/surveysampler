## Load libraries
library(readxl)
library(dplyr)
library(magrittr)

# Full village list -----------------------------------------------------------

## Read data
village_list <- readxl::read_xlsx(
  path = "data-raw/liste villages et grappes.xlsx",
  sheet = 1,
  #col_types = c("text", "text", "numeric", "numeric", "text", "numeric"),
  skip = 2
) %>%
  select(VILLAGE, Population, Grappe) %>%
  rename(
    village = VILLAGE,
    population = Population,
    cluster = Grappe
  ) %>%
  mutate(
    id = 1:n()
  ) %>%
  add_row(
    village = "BODO FOUDA",
    population = 1733,
    cluster = "2",
    id = 1
  ) %>%
  add_row(
    village = "AFADE",
    population = 3015,
    cluster = "34",
    id = 70
  ) %>%
  mutate(
    cluster = if_else(cluster == "1 et 2", "1", cluster),
    cluster = if_else(cluster == "33 et 34", "33", cluster)
  ) %>%
  relocate(id)

usethis::use_data(village_list, compress = "xz", overwrite = TRUE)

# Sample dataset for selected villages -----------------------------------------

## Read data
sample_data <- read.csv("data-raw/donnee anthropo_6-59mois.csv") %>%
  select(
    todayDate, village, child_sex, birthdate, age,
    weight, height, edema, muac, measure, clothes
  ) %>%
  rename(
    surveydate = todayDate,
    psu = village,
    sex = child_sex,
    oedema = edema
  ) %>%
  mutate(
    surveydate = as.Date(surveydate, format = "%d/%m/%Y"),
    birthdate = as.Date(birthdate, format = "%d/%m/%Y")
  ) %>%
  tibble::tibble()

usethis::use_data(sample_data, compress = "xz", overwrite = TRUE)
