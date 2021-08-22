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


