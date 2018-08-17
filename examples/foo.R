
 data(state)

 nrow <- 5

 foo <- list()

 for (i in 1:3)
    foo[[i]] <- data.frame(letters = sample(LETTERS, nrow),
        colors = sample(colors(), nrow), state = sample(state.name, nrow))

 foo

 bar <- Reduce(rbind, foo)

 bar
