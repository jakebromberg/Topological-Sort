protocol Node: class, Hashable {
    associatedtype Value
    
    var value: Value { get }
    var edges: [Self] { get set }
}

infix operator  >>>

extension Node {
    static func >>>(lhs: Self, rhs: Self) {
        lhs.edges.append(rhs)
    }
}

extension Node where Value: Hashable {
    var hashValue: Int {
        return value.hashValue
    }
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.value == rhs.value
    }
}

final class Vertex<T: Hashable>: Node {
    let value: T
    var edges: [Vertex] = [Vertex]()
    
    init(_ value: T) {
        self.value = value
    }
}

var a = Vertex("A")
var b = Vertex("B")
var c = Vertex("C")
var d = Vertex("D")
var e = Vertex("E")
var f = Vertex("F")
var g = Vertex("G")
var h = Vertex("H")

a >>> c
b >>> c
b >>> d
c >>> e
d >>> f
e >>> f
e >>> h
f >>> g

fileprivate extension Node {
    func visit(visited: inout Set<Self>, stack: inout [Self]) {
        if !visited.contains(self) {
            visited.insert(self)
            
            for edge in self.edges {
                edge.visit(visited: &visited, stack: &stack)
            }
            
            stack.append(self)
        }
    }
}

extension Collection where Element: Node {
    func topologicalSort() -> [Element] {
        var stack: [Element] = []
        var visited = Set<Element>()
        
        for vertex in self {
            vertex.visit(visited: &visited, stack: &stack)
        }
        
        return stack.reversed()
    }
}

let edges = [a, b, c, d, e, f]
let expectedTopologicalSort = [b, d, a, c, e, h, f, g]

print(edges.topologicalSort() == expectedTopologicalSort)
