//: [Previous](@previous)

import Foundation

/// Notes:
/// - Edge object is always directed - a one-way connection. In order to have two way connection, you need to add additional weight property and some indication that Edge represents a two-way connection.
/// - If you want to have undirected connection - you also need to add an Edge object in the opposite direction.
/// - Weight property can be ommited so in such case it will represent unweighted graph.
/// - The arbitraty stored data is a generic type T which is Hashable to enforce uniqueness and also Equatable, so they can be equated.
/// - One good approach is to have protocol that describes various types of Edges, so vertices can be connected by different types of Endges - protocol-oriented appraoch may be a good way to go.

struct Edge<T: Equatable & Hashable> {
    let from: Vertex<T>
    let to: Vertex<T>
    let weight: Double?
}

// MARK: - Adds conformance to Hashable protocol
extension Edge: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(from.hashValue)
        hasher.combine(to.hashValue)
        hasher.combine(weight.hashValue)
    }
}

extension Edge: CustomStringConvertible, CustomDebugStringConvertible {
 
    var description: String {
        return commonDescription
    }
    
    var debugDescription: String {
        return commonDescription
    }
    
    private var commonDescription: String {
        var weightDescription = ""

        if let weight = self.weight {
            weightDescription = "\(weight)"
        } else {
            weightDescription = "nil"
        }
        
        return "from: \(from), \t to: \(to), \t weight: \(weightDescription)"
    }
}

struct Vertex<T: Equatable & Hashable> {
    var data: T
    let index: Int
}

// MARK: - Adds conformance to Hashable protocol
extension Vertex: Hashable {
    var hashValue: Int {
        return data.hashValue ^ index.hashValue
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(data.hashValue)
        hasher.combine(index.hashValue)
    }
}

extension Vertex: CustomStringConvertible, CustomDebugStringConvertible {
    
    var description: String {
        return commonDescription
    }
    
    var debugDescription: String {
        return commonDescription
    }
    
    private var commonDescription: String {
        return "data: \(data), index: \(index)"
    }
}

// MARK: - Custom Operators

func == <T: Equatable> (lhs: Vertex<T>, rhs: Vertex<T>) -> Bool {
    return lhs.data == rhs.data
}

func == <T: Equatable> (lhs: Edge<T>, rhs: Edge<T>) -> Bool {
    return lhs.from == rhs.from && lhs.to == rhs.to
}

// MARK: - AdjacencyList struct

struct AdjacencyList<T: Equatable & Hashable> {
    
    // MARK: - Properties
    
    let vertex: Vertex<T>
    var edges: [Edge<T>] = []
    
    // MARK: - Initializers
    
    init(vertex: Vertex<T>) {
        self.vertex = vertex
    }
    
    // MARK: - Methods
    
    mutating func add(edge: Edge<T>) {
        if !edges.isEmpty {
            let equalEdges = edges.filter { $0 == edge }
            
            if !equalEdges.isEmpty {
                return
            }
        }
        edges.append(edge)
    }
}

extension AdjacencyList: CustomStringConvertible, CustomDebugStringConvertible {
    
    var description: String {
        return commonDecription
    }
    
    var debugDescription: String {
        return commonDecription
    }
    
    private var commonDecription: String {
        return """
        \n
        vertex: \(vertex),
        edges: \(edges)
        """
    }
    
}

struct AdjacencyListGraph<T: Equatable & Hashable> {
    
    // MARK: - Properties
    
    var adjacencyLists: [AdjacencyList<T>] = []
    
    var vertices: [Vertex<T>] {
        var vertices = [Vertex<T>]()
        
        adjacencyLists.forEach { list in
            vertices += [list.vertex]
        }
        return vertices
    }
    
    var edges: [Edge<T>] {
        var edges = Set<Edge<T>>()
        
        adjacencyLists.forEach { list in
            list.edges.forEach { edge in
                edges.insert(edge)
            }
        }
        return Array(edges)
    }
    
    // MARK: - Initializers
    
    init() {
        // Default initializer
        // It is overrides so we don't get the initializer that is automatically synthesyzed for us by the compiler
    }
    
    // MARK: - Methods
    
    mutating func addVertex(basedOn data: T) -> Vertex<T> {
        for list in adjacencyLists where list.vertex.data
            == data {
                return list.vertex
        }
        
        let vertex = Vertex(data: data, index: adjacencyLists.count)
        let adjacencyList = AdjacencyList(vertex: vertex)
        adjacencyLists += [adjacencyList]
        return vertex
    }
    
    mutating func addEdge(from: Vertex<T>, to: Vertex<T>, weight: Double? = nil) -> Edge<T> {
        let edge = Edge(from: from, to: to, weight: weight)
        let list = adjacencyLists[from.index]
        
        if !list.edges.isEmpty {
            for listEdge in list.edges where listEdge == edge {
                return listEdge
            }
            adjacencyLists[from.index].edges += [edge]
        } else {
            adjacencyLists[from.index].edges = [edge]
        }
        return edge
    }
    
    func searchVertex(with data: T) -> [Vertex<T>] {
        return vertices.filter { $0.data == data }
    }
    
    func searchEdges(with weight: Double) -> [Edge<T>] {
        return edges.filter { $0.weight ?? 0 == weight }
    }
    
    func search(edge: Edge<T>) -> [Edge<T>] {
        return edges.filter { $0 == edge }
    }
    
    
}


//: Usage:

var adjacencyListGraph = AdjacencyListGraph<String>()
let vertexNewYork = adjacencyListGraph.addVertex(basedOn: "New York")
let vertexSanFrancisco = adjacencyListGraph.addVertex(basedOn: "San Francisco")
let vertexMoscow = adjacencyListGraph.addVertex(basedOn: "Moscow")
let vertexTokyo = adjacencyListGraph.addVertex(basedOn: "Tokyo")
let vertexSidney = adjacencyListGraph.addVertex(basedOn: "Sidney")

let edgeNYSF = adjacencyListGraph.addEdge(from: vertexNewYork, to: vertexSanFrancisco)
let edgeSFMSC = adjacencyListGraph.addEdge(from: vertexSanFrancisco, to: vertexMoscow)
let edgeMSCTKY = adjacencyListGraph.addEdge(from: vertexMoscow, to: vertexTokyo)
let edgeTKYSDY = adjacencyListGraph.addEdge(from: vertexTokyo, to: vertexSidney)
let edgeSDYMSC = adjacencyListGraph.addEdge(from: vertexSidney, to: vertexMoscow)


print(adjacencyListGraph)


let results = adjacencyListGraph.searchVertex(with: "Moscow")

print("\nSearch Results: ")
print(results)

// Pleas note that the implementation is not complete. MST, Prim's and Dijkstra's algorithms will be added later.

//: [Next](@next)
