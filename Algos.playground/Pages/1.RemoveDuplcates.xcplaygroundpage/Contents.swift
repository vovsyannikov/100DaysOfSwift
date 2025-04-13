import UIKit

func removeDuplicates(from array: inout [Int]) -> Int {
	var previousValue: Int?
//	array = array.compactMap { nextValue in
//		defer { previousValue = nextValue }
//
//		if previousValue == nextValue {
//			return nil
//		}
//
//		return nextValue
//	}

	var currentIndex = 0

	while currentIndex < array.count {
		let value = array[currentIndex]

		if value == previousValue {
			array.remove(at: currentIndex)
		} else {
			currentIndex += 1
			previousValue = value
		}
	}

	return array.count
}

var example1 = [0, 0, 1, 1, 1, 4, 5, 6, 6]
var example2 = [Int]()
var example3 = [1]

print("Example 1: \(removeDuplicates(from: &example1)) -> \(example1)")
print("Example 2: \(removeDuplicates(from: &example2)) -> \(example2)")
print("Example 3: \(removeDuplicates(from: &example3)) -> \(example3)")

