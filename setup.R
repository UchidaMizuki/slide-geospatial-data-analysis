library(targets)
library(tarchetypes)

tar_source()

lapply(packages, library, character.only = TRUE)
