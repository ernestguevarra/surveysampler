################################################################################
#
#'
#' Select sampling units from a set of potential sampling units using propensity
#' score matching (PSM)
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
#' @param sampling_type Which sampling type to use. Choice between *simple
#'   random sample (simple)* or *systematic sample (systematic)*. Default is
#'   *simple*.
#'
#' @return A data.frame drawn from *svy* that contains the primary sampling
#'   units selected by propensity score matching.
#'
#' @author Mark Myatt and Ernest Guevarra
#'
#' @examples
#' create_sample_psm(
#'   x = village_list,
#'   svy = sample_data,
#'   psu = c("id", "psu"),
#'   match = "cluster",
#'   pop = "population"
#' )
#'
#' @export
#'
#
################################################################################

create_sample_psm <- function(x, svy,
                              psu = "psu",
                              match = NULL,
                              pop = "pop",
                              sampling_type = c("simple", "systematic")) {
  ## Re-create psu parameter
  if (length(psu) == 1) {
    psu <- c(psu, psu)
  }

  ## Process full list of sampling units
  if (!is.null(match)) {
    sample_x <- x[ , c(psu[1], match, pop)]
    names(sample_x) <- c("id", "psu", "pop")
  } else {
    sample_x <- data.frame(
      id = x[[psu[1]]],
      psu = x[[psu[1]]],
      pop = x[[pop]]
    )
  }

  ## Process survey data
  sample_y <- merge(svy, sample_x, by.x = psu[2], by.y = "psu", all.x = TRUE)
  names(sample_y)[1] <- "psu"
  sample_y <- stats::aggregate(pop ~ psu, data = sample_y, FUN = unique)
  sample_y <- data.frame(
    id = sample_x$id[sample_x$psu %in% sample_y$psu], sample_y
  )

  ## Get sampling type
  samp <- match.arg(sampling_type)

  ## Determine number of clusters to select
  n_clusters <- nrow(sample_y)

  if (samp == "systematic") {
    ## Process cluster list dataset to produce a systematic sample of n_clusters
    ## clusters.
    #sampling_interval <- floor(nrow(x) / n_clusters)
    #random_start <- sample(1:sampling_interval, size = 1)
    #selected_row_numbers <- seq(from = random_start,
    #                            to = nrow(x),
    #                            by = sampling_interval)
    #sample_x <- sample_x[selected_row_numbers, ]
    sample_x <- get_sample_systematic(x = sample_x, n_sample = n_clusters)
  } else {
    ## Process cluster list dataset to produce a systematic sample of n_clusters
    ## clusters.
    selected_row_numbers <- sample(seq_len(nrow(sample_x)), size = n_clusters)
    sample_x <- sample_x[selected_row_numbers, ]
  }

  ## Match using PSM -----------------------------------------------------------

  # Assign TRUE or FALSE to group variable for each of the processed dataset to
  # signify SMART dataset (TRUE) and systematic sample of clusters dataset
  # (FALSE)
  sample_x$group <- FALSE
  sample_y$group <- TRUE

  # Combine rows of sample list and rows of actual data list
  xy <- rbind(sample_y, sample_x)
  row.names(xy) <- seq_len(nrow(xy))

  # Perform propensity score matching based on population using nearest
  # neighbour algorithm
  matched_sample <- MatchIt::matchit(group ~ pop, data = xy,
                                     method = "nearest", ratio = 1)

  # Get matched data
  z <- MatchIt::match.data(matched_sample)

  # Subset to the SMART dataset and the full list sample
  z1 <- z[z$group, ]
  z2 <- z[!z$group, ]

  # Merge two datasets to get rows of matched psus (merging by subclass)
  z_wide <- merge(z1, z2, by = "subclass")

  # Extract matched psus with available data
  selected_psus <- with(z_wide,
    ifelse(is.na(psu.y), psu.x, psu.y)
  )

  # Get simulated survey dataset using selected psus
  simulated_svy <- svy[svy[[psu[2]]] %in% selected_psus, ]

  ## Return simulated_svy
  simulated_svy
}

