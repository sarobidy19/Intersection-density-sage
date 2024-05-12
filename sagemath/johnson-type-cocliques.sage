#!/usr/local/bin/sage

def prod(u,v):
    n = len(u)
    s = 0
    for i in range(n):
        s += u[i]*v[i]
    return s

def vectors(n):
    V = tuples([0,1,-1],n)
    U = []
    for v in V:
        if prod(v,v) == 3:
            U.append(v)
    return U

def Jonhson_type(n):
    X = Graph()
    V = vectors(n)
    X.add_vertices(V)
    C = Combinations(V,2)
    L = []
    for u in C:
        if prod(u[1],u[0]) == -2:
            L.append(u)
    X.add_edges(L)
    return X

def Jonhson_type_with_param(n,t):
    X = Graph()
    V = vectors(n)
    X.add_vertices(V)
    C = Combinations(V,2)
    L = []
    for u in C:
        if prod(u[1],u[0]) == t:
            L.append(u)
    X.add_edges(L)
    return X

def Jonhson_type_scheme(n,t):
    X = Graph()
    V = vectors(n)
    X.add_vertices(V)
    C = Combinations(V,2)
    L = []
    for u in C:
        #print signature_words(u[1])+signature_words(u[0])
        if prod(u[1],u[0]) == t and signature_words(u[1])+signature_words(u[0]) in  [0]:
            L.append(u)
    X.add_edges(L)
    return X
def AssSchem(n):
    Matrices = []
    for t in [-3,-2,-1,0,1,2,3]:
        if t == 3:
            Matrices.append(matrix.identity(8*binomial(n,3)))
        else:
            X = Jonhson_type_scheme(n,t)
            A = X.adjacency_matrix()
            Matrices.append(Matrix(A))
    return Matrices

def list_ratio_bound(n,L):
    M = max(L)
    m = min(L)
    return n/(1-M/m)

def signature_words(v):
    return sum(v)

def Smaller_Jonhson_type_scheme(n,t):
    X = Graph()
    V = vectors(n)
    X.add_vertices(V)
    C = Combinations(V,2)
    L = []
    for u in C:
        #print signature_words(u[1])+signature_words(u[0])
        if prod(u[0],u[1]) == t and signature_words(u[0]) == 3 and signature_words(u[1]) == -3:
            L.append(u)
        elif prod(u[0],u[1]) == t and signature_words(u[0]) == -3 and signature_words(u[1]) == 1:
            L.append(u)
        elif prod(u[0],u[1]) == t and signature_words(u[0]) == 1 and signature_words(u[1]) == -3:
            L.append(u)
        elif prod(u[0],u[1]) == t and signature_words(u[0]) == 1 and signature_words(u[1]) == 1:
            L.append(u)
        elif prod(u[0],u[1]) == t and signature_words(u[0]) == -1 and signature_words(u[1]) == 3:
            L.append(u)
        elif prod(u[0],u[1]) == t and signature_words(u[0]) == -1 and signature_words(u[1]) == -1:
            L.append(u)
    X.add_edges(L)
    return X

def subgraph_Jonhson_type_scheme(n,t):
    X = Graph()
    V = vectors(n)
    X.add_vertices(V)
    C = Combinations(V,2)
    L = []
    for u in C:
        #print signature_words(u[1])+signature_words(u[0])
        if signature_words(u[0]) != 3 and signature_words(u[1]) != 3:
            if prod(u[0],u[1]) == t:
                L.append(u)
    X.add_edges(L)
    return X
