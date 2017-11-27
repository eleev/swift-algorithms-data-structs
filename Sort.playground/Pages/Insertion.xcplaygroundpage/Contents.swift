//: Playground - noun: a place where people can play

import UIKit
import Foundation

// MARK: - Implementation

extension Array where Element: Comparable {
    
    public mutating func insertionSort(order: (Element, Element)->Bool) -> Array {
        if self.count <= 1 {
            return self
        }
        for i in 1..<self.count {
            let temp = self[i]
            var j = i
            
            while j > 0 && order(self[j - 1], temp) {
                self[j] = self[j - 1]
                j -= 1
            }
            self[j] = temp
        }
        
        return self
    }
    
}

// MARK: - Usage

var intData = [1,3,4,-10,34,234]
intData.insertionSort(order: <)

var stringData = ["go","ado","hello","we","can do"]
stringData.insertionSort(order: >)
