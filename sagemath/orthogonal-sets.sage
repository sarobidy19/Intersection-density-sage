#!/usr/local/bin/sage

def ortho_der_graph(q,n):
    V = VectorSpace(GF(q),n)
    X = Graph()
    X.add_vertices([tuple(V[i]) for i in range(1,q^n)])
    for x in X.vertices():
     for y in X.vertices():
         if vector(x).inner_product(vector(y)) != 0 and x != y:
             X.add_edge((x,y))
    return X

def bilinear_ortho_der_graph(B,q,n):
    V = VectorSpace(GF(q),n)
    X = Graph()
    X.add_vertices([tuple(V[i]) for i in range(1,q^n)])
    for x in X.vertices():
     for y in X.vertices():
         if (B*vector(x)).inner_product(vector(y)) != 0 and x != y:
             X.add_edge((x,y))
    return X

def ortho_intersecting_graph(q,n):
    V = VectorSpace(GF(q),n)
    X = Graph(mutliedges = True)
    X.add_vertices([tuple(V[i]) for i in range(1,q^n)])
    for x in X.vertices():
     for y in X.vertices():
         if vector(x).inner_product(vector(y)) == 0 and x != y:
             X.add_edge((x,y))
    return X
