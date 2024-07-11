
# Findings
## Requirements
1. Windows SO
2. Docker Desktop installed
3. Any CLI, e.g. Git Bash

## Execute automated tests
 1. Open a git bash CLI
 2. Pull the image:
	 ```console
	docker pull public.ecr.aws/l4q9w4c5/loanpro-calculator-cli:latest
	```
 3. Go to the path where the test script is located
Then run the following command to execute all the test cases
	```console
	./freddysuarez_tests.sh <containerName>
	```
*Note*
If not *containerName* is provided, the following value will be used as default:
*public.ecr.aws/l4q9w4c5/loanpro-calculator-cli*

## Failed Tests
**Test Case ID: 9**
Executing Docker command:
docker run --rm public.ecr.aws/l4q9w4c5/loanpro-calculator-cli multiply 9999999999 9999999999
Actual Result:
Result: 99999999980000000000
Expected Result:
99999999980000000001
Test Result: FAILED
Possible reason: Data Structure overflow

**Test Case ID: 11**
Executing Docker command:
docker run public.ecr.aws/l4q9w4c5/loanpro-calculator-cli add 99999999999999999999999 1
Actual Result:
Result: 99999999999999990000000
Expected Result:
10000000000000000000000
Possible reason: Data Structure overflow


**Test Case ID: 12**
Executing Docker command:
docker run public.ecr.aws/l4q9w4c5/loanpro-calculator-cli add -99999999999999999999999 -1
Actual Result:
Result: -99999999999999990000000
Expected Result:
-100000000000000000000000
Test Result: FAILED
Possible reason: Data Structure overflow

**Test Case ID: 14**
Executing Docker command:
docker run public.ecr.aws/l4q9w4c5/loanpro-calculator-cli multiply 99999999999999999999 99999999999999999999
Actual Result:
Result: 10000000000000000000000000000000000000000
Expected Result:
9999999999999999999800000000000000000001
Test Result: FAILED
Possible reason: Data Structure overflow