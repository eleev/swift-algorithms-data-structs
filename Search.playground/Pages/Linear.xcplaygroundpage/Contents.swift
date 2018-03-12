//: [Previous](@previous)

import Foundation

extension Array where Element: Comparable {
   
    func linearSearch(key: Element) -> Int? {
        for (index, instance) in self.enumerated() where instance == key {
            return index
        }
        return nil
    }

}

//: Usage

let strings = ["Steve", "Apple", "bar", "foo", "juce", "iPad", "macOS", "book", "universal"]
var index = strings.linearSearch(key: "foo")

let numbers = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67]
index = numbers.linearSearch(key: 67)

//: [Next](@next)
