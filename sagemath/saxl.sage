#!/usr/loca/bin

def SaxlGraph(G):
    Omega = G.domain()
    X = Graph()
    X.add_vertices(Omega)
    C = Combinations(Omega,2)
    E = []
    for x in C:
        K = G.stabilizer(x[0]).intersection(G.stabilizer(x[1]))
        if K.order() == 1:
            E.append(x)
    X.add_edges(E)
    return X
