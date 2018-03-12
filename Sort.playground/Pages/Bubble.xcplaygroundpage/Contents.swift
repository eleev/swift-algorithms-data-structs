//: [Previous](@previous)

import Foundation

extension Array where Element: Comparable {

    mutating func bubbleSorted(order sign: (Element, Element) -> Bool) {
        let count = self.count
        
        for _ in 0...count {
            for value in 1...count - 2 {
                if sign(self[value - 1], self[value]) {
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
nums.bubbleSorted(order: >)

debugPrint(#function + " sorted: ", nums)

//: [Next](@next)
