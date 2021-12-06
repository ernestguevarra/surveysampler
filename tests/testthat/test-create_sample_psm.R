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


test_that("create_sample_psm works", {
  expect_s3_class(
    create_sample_psm(
      x = x, svy = svy,
      psu = c("villageNumber", "cluster_number"),
      match = "clusterID", pop = "population"
    ),
    "data.frame"
  )
})
