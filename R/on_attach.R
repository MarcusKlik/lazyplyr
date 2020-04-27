#  lazyplyr - a most lazy dplyr implementation for remote datasets
#
# Copyright (c) 2020 M.A.J. Klik
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
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
