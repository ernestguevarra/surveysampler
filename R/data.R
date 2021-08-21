################################################################################
#
#'
#' Full village list with population size and cluster identifier for villages
#' selected by probability proportional to population size
#'
#' A tibble with 73 rows and 4 columns:
#'
#' **Variable** | **Description**
#' :--- | :---
#' *id* | Village identifier
#' *village* | Village name
#' *population* | Population size
#' *cluster* | Cluster identifier for selected villages
#'
#' @examples
#' village_list
#'
#' @source Data from a SMART survey conducted in Cameroon in 2020
#'
#
################################################################################
"village_list"


################################################################################
#
#'
#' Sample dataset from villages selected from full list via probability
#' proportional to population size
#'
#' A tibble with 407 rows and 11 columns:
#'
#' **Variable** | **Description**
#' :--- | :---
#' *surveydate* | Date of survey
#' *psu* | Primary sampling unit identifier
#' *sex* | Sex of child
#' *birthdate* | Date of birth of child
#' *age* | Age of child in months
#' *weight* | Weight of child in kilograms
#' *height* | height of child in centimetres
#' *oedema* | Does the child have oedema? 0 = FALSE; 1 = TRUE
#' *muac* | Mid-upper arm circumference in millimetres
#' *measure* | Was the child's height or length measured? l = length; h = height
#' *clothes( | Was the child wearing clothes when measured? y = TRUE; n = FALSE)
#'
#' @examples
#' sample_data
#'
#' #' @source Data from a SMART survey conducted in Cameroon in 2020
#'
#
################################################################################
"sample_data"
