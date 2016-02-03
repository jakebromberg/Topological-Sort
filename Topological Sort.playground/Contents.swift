class Vertex<T : Hashable> {
	let value : T
	var edges : [Vertex] = [Vertex]()
	
	init(value: T) {
		self.value = value
	}
}

infix operator → { }
func →<T>(lhs: Vertex<T>, rhs: Vertex<T>) -> Vertex<T> {
	lhs.edges.append(rhs)
	return lhs
}

var a = Vertex(value: "A")
var b = Vertex(value: "B")
var c = Vertex(value: "C")
var d = Vertex(value: "D")
var e = Vertex(value: "E")
var f = Vertex(value: "F")
var g = Vertex(value: "G")
var h = Vertex(value: "H")

a→c
b→c
b→d
c→e
d→f
e→f
e→h
f→g

extension Vertex : Hashable {
	var hashValue : Int {
		return value.hashValue
	}
}

func ==<T>(lhs: Vertex<T>, rhs: Vertex<T>) -> Bool {
	return lhs.value == rhs.value
}

struct Graph<T : Hashable> {
	let vertices : [Vertex<T>]

	func topologicalSort() -> [Vertex<T>] {
		func visit(vertex: Vertex<T>, inout visited: Set<Vertex<T>>, inout stack: [Vertex<T>]) {
			if visited.contains(vertex) {
				return
			} else {
				visited.insert(vertex)
				
				for edge in vertex.edges {
					visit(edge, visited: &visited, stack: &stack)
				}
				
				stack.append(vertex)
			}
		}
		
		var stack = [Vertex<T>]()
		var visited = Set<Vertex<T>>()
		
		for vertex in vertices {
			visit(vertex, visited: &visited, stack: &stack)
		}
		
		return stack.reverse()
	}
}

let edges = [a, b, c, d, e, f]
let expectedTopologicalSort = [b, d, a, c, e, h, f ,g]
let graph = Graph(vertices: edges)

print(graph.topologicalSort() == expectedTopologicalSort)
