#  lazyplyr - a most lazy dplyr implementation for remote datasets
#
#  Copyright (C) 2019-present, Mark AJ Klik
#
#  This file is part of the lazyplyr R package.
#
#  The lazyplyr R package is free software: you can redistribute it and/or modify it
#  under the terms of the GNU Affero General Public License version 3 as
#  published by the Free Software Foundation.
#
#  The lazyplyr R package is distributed in the hope that it will be useful, but
#  WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
#  FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License
#  for more details.
#
#  You should have received a copy of the GNU Affero General Public License along
#  with the lazyplyr R package. If not, see <http://www.gnu.org/licenses/>.
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
