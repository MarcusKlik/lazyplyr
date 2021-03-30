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


#' @importFrom crayon italic
#' @importFrom crayon cyan
#' @import dplyr
#' @importFrom pillar pillar
#' @importFrom rlang as_string call2 is_symbol is_syntactic_literal
#' @importFrom tidyselect eval_select eval_rename
#' @importFrom utils packageVersion
NULL

# use of vaiables inside package
utils::globalVariables(c("index", "args2"))
