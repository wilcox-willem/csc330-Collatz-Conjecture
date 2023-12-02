use std::cmp::{Ord, Ordering, PartialOrd};

// Struct to hold input/output pair
#[derive(Debug, Clone, Copy, Eq, PartialEq)]
struct Result {
    input: u64,
    output: u64,
}

impl Result {
    fn new(x: u64, y: u64) -> Result {
        Result { input: x, output: y }
    }
}

// Implement comparison for Result
impl Ord for Result {
    fn cmp(&self, other: &Self) -> Ordering {
        match self.output.cmp(&other.output) {
            Ordering::Equal => self.input.cmp(&other.input),
            other => other,
        }
    }
}

impl PartialOrd for Result {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

// Function to sort top ten results
fn sort_top_ten(top_results: &mut Vec<Result>, sort_type: bool) {
    top_results.sort_by(|a, b| {
        if sort_type {
            a.cmp(b)
        } else {
            a.input.cmp(&b.input)
        }
    });
    top_results.reverse();
}

// Function to update top results
fn update_top_results(top_results: &mut Vec<Result>, x: u64, y: u64, cycles: u64) -> u64 {
    let new_result = Result::new(x, y);
    let mut new_result_fits = false;
    let mut output_exists_already = false;

    for result in top_results.iter() {
        if result.output < new_result.output {
            new_result_fits = true;
        }
        if result.output == new_result.output && result.input < new_result.input {
            output_exists_already = true;
        }
    }

    // Add the new item into top_results
    if (new_result_fits || cycles < 10) && !output_exists_already {
        top_results.push(new_result);
        sort_top_ten(top_results, true);
    }

    // Keep only the top 10 results
    if top_results.len() > 10 {
        top_results.truncate(10);
    }

    // Return current min
    top_results.iter().map(|result| result.output).min().unwrap_or(0)
}

// Function to print results
fn print_results(top_results: &mut Vec<Result>) {
    // Print top 10 based on result length
    println!("Sorted based on sequence length");
    for result in top_results.iter() {
        println!("{:>20}{:>20}", result.input, result.output);
    }

    // Print top 10 based on input length
    sort_top_ten(top_results, false);
    println!("Sorted based on integer length");
    for result in top_results.iter() {
        println!("{:>20}{:>20}", result.input, result.output);
    }
}

// Function to calculate the number of sequences
fn collatz_num_of_sequences(input: u64, step: u64) -> u64 {
    if input < 2 {
        step
    } else if input % 2 == 0 {
        collatz_num_of_sequences(input / 2, step + 1)
    } else {
        collatz_num_of_sequences(input * 3 + 1, step + 1)
    }
}

// Function to repeat collatz_num_of_sequences for given range
fn collatz_num_of_sequences_print_top_ten(lower_limit: u64, upper_limit: u64) {
    let mut top_ten = Vec::new();
    let mut curr_min = 0;
    let mut cycles = 0;

    for i in lower_limit..=upper_limit {
        let result = collatz_num_of_sequences(i, 0);
        if result > curr_min || cycles < 10 {
            curr_min = update_top_results(&mut top_ten, i, result, cycles);
        }
        cycles += 1;
    }

    print_results(&mut top_ten);
}

// Main function
fn main() {
    let mut lower_limit = 0;
    let mut upper_limit = 0;
    let input_limit = 2100000001; // 2.1 billion + 1

    // Check for args for limits
    let args: Vec<String> = std::env::args().collect();
    if args.len() == 2 {
        lower_limit = args[1].parse().unwrap();
    } else if args.len() == 3 {
        lower_limit = args[1].parse().unwrap();
        upper_limit = args[2].parse().unwrap();
    }

    // Check if bounds set properly
    if lower_limit > input_limit || upper_limit > input_limit {
        println!("Input is too large, please use a num 0 - 2.1 billion");
        return;

    }

    if lower_limit > 0 && upper_limit == 0 {
        let result = collatz_num_of_sequences(lower_limit, 0);
        println!("{:>20}{:>20}", lower_limit, result);
    } else if lower_limit > 0 && upper_limit > 0 && upper_limit > lower_limit {
        collatz_num_of_sequences_print_top_ten(lower_limit, upper_limit);
    }
}
