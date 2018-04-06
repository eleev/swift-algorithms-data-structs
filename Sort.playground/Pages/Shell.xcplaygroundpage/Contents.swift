//: [Previous](@previous)

import Foundation

// Shell sort is an improved version of insertion sort. The original list is broken into smaller sublists and then individually sorted using insertion sort.

extension Array where Element: Comparable {
    
    public mutating func shellSorted(order sign: (Element, Element) -> Bool) {
        var subcount = self.count / 2
        
        while subcount > 0 {
            for i in 0..<self.count {
                let temp = self[i]
                var j = i
                
                while j >= subcount && sign(self[j - subcount], temp) {
                    self[j] = self[j - subcount]
                    j -= subcount
                }
                self[j] = temp
            }
            subcount /= 2
        }
        
    }
}

//: Usage

var data = [4, 1, 5, 6, 1, 2, 9, 8, 5, 4, 2, 7, 6]
data.shellSorted(order: >)

//: [Next](@next)
