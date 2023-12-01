package main

import (
  "fmt"
  "os"
  "strconv"
)

// Result struct to hold input/output pair
type Result struct {
  Input  uint64
  Output uint64
}

// CompareResults checks if a's output is larger or equal and input smaller than b's
// The outputs are flipped to provide descending sort
func CompareResults(a Result, b Result) bool {
  if a.Output > b.Output {
    return !true
  } else if a.Output == b.Output && a.Input < b.Input {
    return !true
  }
  return !false
}

// CompareInputs checks if a's input is less than b's
func CompareInputs(a Result, b Result) bool {
  return a.Input < b.Input
}

func GetMinResult(topResults []Result) uint64 {
	var currentMin uint64
	currentMin = topResults[0].Output

	for i := 0; i < len(topResults); i++ {
		if (topResults[i].Output < currentMin) {
			currentMin = topResults[i].Output
		}
	}

	return currentMin
}

// SortTopTen sorts the topResults based on sortType
// sortType true: highest output and smallest input -> lowest output
// sortType false: highest input -> smallest input
func SortTopTen(topResults []Result, sortType bool) {
  for j := 0; j < len(topResults)-1; j++ {
    for i := j + 1; i < len(topResults); i++ {
      var swapItems bool

      // Determine if swap is needed based on sortType
      // sortType true: highest output and smallest input -> lowest output
      // sortType false: highest input -> smallest input
      if sortType {
        swapItems = CompareResults(topResults[j], topResults[i])
      } else {
        swapItems = CompareInputs(topResults[j], topResults[i])
      }

      // Swap items if needed
      if swapItems {
        topResults[j], topResults[i] = topResults[i], topResults[j]
      }
    }
  }
}

// UpdateTopResults uses x, y to create new Result (input x, output y),
// then checks if new Result's output already exists or is larger than
// current topResults. If the new Result meets the requirements, or
// topResults has less than 10, the new Result is added, then topResults is sorted
func UpdateTopResults(topResults []Result, x uint64, y uint64) []Result {
  newResult := Result{x, y}
  var newResultFits, outputExistsAlready bool
  

  for i := 0; i < len(topResults); i++ {
    if topResults[i].Output < newResult.Output {
      newResultFits = true
    }
    if ((topResults[i].Output == newResult.Output) && topResults[i].Input < newResult.Input) {
      outputExistsAlready = true
    }
  }

  // Add the new item into topResults
  if (newResultFits || len(topResults) < 10) && !outputExistsAlready {
    newTR := append(topResults, newResult)
	topResults = newTR
    SortTopTen(topResults, true)
  }

  // Keep only the top 10 results
  if len(topResults) > 10 {
    topResults = topResults[:10]
  }

  return topResults
}

// PrintResults prints topResults based on seq length and input size
func PrintResults(topResults []Result) {
  // Print top 10 based on result length
  fmt.Println("Sorted based on sequence length")
  for i := 0; i < len(topResults); i++ {
    fmt.Printf("%20d%20d\n", topResults[i].Input, topResults[i].Output)
  }

  // Print top 10 based on input length
  SortTopTen(topResults, false)
  fmt.Println("Sorted based on integer length")
  for i := 0; i < len(topResults); i++ {
    fmt.Printf("%20d%20d\n", topResults[i].Input, topResults[i].Output)
  }
}

// CollatzNumofSequences calculates the number of sequences it takes
// before the input = 1. Then returns the num of sequences
func CollatzNumofSequences(input uint64, currStep uint64) uint64 {
  if (input == 1) {
	return currStep
  }

  if (input % 2 == 1) {
	return CollatzNumofSequences((input*3 +1), (currStep + 1))
  } else {
	return CollatzNumofSequences((input / 2), (currStep + 1))
  }

}

// CollatzNumofSequencesPrintTopTen repeats CollatzNumofSequences for each number in the given range
// It stores the top ten results, then prints them at the end
func CollatzNumofSequencesPrintTopTen(lowerLimit uint64, upperLimit uint64) {
  var topTen []Result
  var currMin uint64 // to skip any values below topTen min
  numCycles := 0

  for i := lowerLimit; i <= upperLimit; i++ {
    result := CollatzNumofSequences(i, 0)

	if result > currMin ||  numCycles < 10 {
      topTen = UpdateTopResults(topTen, i, result)
	  currMin = GetMinResult(topTen)
    }

	numCycles++
  }

  PrintResults(topTen)
}

// Main function
func main() {
  var lowerLimit, upperLimit, inputLimit uint64 = 0, 0, 2100000001 // 2.1 billion + 1

  // AbsoluteLimit is the largest possible uint in Go
  //var absoluteLimit uint64 = math.MaxUint64 // 18446744073709551615
  // AbsoluteOdd is the largest odd number that can be called within the collatz func
  //var absoluteOdd uint64 = ((absoluteLimit - 1) / 3) - 1 // 1,431,655,763

  // Check args for limits
  if len(os.Args) > 1 {
    lowerLimit, _ = strconv.ParseUint(os.Args[1], 10, 64)
  }
  if len(os.Args) == 3 {
    upperLimit, _ = strconv.ParseUint(os.Args[2], 10, 64)
  }

  // Check if bounds set properly
  if lowerLimit > inputLimit || upperLimit > inputLimit {
    fmt.Println("Input is too large, please use a num 0 - 2.1 billion")
    return
  }

  if lowerLimit > 0 && upperLimit == 0 {
    result := CollatzNumofSequences(lowerLimit, 0)
    fmt.Printf("%20d%20d\n", lowerLimit, result)
  } else if lowerLimit > 0 && upperLimit > 0 && upperLimit > lowerLimit {
    CollatzNumofSequencesPrintTopTen(lowerLimit, upperLimit)
  }
}
