//: Playground - noun: a place where people can play

import Foundation

extension Array where Element: Comparable {
    
    func binarySearch(key: Element) -> Int? {
        var lowerBound = 0
        var upperBound = self.count - 1
        
        while lowerBound <= upperBound {
            let midIndex = lowerBound + (upperBound - lowerBound) / 2
      
            if self[midIndex] > key {
                upperBound = midIndex - 1
            } else if self[midIndex] < key {
                lowerBound = midIndex + 1
            } else {
                return midIndex
            }
        }
        
        return nil
    }
    
}

//: Usage

// NOTES: 
// The following comparison will not work because two Strings cannot be compared with > or < operators - in order to determine lexical order they need to be lexically comapred. You can use the following construction to achieve such result:
// strings.first?.compare(strings.last) == ComparisonResult.orderedAscending

// Another solution is to implement custom coparison closure and inject it to the binarySearch function (this is TODO thing)
// And the last approach is to override exisiting comparison operator for String type so two strings will be lexically compared with each other

let strings = ["steve", "Apple", "bar", "foo", "juce", "iPad", "macOS", "book", "universal"]
var index = strings.binarySearch(key: "universal")

let numbers = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67]
index = numbers.binarySearch(key: 67)
