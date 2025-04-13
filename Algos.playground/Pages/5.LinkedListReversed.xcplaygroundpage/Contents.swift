import Foundation

final class ListNode {
	let value: Int
	var nextNode: ListNode?

	init(value: Int, nextNode: ListNode? = nil) {
		self.value = value
		self.nextNode = nextNode
	}
}

let thirdValue = ListNode(value: 3)
let secondValue = ListNode(value: 2, nextNode: thirdValue)
let head = ListNode(value: 1, nextNode: secondValue)

// 1 -> 2 -> 3
func reverseList(from head: ListNode?) -> ListNode? {
	var prev: ListNode?
	var current = head
	var next: ListNode?

	while current != nil {
		next = current?.nextNode
		current?.nextNode = prev
		prev = current
		current = next
	}

	return prev
}

func printLinkedList(from head: ListNode?) {
	if head == nil { return }

	print("Node: \(head!.value)")
	printLinkedList(from: head?.nextNode)
}

//printLinkedList(from: head)
printLinkedList(from: reverseList(from: head))

