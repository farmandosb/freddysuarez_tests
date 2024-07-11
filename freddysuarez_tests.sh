#!/bin/bash
#! Freddy Suarez test script
defaultContainerName="public.ecr.aws/l4q9w4c5/loanpro-calculator-cli"

# Check if the Docker container name argument is provided; otherwise, use the default
containerName="${1:-$defaultContainerName}"

# Check if the Docker container name argument is provided
if [ -z "$1" ]; then
    echo "Warning: Docker container name argument missing."
    echo "Usage: $0 <docker_container_name>"
    echo "Using default container: $defaultContainerName"
fi

# Define the test cases as separate arrays with comma-separated values
testCases=(
    "5,3,add,8"                                       # Basic addition
    "5,3,subtract,2"                                  # Basic subtraction
    "5,3,multiply,15"                                 # Basic multiplication
    "6,3,divide,2"                                    # Basic division
    "100,a,divide,Invalid argument. Must be a numeric value."  # Non-numeric second argument
    "100,0,divide,Error: Cannot divide by zero"        # Division by zero
    "9999999999,9999999999,add,19999999998"           # Addition with large numbers
    "-9999999999,-9999999999,add,-19999999998"        # Addition with large negative numbers
    "9999999999,9999999999,subtract,0"                # Subtraction with equal large numbers
    "9999999999,9999999999,multiply,99999999980000000001"  # Multiplication with large numbers
    "9999999999,9999999999,divide,1"                  # Division with large numbers
    "99999999999999999999999,1,add,100000000000000000000000"  # Addition with very large numbers
    "-99999999999999999999999,-1,add,-100000000000000000000000"  # Addition with very large negative numbers
    "999999999999999999999999,999999999999999999999999,subtract,0"  # Subtraction with equal very large numbers
    "99999999999999999999,99999999999999999999,multiply,9999999999999999999800000000000000000001"  # Multiplication with very large numbers
    "99999999999999999999,99999999999999999999,divide,1"  # Division with very large numbers
    "1,0,divide,Error: Cannot divide by zero"          # Division by zero edge case
    "10000000000,10000000000,multiply,100000000000000000000" # Multiplication with extremely large numbers (over 20 digits)
	"10,3,modulo,Error: Unknown operation: modulo" # Modulo operation (assuming not supported)
	"1.5,2.5,add,4" # Floating-point numbers
	"1,2,unknown,Error: Unknown operation: unknown" # Unknown operation
	",2,add,Supported operations: add, subtract, multiply, divide" # Missing first argument
	"1,,add,Supported operations: add, subtract, multiply, divide" # Missing second argument
	",,add,Supported operations: add, subtract, multiply, divide" # Missing both arguments
	"1.0000001,1.0000001,add,2.0000002"         # Addition with precision to 8 decimal places
    "1.00000001,1.00000001,add,2.0"             # Addition with precision to 8 decimal places, rounded
    "0.00000001,0.00000001,add,0.00000002"      # Addition of very small numbers
    "1000000000.12345678,1000000000.12345678,subtract,0"  # Subtraction with precision to 8 decimal places
    "99999999.99999999,0.00000001,add,100000000"  # Addition with large and small numbers, rounded
    "123.12345678,123.12345678,multiply,15159.38560946"  # Multiplication with precision to 8 decimal places
    "12345678.12345678,0.00000001,multiply,0.12345678"  # Multiplication with very small numbers
    "10000000,3,divide,3333333.33333333"         # Division with precision to 8 decimal places
    "1,3,divide,0.33333333"                      # Division with non-integer result, precision to 8 decimal places
    "0.9999999999,0.1,divide,10"  # Division with large and small numbers, rounded
	"0,0.0,add,0"  # Zero addition,
	"0,0.0,subtract,0"  # Zero subtract,
	"0,9999,multiply,0"  # Zero multiply
)

# Calculate total number of test cases
totalCases=${#testCases[@]}
echo "Total number of test cases: $totalCases"

executedTests=0
passedTests=0
failedTests=0


# Iterate over each test case
for id in "${!testCases[@]}"; do
    # Accessing test case details
    IFS=',' read -r arg1 arg2 operation expectedResult <<< "${testCases[$id]}"

    # Print test case details
    echo "Test Case ID: $id"

    # Build the Docker command
    dockerCommand="docker run --rm"

    # Complete the Docker command with container name and arguments
    dockerCommand="$dockerCommand $containerName $operation $arg1 $arg2"

    # Print the Docker command being executed
    echo -e "Executing Docker command:\n$dockerCommand"

    # Execute the Docker command and capture the output
    actualResult=$(eval "$dockerCommand")
	
    # Print the actual and expected results
    echo "Actual Result:"
    echo "$actualResult"
	echo "Expected Result:"
    echo "$expectedResult"

    # Check if the actual result contains the expected result
    if [[ "$actualResult" == *"$expectedResult"* ]]; then
        echo "Test Result: PASSED"
		 ((passedTests++))
    else
        echo "Test Result: FAILED"
		  ((failedTests++))
    fi
	# Increment executed tests counter
	((executedTests++))
    # Print a blank line for readability between test cases
    echo
done
echo "Total Executed Tests: $executedTests"
echo "Total Passed Tests: $passedTests"
echo "Total Failed Tests: $failedTests"
