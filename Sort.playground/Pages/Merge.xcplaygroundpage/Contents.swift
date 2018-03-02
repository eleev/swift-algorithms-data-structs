//: [Previous](@previous)

//: Merge sort is a sorting algorithm that has lower order running time than the insertion sort algorithm. Conceptually it is a devide and conquer sorting algorithm.

//: The algorithm works by using recursion - it will divide an unsorted list into two parts - this is Divide part.

//: The next phaze is Conquer - it recursively sorts sublists and if they are small enough then solve their base case.

//: Base case is a situation when a list has a single item or it is empty.

//: The final phase is Conbine - it merges the sorted sublists into a sorted sequence and return the elements back.

extension Array where Element: Comparable {

    public func mergeSort(_ list: [Element]) -> [Element] {

        if list.count < 2 { return list }
        let center = (list.count) / 2
        
        let leftMergeSort = mergeSort([Element](list[0..<center]))
        let rightMergeSort = mergeSort([Element](list[center..<list.count]))
        
        return merge(left: leftMergeSort, right: rightMergeSort)
    }

    private func merge(left lhalf: [Element], right rhalf: [Element]) -> [Element] {
        
        var leftIndex = 0
        var rightIndex = 0
        let totalCapacity = lhalf.count + rhalf.count
        
        var temp = [Element]()
        temp.reserveCapacity(totalCapacity)
        
        while leftIndex < lhalf.count && rightIndex < rhalf.count {
            let leftElement = lhalf[leftIndex]
            let rightElement = rhalf[rightIndex]
            
            if leftElement < rightElement {
                temp.append(leftElement)
                leftIndex += 1
            } else if leftElement > rightElement {
                temp.append(rightElement)
                rightIndex += 1
            } else {
                temp.append(leftElement)
                temp.append(rightElement)
                leftIndex += 1
                rightIndex += 1
            }
        }
        
        temp += [Element](lhalf[leftIndex..<lhalf.count])
        temp += [Element](rhalf[rightIndex..<rhalf.count])
        
        return temp
    }
    
}


//: [Next](@next)
