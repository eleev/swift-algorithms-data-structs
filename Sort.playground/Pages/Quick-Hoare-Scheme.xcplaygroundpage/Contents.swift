//: [Previous](@previous)

import Foundation

extension Array where Element: Comparable {
    
    static func quickSort(array: inout [Element], lowest: Int, highest: Int) {
    
        if lowest < highest {
            let pivot = Array.partitionHoare(array: &array, lowest: lowest, highest: highest)
        
            Array.quickSort(array: &array, lowest: lowest, highest: pivot)
            Array.quickSort(array: &array, lowest: pivot + 1, highest: highest)
        } else {
            debugPrint(#function + " lowest param is bigger than highest: ", lowest, highest)
        }
    }
    
    private static func partitionHoare(array: inout [Element], lowest: Int, highest: Int) -> Int {
        let pivot = array[lowest]
        var i = lowest - 1
        var j = highest + 1
        
        while true {
            i += 1
            
            while array[i] < pivot { i += 1 }
            j -= 1
            
            while array[j] > pivot {j -= 1 }
            if i >= j { return j }
            
            array.swapAt(i, j)
        }
    }
    
}

//: Usage


var nums = [1, 5, 6, 3, 2, 7, 8, 5, 8, 4, 2, 9, 0]
Array.quickSort(array: &nums, lowest: 0, highest: nums.count - 1)

print(#function + " sorted array : " , nums)

//: [Next](@next)
