## Pair of functions for solving and caching the inverse of a matrix
## makeCacheMatrix is a maker function that returns a 'special matrix' with set/get methods
## The cacheSolve function requires a return value from the makeCacheMatrix function
## The cacheSolve function then either solves the inverse or retrieves cached results for the provided matrix

set.seed(1)
myMatrix <- replicate(3, rnorm(3))
solve(myMatrix)

## Maker function to create a special "matrix" object that can cache its inverse
makeCacheMatrix <- function(x = matrix()) {
  m <- NULL
  set <- function(y) {
    x <<- y
    m <<- NULL
  }
  get <- function() x
  setinverse <- function(solve) m <<- solve
  getinverse <- function() m
  list(set = set, get = get,
       setinverse = setinverse,
       getinverse = getinverse)
}

## Argument 'x' must be a list created by makeCacheMatric function.
## cacheSolve takes a matrix and computes the inverse
## If the inverse has already been calculated, then function returns the inverse from cache.
cacheSolve <- function(x, ...) {
  m <- x$getinverse()
  if(!is.null(m)) {
    message("getting cached data")
    return(m)
  }
  data <- x$get()
  m <- solve(data, ...)
  x$setinverse(m)
  m
}

# Pass a matrix to the makeCacheMatrix function to create a cacheable matrix
cacheableMatrix <- makeCacheMatrix(myMatrix)

# Pass the cacheable matric to cacheSolve.
# Inverse is not yet been solved, so is calculated and cached 
cacheSolve(cacheableMatrix)

# When called a second time, the cached result is returned instead of re-calculating
cacheSolve(cacheableMatrix)
