import Foundation

final class ListNode {
	var value: Int
	var nextNode: ListNode?

	init(value: Int, nextNode: ListNode? = nil) {
		self.value = value
		self.nextNode = nextNode
	}
}

func join(linkedList1: ListNode?, with linkedList2: ListNode?) -> ListNode? {
	var newList: ListNode?
	var lastNode: ListNode?
	var list1 = linkedList1
	var list2 = linkedList2

	while list1 != nil || list2 != nil {
		let minValue =
		if let list1Value = list1?.value, let list2Value = list2?.value {
			min(list1Value, list2Value)
		} else if let list1Value = list1?.value {
			list1Value
		} else if let list2Value = list2?.value {
			list2Value
		} else {
			fatalError("No value found")
		}

		let newNode = ListNode(value: minValue)

		if newList == nil {
			newList = newNode
		} else {
			lastNode?.nextNode = newNode
		}

		lastNode = newNode

		if minValue == list1?.value {
			list1 = list1?.nextNode
		} else {
			list2 = list2?.nextNode
		}
	}

	return newList
}

let value9 = ListNode(value: 9)
let value7 = ListNode(value: 7, nextNode: value9)
let value5 = ListNode(value: 5, nextNode: value7)
let value3 = ListNode(value: 3, nextNode: value5)
let head1 = ListNode(value: 1, nextNode: value3)

let value6 = ListNode(value: 6)
let value4 = ListNode(value: 4, nextNode: value6)
let head2 = ListNode(value: 2, nextNode: value4)

func printList(_ node: ListNode?) {
	guard let node else { return }

	print("Node: \(node.value)")
	printList(node.nextNode)
}


//printList(head1)
//printList(head2)
printList(join(linkedList1: head1, with: head2))
