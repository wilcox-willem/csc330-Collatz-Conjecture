using Printf

# Result struct to hold input/output pair
struct Result
    input::UInt64
    output::UInt64
end

# CompareResults checks if a's output is larger or equal and input smaller than b's
# The outputs are flipped to provide descending sort
function compareResults(a::Result, b::Result)::Bool
    return !((a.output > b.output) || ((a.output == b.output) && (a.input < b.input)))
end

# CompareInputs checks if a's input is less than b's
function compareInputs(a::Result, b::Result)::Bool
    return a.input < b.input
end

# GetMinResult returns the minimum output value in topResults
function getMinResult(topResults::Vector{Result})::UInt64
    currentMin = topResults[1].output
    for i in 2:length(topResults)
        currentMin = min(currentMin, topResults[i].output)
    end
    return currentMin
end

# SortTopTen sorts the topResults based on sortType
# sortType true: highest output and smallest input -> lowest output
# sortType false: highest input -> smallest input
function sortTopTen(topResults::Vector{Result}, sortType::Bool)
    for j in 1:length(topResults)-1
        for i in j+1:length(topResults)
            swapItems = sortType ? compareResults(topResults[j], topResults[i]) : compareInputs(topResults[j], topResults[i])
            
            if swapItems
                topResults[j], topResults[i] = topResults[i], topResults[j]
            end
        end
    end
end

# UpdateTopResults uses x, y to create new Result (input x, output y),
# then checks if new Result's output already exists or is larger than
# current topResults. If the new Result meets the requirements, or
# topResults has less than 10, the new Result is added, then topResults is sorted
function updateTopResults(topResults::Vector{Result}, x::UInt64, y::UInt64)::Vector{Result}
    newResult = Result(x, y)
    newResultFits = false
    outputExistsAlready = false
    
    for i in 1:length(topResults)
        if topResults[i].output < newResult.output
            newResultFits = true
        end
        if (topResults[i].output == newResult.output) && (topResults[i].input < newResult.input)
            outputExistsAlready = true
        end
    end

    # Add the new item into topResults
    if (newResultFits || length(topResults) < 10) && !outputExistsAlready
        push!(topResults, newResult)
        sortTopTen(topResults, true)
    end

    # Keep only the top 10 results
    if length(topResults) > 10
        topResults = topResults[1:10]
    end

    return topResults
end

# PrintResults prints topResults based on seq length and input size
function printResults(topResults::Vector{Result})
    # Print top 10 based on result length
    println("Sorted based on sequence length")
    for i in 1:length(topResults)
        @printf "%20i%20i\n" topResults[i].input topResults[i].output
    end

    # Print top 10 based on input length
    sortTopTen(topResults, false)
    println("Sorted based on integer length")
    for i in 1:length(topResults)
        @printf "%20i%20i\n" topResults[i].input topResults[i].output
    end
end

# CollatzNumofSequences calculates the number of sequences it takes
# before the input = 1. Then returns the num of sequences
function collatzNumofSequences(input::UInt64, currStep::UInt64)::UInt64
    baseCase::UInt64 = 1
    if input <= baseCase
        return currStep
    end

    if input % 2 == 1
        return collatzNumofSequences((input * 3 + 1), (currStep + 1))
    else
        evenResult::UInt64 = (input / 2)
        return collatzNumofSequences(evenResult, (currStep + 1))
    end
end

# CollatzNumofSequencesPrintTopTen repeats CollatzNumofSequences for each number in the given range
# It stores the top ten results, then prints them at the end
function collatzNumofSequencesPrintTopTen(lowerLimit::UInt64, upperLimit::UInt64)
    topTen = Result[]
    currMin::UInt64 = 0
    
    while (upperLimit >= lowerLimit)
        result = collatzNumofSequences(lowerLimit, UInt64(0))
        
        if result > currMin || length(topTen) < 10
            topTen = updateTopResults(topTen, lowerLimit, result)
            currMin = getMinResult(topTen)
        end

        lowerLimit = lowerLimit + 1
    end
    
    printResults(topTen)
end

# Main function
function main()
    lowerLimit, upperLimit, inputLimit = 0, 0, 2100000001 # 2.1 billion
        # Check args for limits
        if length(ARGS) > 0
            lowerLimit = parse(UInt64, ARGS[1])
        end
        if length(ARGS) > 1
            upperLimit = parse(UInt64, ARGS[2])
        end
    
        # Check if bounds set properly
        if lowerLimit > inputLimit || upperLimit > inputLimit
            println("Input is too large, please use a num 0 - 2.1 billion")
            return
        end
    
        if lowerLimit > 0 && upperLimit == 0
            result = collatzNumofSequences(lowerLimit, (lowerLimit - lowerLimit)) 
            @printf "%20i%20i\n" lowerLimit result
        elseif lowerLimit > 0 && upperLimit > 0 && upperLimit > lowerLimit
            collatzNumofSequencesPrintTopTen(lowerLimit, upperLimit)
        end

        return
    end
    
    # Run the main function if the script is executed
    main()
