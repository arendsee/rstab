#!/usr/bin/env Rscript

require(data.table, quiet=TRUE)
require(plyr, quiet=TRUE)

version <- '0.1.0'

suppressPackageStartupMessages(library("argparse"))
parser <- ArgumentParser(
  formatter_class='argparse.RawTextHelpFormatter',
  description='Parse files as data tables. Files are assigned to the data.tables F1, F2, ... , FN.',
  usage='rstab [options] -f <files> -e <code>')

parser$add_argument(
  '-v', '--version',
  action='store_true',
  default=FALSE)

parser$add_argument(
  '-f', '--files',
  metavar="x",
  help='tabular files to be parsed',
  nargs="+")

parser$add_argument(
  '-s', '--sep',
  metavar="x",
  help='column separator (white space default)',
  nargs="+")

parser$add_argument(
  '-k', '--keys',
  metavar="x",
  help='Key columns for input files',
  nargs="+")

parser$add_argument(
  '-d', '--headers',
  metavar="x",
  help='specify whether there are headers for each file (F or T)',
  nargs="+")

parser$add_argument(
  '-e', '--expression',
  metavar='CODE',
  help='R code')

args <- parser$parse_args()
N <- length(args$files)

if(args$version){
  cat(sprintf('rstab v%s\n', version))
  q()
}


# If no keys are given, default to first column
if(is.null(args$keys)){
  args$keys <- rep(1, N)
}
args$keys <- as.numeric(args$keys)
# If keys are given, and there is not exactly one for each file, die
stopifnot(length(args$keys) == N)


# If no delimiters are given, default to whitespace
# Else if one delimiter is given, apply to all files
if(is.null(args$sep)){
  args$sep <- rep("", N)
} else if (length(args$sep) == 1) {
  args$sep <- rep(args$sep, N)
}


# If no header flags are given, default to false
# Else if one header flag is given, apply to all
# Else translate 'T' and 'F' to TRUE and FALSE
if(is.null(args$headers)){
  args$headers = rep(FALSE, N)
} else if(length(args$headers) == 1){
  stopifnot(args$headers[1] %in% c('T', 'F'))
  args$headers = rep(args$headers[1] == 'T', N) 
} else {
  stopifnot(length(args$headers) == N)
  args$headers <- as.logical(args$headers)
}



# If delimiters are given, and there is not exactly one for each file, die
stopifnot(length(args$sep) == N)

for (i in 1:N){
  load.template <- 'F%d <- read.table("%s", header=%s, sep="%s")'
  load.cmd <- sprintf(load.template, i, args$files[i], args$headers[i], args$sep[i])
  eval(parse(text=load.cmd))
  dt.template <- 'F%d <- data.table(F%d, key=colnames(F%d)[%d])'
  dt.cmd <- sprintf(dt.template, i, i, i, args$keys[i])
  eval(parse(text=dt.cmd))
}

if(is.null(args$expression)){
  tables()
} else {
  eval(parse(text=args$expression))
}
