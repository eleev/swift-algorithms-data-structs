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

let string = "😄😂🤦‍♂️🤖🤯💩"
let pattern = "😂"

let index = string.indexOf(pattern)
print("Found index for \(pattern): " , index)


