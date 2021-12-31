sim_survey <- create_sample_psm(
  x = village_list,
  svy = sample_data,
  psu = c("id", "psu"),
  match = "cluster",
  pop = "population"
)


test_that("output is a data.frame", {
  expect_s3_class(sim_survey, "data.frame")
})


## Change variables name of village list
x <- village_list
names(x) <- c("villageNumber", "villageName", "population", "clusterID")

svy <- sample_data
names(svy) <- c("surveydate", "cluster_number", "sex", "birthdate", "age",
                "weight", "height", "oedema", "muac", "measure", "clothes")

new_sample <- create_sample_psm(
  x = x, svy = svy,
  psu = c("villageNumber", "cluster_number"),
  match = "clusterID", pop = "population"
)

test_that("create_sample_psm produces a data.frame", {
  expect_s3_class(new_sample, "data.frame")
})

test_that("output has the correct structure", {
  expect_true(all(names(svy) %in% names(new_sample)))
  expect_equal(names(svy), names(new_sample))
})


## Change variables name of village list
x <- village_list
names(x) <- c("psu", "villageName", "population", "clusterID")

svy <- sample_data
names(svy) <- c("surveydate", "psu", "sex", "birthdate", "age",
                "weight", "height", "oedema", "muac", "measure", "clothes")

new_sample <- create_sample_psm(
  x = x, svy = svy,
  #psu = c("villageNumber", "cluster_number"),
  match = "clusterID", pop = "population",
  sampling_type = "systematic"
)

test_that("output has the correct structure", {
  expect_true(all(names(svy) %in% names(new_sample)))
  expect_equal(names(svy), names(new_sample))
})


## Change variables name of village list
x <- village_list
names(x) <- c("id", "villageName", "population", "psu")

svy <- sample_data
names(svy) <- c("surveydate", "psu", "sex", "birthdate", "age",
                "weight", "height", "oedema", "muac", "measure", "clothes")

new_sample <- create_sample_psm(
  x = x, svy = svy,
  match = NULL, pop = "population",
  sampling_type = "systematic"
)

test_that("output has the correct structure", {
  expect_true(all(names(svy) %in% names(new_sample)))
  expect_equal(names(svy), names(new_sample))
})


test_that("get_sampling_clusters produces a data.frame", {
  expect_s3_class(
    get_sampling_clusters(x = village_list, psu = "cluster", pop = "population"),
    "data.frame")
})
