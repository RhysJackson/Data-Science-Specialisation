library(dplyr)
library(lazyeval)

# Define function to capitalise first letter of each word in string
proper <- function(x) gsub("(?<=\\b)([a-z])", "\\U\\1", tolower(x), perl=TRUE)


# Function to identify the hospital with lowest mortality rate for any given state and outcome
best <- function(state, outcome) {
  ## Read outcome data
  outcomeData <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
  
  # Format outcome variable
  outcome <- gsub(" ", ".", proper(outcome))
  outcome <- paste0("Hospital.30.Day.Death..Mortality..Rates.from.", outcome)
  
  ## Check that state and outcome are valid
  if(!state %in% outcomeData$State) {
    stop("invalid state")
  }
  
  if(!outcome %in% names(outcomeData)) {
    stop("invalid outcome")
  }
  
  # Coerce outcome column to numeric
  outcomeData[[outcome]] <- as.numeric(outcomeData[[outcome]])
  # Filter to include only hospitals of specified state
  outcomeData <- outcomeData[which(outcomeData$State == state), ]
  # Order data frame by mortality and then by alphabetical order
  outcomeData <- outcomeData[order(outcomeData[[outcome]], outcomeData$Hospital.Name), ]
  # Remove NAs
  completeCases <- complete.cases(outcomeData[, outcome])
  outcomeData <- outcomeData[completeCases, ]
  ## Return hospital name in that state with lowest 30-day death rate
  return(outcomeData)
}

# Expect error: Invalid state
best("BB", "heart attack")

# Expect error: Invalid outcome
best("NY", "hert attack")

# Expect "CYPRESS FAIRBANKS MEDICAL CENTER"
best("TX", "heart attack")

# Expect "FORT DUNCAN MEDICAL CENTER"
best("TX", "heart failure")



rankhospital <- function(state, outcome, num = "best") {
  rankings <- best(state, outcome)
  if(num == "best") {
    return(head(rankings$Hospital.Name, n = 1))
  } else if(num == "worst") {
    return(tail(rankings$Hospital.Name, n = 1))
  } else {
    return(rankings$Hospital.Name[num])
  }
}
  
# Expect "DETAR HOSPITAL NAVARRO"
rankhospital("TX", "heart failure", 4)

# Expect "HARFORD MEMORIAL HOSPITAL"
rankhospital("MD", "heart attack", "worst")

# Expect NA
rankhospital("MN", "heart attack", 5000)




rankall <- function(outcome, num = "best") {
  ## Read outcome data
  outcomeData <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
  
  # Format outcome variable
  outcome <- gsub(" ", ".", proper(outcome))
  outcome <- paste0("Hospital.30.Day.Death..Mortality..Rates.from.", outcome)
  
  # Performn input validation
  if(!outcome %in% names(outcomeData)) {
    stop("invalid outcome")
  }
  
  if(num != "best" & num != "worst") {
    if(!is.numeric(num)) {
      stop("invalid number")
    }
  }
  
  # Coerce outcome column to numeric
  outcomeData[[outcome]] <- as.numeric(outcomeData[[outcome]])
  # Remove NAs
  completeCases <- complete.cases(outcomeData[, outcome])
  outcomeData <- outcomeData[completeCases, ]
  
  # Group, summarise, arrange and output data
  if(num == "best") {
    outcomeData <- outcomeData %>%
      group_by(State, Hospital.Name) %>%
      summarise_(val = interp(~min(outcome), outcome=as.name(outcome))) %>%
      arrange(State, val, Hospital.Name) %>%
      summarise(first(Hospital.Name))
  } else if (num == "worst") {
    outcomeData <- outcomeData %>%
      group_by(State, Hospital.Name) %>%
      summarise_(val = interp(~min(outcome), outcome=as.name(outcome))) %>%
      arrange(State, val, Hospital.Name) %>%
      summarise(last(Hospital.Name))
  } else {
    outcomeData <- outcomeData %>%
      group_by(State, Hospital.Name) %>%
      summarise_(val = interp(~min(outcome), outcome=as.name(outcome))) %>%
      arrange(State, val, Hospital.Name) %>%
      summarise(nth(Hospital.Name, num))
  }
  
  return(outcomeData)
}

head(rankall("heart attack", 20), 10)

tail(rankall("pneumonia", "worst"), 3)
