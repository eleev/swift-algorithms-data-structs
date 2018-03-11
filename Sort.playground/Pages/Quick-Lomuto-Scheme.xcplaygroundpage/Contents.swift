//: [Previous](@previous)

import Foundation

extension Array where Element: Comparable {
    
    static func quickSort(array: inout [Element], lowest: Int, highest: Int)  {
        if lowest < highest {
            let pivot = Array.partitionLomuto(array: &array, lowest: lowest, highest: highest)
            
            Array.quickSort(array: &array, lowest: lowest, highest: pivot - 1)
            Array.quickSort(array: &array, lowest: pivot + 1, highest: highest)
        } else {
            debugPrint(#function + " lowest param is bigger than highest: ", lowest, highest)
        }
    }

    private static func partitionLomuto(array: inout [Element], lowest: Int, highest: Int) -> Int {
        let pivot = array[highest]
        var i = lowest
        
        for j in lowest..<highest {
            if array[j] <= pivot {
                array.swapAt(i, j)
                i += 1
            }
        }
        
        array.swapAt(i, highest)
        return i
    }
    
}


// Usage:

var nums = [1, 5, 6, 3, 2, 7, 8, 5, 8, 4, 2, 9, 0]
Array.quickSort(array: &nums, lowest: 0, highest: nums.count - 1)

print(#function + " sorted array : " , nums)


//: [Next](@next)
