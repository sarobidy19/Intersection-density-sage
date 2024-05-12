#!/usr/local/bin/sage


def twist():
    G = graphs.CompleteGraph(4)
    K = Graph()
    K.add_vertices(['a','b','c','d','e'])
    return G.cartesian_product(K)

G =  twist()
print G.vertices()
L = ['a','b','c','d','e']
for i in range(len(L)):
    for j in range(len(L)):
        if j!= i+1:
            G.add_edges([((0,L[i]),(3,L[j])),((3,L[i]),(0,L[j])),((1,L[i]),(2,L[j])),((2,L[i]),(1,L[j]))])
        else:
            G.add_edges([((0,L[i]),(0,L[j])),((3,L[i]),(3,L[j])),((1,L[i]),(1,L[j])),((2,L[i]),(2,L[j]))])
