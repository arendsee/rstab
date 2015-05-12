# rstab

A wrapper for Rscript allowing easy, commandline, manipulation of tabular data.
Files are read in as data.tables.

# Arguments

 * `-v, --version`

 Echo the version

 * `-h, --help`

 Echo the help message

 * `-f, --files`

 A list of `N` tabular data files

 * `-s, --sep`

 A vector of length 1 or `N` specifying the delimiters of each file. If this
 option is not given, the delimiters for all files default to whitespace. If
 one argument is given, all files share this same delimiter. If N arguments are
 given, each file may have its own delimiter.

 * `-d, --header`

 A logical vector specifying whether each file has a header. By default all
 files are assumed to have no headers. If only one argument is provided, the
 one argument sets all headers.

 * `-k, --keys`

 A integer vector specifying the key columns for all files.

 * `e, --expression`

 A list of lines of R code that will be evaluated after all files are loaded.
 If no lines are given, `rstab` will call `tables()` and exit.

# Builtin variables

 Each input file loaded as a data.table and given names F1, F2, ... , FN.

# Example

 * Join three space delimited files (with headers) on one common key (column 1 in all files).

```bash
 rstab -e 'write.table(F1[F2[F3]], quote=FALSE, row.names=FALSE)' \
       -f a.txt b.txt c.txt
```
