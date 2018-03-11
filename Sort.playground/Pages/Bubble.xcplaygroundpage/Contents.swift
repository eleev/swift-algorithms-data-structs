//: [Previous](@previous)

import Foundation

extension Array where Element: Comparable {

    mutating func bubbleSorted() {
        let count = self.count
        
        for index in 0...count {
            for value in 1...count - 2 {
                if self[value - 1] > self[value] {
//                    self.swapAt(value - 1, value)
                    let largerValue = self[value - 1]
                    self[value - 1] = self[value]
                    self[value] = largerValue
                }
            }
        }
    }
    
}

//: Usage

var nums = [1, 5, 6, 3, 2, 7, 8, 5, 8, 4, 2, 9, 0]
nums.bubbleSorted()

debugPrint(#function + " sorted: ", nums)

//: [Next](@next)
