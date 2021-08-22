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
