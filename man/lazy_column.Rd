% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/lazy_column.R
\name{lazy_column}
\alias{lazy_column}
\title{Define a lazy column}
\usage{
lazy_column(lazy_col_impl)
}
\arguments{
\item{lazy_col_impl}{custom metadata needed to define the column data}
}
\value{
a lazy column
}
\description{
A 'lazy table' consists of one or more lazy columns. Each of these columns is a wrapper around a lazy column
implementation class `lazy_col_impl` that can be used to access column data. The implementation class does not
need to store column data in memory, but can use offline data storage instead (such as a file or database).
}
