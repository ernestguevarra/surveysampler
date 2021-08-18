################################################################################
#
#'
#' Accept or reject sampling units against population density of potential
#' sampling units
#'
#' @param x A data.frame of all potential primary sampling units (PSUs) to
#'   sample from each uniquely identified and with corresponding populations.
#' @param svy A data.frame of survey data drawn via probability proportional
#'   to population size (PPS) approach from all the potential PSUs in *x*.
#' @param psu A single character value or vector of values corresponding to
#'   the variable name/s for the primary sampling unit in *x* and *svy*.
#'   Default is *"psu"*.
#' @param match A single character value corresponding to the variable name
#'   for the primary sampling unit in *x* that matches the primary sampling
#'   unit in *svy*. Default is NULL which indicates that primary sampling unit
#'   in *x* is the same as primary sampling unit in *svy*.
#' @param pop A single character value corresponding to the variable name for
#'   the population figures in *x*. Default is *"pop"*.
#'
#' @return A data.frame drawn from *svy* that contains the primary sampling
#'   units selected by the acceptance and rejection sampling.
#'
#' @examples
#'
#' @export
#'
#
################################################################################

accept_reject_psu <- function(x, svy, psu = "psu", match = NULL, pop = "pop") {
  ## Make a list (vector) of PSU names in survey dataset
  psu.in.svy <- sort(unique(svy[[psu[2]]]))

  ## Creat a PDF function for the population data
  df <- stats::approxfun(stats::density(x[[pop]]))

  ## Plot density for population data ... so we can see what is going on
  plot(stats::density(x[[pop]]))
  ## Note density (p) at BOTH == 750 from df(750)

  ## Acceptance / rejection sampling

  # Lower and upper bounds for acceptance rejection sampling
  LL <- 0
  UL <- max(x[[pop]])
  M <- max(stats::density(x[[pop]])$y)
  # Plot limits
  graphics::abline(v = LL, col = "red", lty = 2)
  graphics::abline(v = UL, col = "red", lty = 2)
  graphics::abline(h = M,  col = "red", lty = 2)

  ## Accumulator for accepted PSUs
  accepted.psus <- NULL

  ## Cycle through the PSUs in the survey data
  for(i in psu.in.svy)
  {
    # Test value
    if (is.null(match)) {
      xstar <- x[x[[psu[1]]] == i, "pop"]
      #xstar <- subset(x, PSU.SMART == i)[[pop]]
    } else {
      xstar <- x[x[[match]] == i, "pop"]
    }
    # Evaluate test value
    ystar <- df(xstar)
    R <- ystar / M
    U <- stats::runif(1, 0, 1)
    ## Shall we keep it or reject it
    if(U < R)
    {
      cat("PSU == ", i, " \tACCEPTED\n")
      graphics::points(xstar, df(xstar), col = "green")
      accepted.psus <- c(accepted.psus, i)
    } else {
      cat("PSU == ", i, "\tREJECTED\n")
      graphics::points(xstar, df(xstar), col = "red")
    }
    ## Short delay (remove later)
    Sys.sleep(1)
  }

  # Have any been rejected?
  if(length(accepted.psus) < length(psu.in.svy))
  {
    ## Let's have the same number of PSUs as the original survey
    additional.psus.for.simulated.svy <- sample(
      accepted.psus,
      size = length(psu.in.svy) - length(accepted.psus),
      replace = FALSE
    )
  }

  ## Make the simulated survey
  simulated.svy <- NULL
  for(i in accepted.psus)
  {
    simulated.svy <- rbind(simulated.svy, svy[svy[[psu[2]]] == i, ])
  }
  for(i in additional.psus.for.simulated.svy)
  {
    additional.data <- svy[svy[[psu[2]]] == i, ]
    ## New PSU numbers for the additional clusters needed
    additional.data$psu <- additional.data$psu + 1000
    simulated.svy <- rbind(simulated.svy, additional.data)
  }

  simulated.svy
}
