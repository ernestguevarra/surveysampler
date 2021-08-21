################################################################################
#
#'
#' Calculate sampling interval
#'
#' @param n_sample Number of sample required
#' @param n_total Total number to sample from
#' @param rounding Should the result be rounded up (ceiling) or rounded down
#'   (floor)? Default is rounded down.
#'
#' @return An integer value representing the sampling interval.
#'
#' @author Ernest Guevarra
#'
#' @examples
#' calculate_sampling_interval(30, 200)
#'
#' @export
#'
#
################################################################################

calculate_sampling_interval <- function(n_sample, n_total,
                                        rounding = c("floor", "ceiling")) {
  sampling_interval <- eval(
    parse(text = paste0(match.arg(rounding), "(n_total / n_sample)"))
  )

  sampling_interval
}


################################################################################
#
#'
#' Draw a systematic sample from a dataset of all potential samples
#'
#' @param x A data.frame of all potential samples
#' @param n_sample Number of sample required
#' @param rounding Should the result be rounded up (ceiling) or rounded down
#'   (floor)? Default is rounded down.
#'
#' @return A data.frame drawn from *x* that contains the sample selected
#'   systematically
#'
#' @author Ernest Guevarra
#'
#' @examples
#' get_sample_systematic(x = village_list, n_sample = 30)
#'
#' @export
#'
#
################################################################################

get_sample_systematic <- function(x, n_sample,
                                  rounding = c("floor", "ceiling")) {
  ## Calculate sampling interval
  sampling_interval <- calculate_sampling_interval(n_sample = n_sample,
                                                   n_total = nrow(x),
                                                   rounding = rounding)

  ## Get a random start
  random_start <- sample(1:sampling_interval, size = 1)

  ## Get sequence of selected row numbers
  selected_row_numbers <- seq(from = random_start, to = nrow(x),
                              by = sampling_interval)

  ## Get selected sample
  selected_sample <- x[selected_row_numbers, ]

  ## Return selected sample
  selected_sample
}
