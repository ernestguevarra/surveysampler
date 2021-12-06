si <- calculate_sampling_interval(
  n_sample = 30,
  n_total = 300
)

test_that("output is an integer", {
  expect_type(si, "double")
})


samp_systematic <- get_sample_systematic(
  x = sample_data,
  n_sample = 30
)

test_that("output is a data.frame", {
  expect_s3_class(samp_systematic, "data.frame")
})
