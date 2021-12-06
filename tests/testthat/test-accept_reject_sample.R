sim_survey <- accept_reject_psu(
  x = village_list,
  svy = sample_data,
  psu = c("id", "psu"),
  match = "cluster",
  pop = "population",
  verbose = FALSE,
  show_plot = FALSE
)

## Test if output is a data.frame
test_that("output is a data.frame", {
  expect_s3_class(sim_survey, "data.frame")
})


## Change variables name of village list
x <- village_list
names(x) <- c("psu", "villageName", "population", "clusterID")

svy <- sample_data
names(svy) <- c("surveydate", "psu", "sex", "birthdate", "age",
                "weight", "height", "oedema", "muac", "measure", "clothes")

sim_survey <- accept_reject_psu(
  x = x,
  svy = svy,
  #psu = c("id", "psu"),
  match = "clusterID",
  pop = "population",
  verbose = FALSE,
  show_plot = FALSE
)

test_that("output has the correct structure", {
  expect_true(all(names(svy) %in% names(sim_survey)))
  expect_equal(names(svy), names(sim_survey))
})

sim_survey <- accept_reject_psu(
  x = x,
  svy = svy,
  #psu = c("id", "psu"),
  match = "clusterID",
  pop = "population",
  verbose = TRUE,
  show_plot = TRUE,
  save_plot = TRUE
)

test_that("output has the correct structure", {
  expect_true(all(names(svy) %in% names(sim_survey)))
  expect_equal(names(svy), names(sim_survey))
})

## Change variables name of village list
x <- village_list
names(x) <- c("id", "villageName", "population", "psu")

svy <- sample_data
names(svy) <- c("surveydate", "psu", "sex", "birthdate", "age",
                "weight", "height", "oedema", "muac", "measure", "clothes")

sim_survey <- accept_reject_psu(
  x = x,
  svy = svy,
  psu = c("id", "psu"),
  pop = "population",
  verbose = FALSE,
  show_plot = FALSE
)

test_that("output has the correct structure", {
  expect_true(all(names(svy) %in% names(sim_survey)))
  expect_equal(names(svy), names(sim_survey))
})
