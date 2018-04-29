//: [Previous](@previous)

import Foundation

// MARK: - Radix sort relies on the positional notation of integers and sorts an integer array for linear time.
extension Array where Element == Int {
    
    public mutating func radixSort(of base: Int = 10) {
        var isDone = false
        var digits = 1
        
        while !isDone {
            isDone = true
            var buckets: [[Int]] = .init(repeating: [], count: base)

            forEach { number in
                let remainig = number / digits
                let digit = remainig % base
                buckets[digit].append(number)
                
                if remainig > 0 {
                    isDone = false
                }
            }
            digits *= base
            self = buckets.flatMap { $0 }
        }
    }
}


//: Usage:

var numbers = [88, 410, 1, 1772, 20, 6, 4, 45688]
numbers.radixSort()

//: [Next](@next)
