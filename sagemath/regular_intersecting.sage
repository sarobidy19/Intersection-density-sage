#!/usr/local/bin/sage

import sys

n = int(sys.argv[1])

G = SymmetricGroup(n)

def is_derangement(x):  # for 2 intersecting
    return len(Permutation(x).fixed_points()) == 0

def derangements(G):
    CC = G.conjugacy_classes_representatives()
    D = []
    for x in CC:
        if is_derangement(x) == True:
            D.append(x)
    S = []
    for x in D:
        S += G.conjugacy_class(x)
    return S

def degree(i,F):
    j = 0
    for s in F:
        if s(i) != i:
            j += 1
        else:
            pass
    return j

def degreeF(G,F):
    m = G.degree()
    return [degree(i,F) for i in range(1,m+1)]

def normalize(F):
    return [F[0].inverse()*g for g in F]

D = derangements(G)
X = Graph(G.cayley_graph(generators = D))
Y = X.complement()
Z = Y.cliques_maximal()
for F in Z:
    v = degreeF(G,F)
    if sum(v) == v[0]*n and sum(v) == v[1]*n and sum(v) == v[2]*n and sum(v) == v[3]*n:
      print F,v, len(F)


# For n=5, there is a regular maximal coclique [(1,4,5,3), (1,5,3,4,2), (1,2,4,5,3), (1,4,2,3), (1,5,2,3), (1,5,2,4,3), (1,4,5,2), (2,3,4,5)] [7, 7, 7, 7, 7]
# [(1,2,3,5,4), (1,2)(3,4,5), (1,4)(2,5,3), (1,4,3,5,2), (1,2,5)(3,4), (1,5,2,3,4), (1,3,4)(2,5), (1,2,4)(3,5)] [8, 8, 8, 8, 8]
