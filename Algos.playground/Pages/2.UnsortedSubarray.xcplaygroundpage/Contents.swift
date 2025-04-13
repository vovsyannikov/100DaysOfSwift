import Foundation

func findUnsortedSubarrayLength(in array: [Int]) -> Int {
	if array.isEmpty { return 0 }

	var maxValue = array[0]
	var minValue = array[array.count - 1]

	var subarrayStart = 0
	var subarrayEnd = 0

	for (index, value) in array.enumerated() {
		maxValue = max(maxValue, value)

		if value < maxValue {
			subarrayEnd = index
		}
	}

	var index = array.count - 1
	while index >= 0 {
		let value = array[index]
		minValue = min(minValue, value)

		if value > minValue {
			subarrayStart = index
		}
		index -= 1
	}

	return subarrayEnd == subarrayStart ? 0 : subarrayEnd - subarrayStart + 1
}

let example1: [Int] = [1, 4, 2, 3, 2, 6]
let example2: [Int] = [6, 4, 10, 10, 4, 15]
let example3: [Int] = [1, 1]
let example4: [Int] = []
let example5: [Int] = [2, 4, 9, 6, 5, 15, 16, 20]

for example in [example1, example2, example3, example4, example5] {
	print("Unsorted subarray length for \(example) is: \(findUnsortedSubarrayLength(in: example))\n")
}
