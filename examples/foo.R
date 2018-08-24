
 # This was in response to a question someone asked in class
 # I have added a bunch more stuff (comments and reading files off disk)
 # to make a more self contained example

 set.seed(42)

 mycolors <- unique(grep("[[:digit:]]", colors(), invert = TRUE, value = TRUE))

 data(state)

 foo <- list()

 for (i in 1:3) {
    nrow <- sample(4:8, 1)
    foo[[i]] <- data.frame(letters = sample(LETTERS, nrow),
        colors = sample(mycolors, nrow), state = sample(state.name, nrow))
 }

 foo

 # So suppose somehow you have gotten a bunch of data frames and put them
 # in a list, then the following makes a list of data frames into one data
 # frame.

 bar <- Reduce(rbind, foo)

 bar

 # for more realism write these files out

 files <- paste("file", seq(along = foo), ".csv", sep = "")
 files
 for (i in seq(along = foo))
     write.csv(foo[[i]], file = files[i])

 rm(list = ls())
 ls()

 # Now we start from only having the files on disk.

 files <- list.files(pattern = "\\.csv$")
 files

 foo <- list()
 for (file in files)
     foo[[file]] <- read.csv(file)
 foo
 
 # So again, this works.

 bar <- Reduce(rbind, foo)

 bar

