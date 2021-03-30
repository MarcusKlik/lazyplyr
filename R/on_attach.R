# lazyplyr - a most lazy dplyr implementation for remote data frames
#
#  Copyright (C) 2021-present, Mark AJ Klik
#
#  This file is part of the lazyplyr R package.
#
#  This Source Code Form is subject to the terms of the Mozilla Public
#  License, v. 2.0. If a copy of the MPL was not distributed with this file,
#  You can obtain one at https://mozilla.org/MPL/2.0/.
#
#  https://www.mozilla.org/en-US/MPL/2.0/FAQ/
#
#  You can contact the author at:
#  - lazyplyr R package source repository : https://github.com/fstpackage/lazyplyr


.onAttach <- function(libname, pkgname) {  # nolint

  # executed when attached to search() path such as by library() or require()
  if (!interactive()) return()

  v <- packageVersion("lazyplyr")
  d <- read.dcf(system.file("DESCRIPTION", package = "lazyplyr"), fields = c("Packaged", "Built"))

  if (is.na(d[1])) {
    if (is.na(d[2])) {
      return() # neither field exists
    } else {
      d <- unlist(strsplit(d[2], split = "; "))[3]
    }
  } else {
    d <- d[1]
  }

  # version number odd => dev
  dev <- as.integer(v[1, 3]) %% 2 == 1

  packageStartupMessage("lazyplyr package v", v, if (dev) paste0(" IN DEVELOPMENT built ", d))

  # check for old version
  if (dev && (Sys.Date() - as.Date(d)) > 28)
    packageStartupMessage("\n!!! This development version of the package is rather old, please update !!!")
}
