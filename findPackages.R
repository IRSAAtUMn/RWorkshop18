
 chapters <- list.files(pattern = "^0[[:digit:]]-[[:alpha:]]+\\.Rmd")
 chapters <- sort(chapters)
 chapters

 libraries <- NULL
 for (chapter in chapters) {
     foo <- scan(chapter, what = character(0), sep = "\n")
     bar <- grep("library(", foo, fixed = TRUE, value = TRUE)
     libraries <- c(libraries, bar)
 }
 libraries

 libraries <- sub("^.*library\\(([^)]+)\\).*$", "\\1", libraries)
 libraries <- sort(unique(libraries))
 write(libraries, file = stdout())

