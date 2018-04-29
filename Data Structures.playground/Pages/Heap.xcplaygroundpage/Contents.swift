//: [Previous](@previous)

import Foundation

//: Usage

var maxHeap = Heap<Int>(order: >)
maxHeap.insert(node: 1)
maxHeap.insert(node: 5)
maxHeap.insert(node: 2)
maxHeap.insert(node: 7)
maxHeap.insert(node: 9)

debugPrint(maxHeap)

var heap: Heap = [3, 1, 4, 2, 7, 9, 8]
debugPrint(heap)

heap.index(of: 3)

let sortedHeap = heap.sorted()
debugPrint(sortedHeap)


//: [Next](@next)
