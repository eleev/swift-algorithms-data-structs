//: [Previous](@previous)

import Foundation

/// Notes:
/// - Edge object is always directed - a one-way connection. In order to have two way connection, you need to add additional weight property and some indication that Edge represents a two-way connection.
/// - If you want to have undirected connection - you also need to add an Edge object in the opposite direction.
/// - Weight property can be ommited so in such case it will represent unweighted graph.
/// - The arbitraty stored data is a generic type T which is Hashable to enforce uniqueness and also Equatable, so they can be equated.
/// - One good approach is to have protocol that describes various types of Edges, so vertices can be connected by different types of Endges - protocol-oriented appraoch may be a good way to go.

struct Edge<T> where T: Equatable & Hashable {
    let from: Vertex<T>
    let to: Vertex<T>
    let weight: Double?
}

struct Vertex<T> where T: Equatable & Hashable {
    var data: T
    let index: Int
}


//: [Next](@next)
