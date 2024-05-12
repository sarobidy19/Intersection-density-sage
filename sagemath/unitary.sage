#!/usr/local/bin/sage

def unitary_cayley_graph(n):
    C = CyclicPermutationGroup(n)
    U = []
    for x in C:
        if x.order() == n:
            U.append(x)
    return Graph(C.cayley_graph(generators = U))

def product(x,y,G,H):
    return ((x[0] == y[0]) and (x[1],y[1],None) in H.edges()) or ((y[1] == x[1]) and (x[0],y[0],None) in G.edges()) or ((x[0],y[0],None) in G.edges() and (x[1],y[1],None) not in H.edges()) or ((x[0],y[0],None) not in G.edges() and (x[1],y[1],None) in H.edges())

def hom_prod(G,H):
    V = cartesian_product([G.vertices(),H.vertices()])
    K = Graph()
    K.add_vertices(V)
    for x in V:
        for y in V:

def characteristic_vector(G,S):
    u = [0]*len(G)
    for i in range(len(G)):
        if G[i] in S:
            u[i] = 1
    return Matrix([u]).transpose()

def unitary_cayley_graph(n):
    C = [1..n]
    U = []
    X = Graph()
    for x in C:
        for y in C:
            if x != y and gcd(n,x-y) == 1:
                U.append((x,y))
    X.add_edges(U)
    return X
