import Foundation

func isSingleLetterDifference(in string1: String, and string2: String) -> Bool {
	var diff = abs(string1.count - string2.count)

	if diff > 1 { return false }

	var stringIterator = min(string1, string2).indices.makeIterator()

	while let nextIndex = stringIterator.next() {
		if string1[nextIndex] != string2[nextIndex] {
			diff += 1
		}

		if diff > 1 { return false }
	}

	return true
}

let example1a = "hello"
let example1b = "helio"
let example1 = (example1a, example1b)

let example2a = "hey"
let example2b = "heyy"
let example2 = (example2a, example2b)

let example3a = "abcd"
let example3b = "efgh"
let example3 = (example3a, example3b)

let example4a = "hey"
let example4b = "hiii"
let example4 = (example4a, example4b)

let example5a = "ё"
let example5b = "е"
let example5 = (example5a, example5b)

let example6a = "I"
let example6b = ""
let example6 = (example6a, example6b)

let example7a = ""
let example7b = ""
let example7 = (example7a, example7b)

for examples in [example1, example2, example3, example4, example5, example6, example7] {
	let result = isSingleLetterDifference(in: examples.0, and: examples.1)
	print("\(examples.0) and \(examples.1) has a single letter difference: \(result)")
	print("------------------")
}
