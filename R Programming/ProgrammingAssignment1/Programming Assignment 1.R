pollutantmean <- function(directory = "", pollutant, id = 1:332) {
  pollutantVector = c()
  for(i in id) {
    filename <- sprintf("%03d", i)
    currentFile <- read.csv(paste0(directory, "/", filename, ".csv"))
    pollutantVector <- c(pollutantVector, currentFile[[pollutant]])
  }
  
  print(pollutantVector)
  
  return(mean(pollutantVector, na.rm = T))
}

complete <- function(directory = "", id = 1:332) {
  df <- data.frame()
  for(i in id) {
    filename <- sprintf("%03d", i)
    currentFile <- read.csv(paste0(directory, "/", filename, ".csv"))
    fileSummary <- data.frame(id = i, nobs = sum(complete.cases(currentFile)))
    df <- rbind(df, fileSummary)
  }
  return(df)
}

corr <- function(directory, threshold = 0) {
  corrVec <- c()
  for(i in 1:332) {
    filename <- sprintf("%03d", i)
    currentFile <- read.csv(paste0(directory, "/", filename, ".csv"))
    completeCases <- sum(complete.cases(currentFile))
    if(completeCases > threshold) {
      currentFileSubset <- currentFile[complete.cases(currentFile),]
      corrVec <- c(corrVec, cor(currentFileSubset$sulfate, currentFileSubset$nitrate))
    }
  }
  return(corrVec)
}
