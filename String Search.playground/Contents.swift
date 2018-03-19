//: Playground - noun: a place where people can play

import Foundation

/*:
 Brute-Force string search implementation as String extension:
 */

extension String {
    
    func indexOf(_ string: String) -> String.Index? {
        for i in self.indices {
            var j = i
            var found = true
            
            for k in string.indices {
                if j == self.endIndex || self[j] != string[k] {
                    found = false
                    break
                } else {
                    j = self.index(after: j)
                }
            }
            if found {
                return i
            }
        }
        return nil
    }
    
}

//: Usage

let string = "😄😂💩🤦‍♂️🤖🤯💩"
let pattern = "💩"

let index = string.indexOf(pattern)
print("Found index for \(pattern): " , index as Any)



/*:
 Brute-Force string search implementation as String extension (using range(of:) method) which is much faster than the previous implementation:
 */

extension String {
    
    func indicesOf(_ string: String) -> [Int]? {
        
        var indices = [Int]()
        var position = self.startIndex
        
        while let range = range(of: string, options: String.CompareOptions.caseInsensitive, range: position ..< self.endIndex, locale: nil) {
            indices.append(distance(from: self.startIndex, to: range.lowerBound))
            position = index(after: range.lowerBound)
        }
        
        return indices
    }
}

//: Usage:

let indices = string.indicesOf(pattern)
print("Found index for \(pattern): " , indices as Any)


