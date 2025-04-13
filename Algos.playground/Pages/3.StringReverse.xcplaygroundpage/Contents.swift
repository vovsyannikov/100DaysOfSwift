import Foundation

func reverse(string: inout [Character]) {
	if string.count < 2 { return }

	var left = string.startIndex
	var right = string.endIndex - 1

	while left < right {
//		string.swapAt(startIndex, endIndex)

//		let temp = string[left]
//		string[left] = string[right]
//		string[right] = temp

		(string[left], string[right]) = (string[right], string[left])

		left += 1
		right -= 1
	}
}

let example1 = "go 15"
let example2 = ""
let example3 = "racecar"
let example4 = " "
let example5 = "goat is mine"

for example in [example1, example2, example3, example4, example5] {
	let strait = example.map(Character.init)
	var result = example.map(Character.init)
	reverse(string: &result)

	print("\(strait) -> \(result)")
	print("(\(example)) -> (\(result.map(String.init).joined()))")
	print("-----------------")
}
