#include <iostream>
#include <cstdlib> // for stoi
#include <cstdint> // for using uint64_t
#include <limits> // for getting max uint64_t val
#include <vector>
#include <algorithm>

using namespace std;

// // struct Result
// struc to hold input/output pair
// as well as manage results
struct Result {
    uint64_t input;
    uint64_t output;
    Result(uint64_t x, uint64_t y) : input(x), output(y) {}
};

// // bool compareResults(Result a, Result b)
// checks (a, b), if a's output is larger, or equal and input smaller
// the outputs are flipped to provide descending sort
bool compareResults(const Result& a, const Result& b) {
  if (a.output > b.output) {
    return !true;
  } else if (a.output == b.output && a.input < b.input) {
    return !true;
  }

  return !false;
}

// // bool compareInputs(Result a, Result b)
// checks if a's input is less than b's
bool compareInputs(const Result& a, const Result& b) {
  return (a.input < b.input);
}

void sortTopTen(vector<Result>& topResults, bool sortType) {
  for (int j = 0; j < topResults.size() - 1; j++) {
    for (int i = j + 1; i < topResults.size(); i++) {
      bool swapItems = false;

      // determine if swap is needed based on sortType
      // sortType T :: highest output and smallest input -> lowest output
      // sortType F :: highest input -> smallest input
      if (sortType) { swapItems = compareResults(topResults[j], topResults[i]); } 
      else {swapItems = compareInputs(topResults[j], topResults[i]); }
      
      // swap items if needed
      if (swapItems) {
        Result temp = topResults[j];
        topResults[j] = topResults[i];
        topResults[i] = temp;
      }
    }
  }
}

// // uint updateTopResults (vector Results topResults, uint x, uint y)
// uses x,y to make newResult(input x, output y), then checks if
// newResult's output alreadys exists or is larger than current topResults.
// If the newResult meets the requirements, or topResults has less than 10,
// the new result is added, then topResults is sorted
uint64_t updateTopResults(vector<Result>& topResults, uint64_t x, uint64_t y) {
    Result newResult(x, y);
    bool newResultFits = false;
    bool outputExistsAlready = false;

    for (int i = 0; i < topResults.size(); i++) {
      if (topResults[i].output < newResult.output) {
        newResultFits = true;
      }
      if (topResults[i].output == newResult.output && topResults[i].input < newResult.input) {
        outputExistsAlready = true;
      }
    }

    // add the new item into topResults
    if ((newResultFits || topResults.size() < 10) && !outputExistsAlready) {
      topResults.push_back(newResult);
      sortTopTen(topResults, true);
    }

    // Keep only the top 10 results
    if (topResults.size() > 10) {
        topResults.pop_back(); 
    }

    return topResults.back().output; // return current min
}

// // void printResults (vector Result topResults)
// prints topResults based on seq length and input size
void printResults(vector<Result>& topResults) {
  // print top 10 based on result length
  cout << "Sorted based on sequence length" << endl;
  for (int i = 0; i < topResults.size(); i++) {
    printf("%20d%20d\n", topResults[i].input, topResults[i].output);
  }

  // print top 10 based on input length
  sortTopTen(topResults, false);
  cout << "Sorted based on integer length" << endl;
  for (int i = 0; i < topResults.size(); i++) {
    printf("%20d%20d\n", topResults[i].input, topResults[i].output);
  }
}

// main functions
uint64_t collatzNumofSequences(uint64_t input);
void collatzNumofSequencesPrintTopTen(uint64_t lowerLimit, uint64_t upperLimit);
uint64_t setTopTen(uint64_t topTen[10][2], uint64_t input, uint64_t result);

// // MAIN // //
int main(int argc, char* argv[]) {
    uint64_t lowerLimit = 0;
    uint64_t upperLimit = 0; 
    uint64_t inputLimit = 2100000001; // 2.1 billion + 1
    
    // absoluteLimit is the largest possible uint in cpp
    uint64_t absoluteLimit = numeric_limits<uint64_t>::max(); // 4,294,967,295
    // absoluteOdd is the largest odd number that can be called within the collats func
    uint64_t absoluteOdd = ((absoluteLimit - 1) / 3) - 1; // 1,431,655,763
    
    // check for args for limits
    if (argc == 2) {
        lowerLimit =  stoi(argv[1]);
    } else if (argc == 3) {
        lowerLimit = stoi(argv[1]);
        upperLimit = stoi(argv[2]);
    }
            
    // check if bounds set properly
    if ((lowerLimit > inputLimit) || (upperLimit > inputLimit)) {
      cout << "Input is too large, please use a num 0 - 2.1 billion" << endl;
      return 1;
    }
    
    if ((lowerLimit > 0) && (upperLimit == 0)) {
      uint64_t result = collatzNumofSequences(lowerLimit);
      printf("%20d%20d\n", lowerLimit, result);
    } else if ((lowerLimit > 0) && (upperLimit > 0) && (upperLimit > lowerLimit)) {
      collatzNumofSequencesPrintTopTen(lowerLimit, upperLimit);
    }

    return 0;
}
// // END MAIN // //

// // uint collatzNumofSequences(uint input)
// this function calculates the number of sequences it takes
// before the input = 1. Then returns the num of sequences
uint64_t collatzNumofSequences(uint64_t input) {
  uint64_t numofSeq = 0;
  
  while (input > 1) {
    if (input % 2 == 0) {
      input = input / 2;
    } else if (input % 2 == 1) {
      input = (input * 3) + 1;
    }
    numofSeq++;
  }
  
  return numofSeq;
}


// // void collatzNumofSequencesPrintTopTen(uint lowerLimit, uint upperLimit)
// this functions repeats collatzNumofSequences for each number in the given range
// it stores the top ten results, then prints them at the end
void collatzNumofSequencesPrintTopTen(uint64_t lowerLimit, uint64_t upperLimit) {
  vector<Result> topTen;
  uint64_t currMin = 0; // to skip any values below topTen min

  for (uint64_t i = lowerLimit; i <= upperLimit; i++) {
    uint64_t result = collatzNumofSequences(i);
    if (result > currMin) {
      currMin = updateTopResults(topTen, i, result); 
    }
  }
  
  printResults(topTen);
}
