#!/usr/local/bin/sage

import random

def orbitals(G):
    S = [1..G.degree()]
    r = gap.RankAction(G)
    L = Tuples(S,2)
    M = []
    n = len(M)
    while n != r:
        a = random.choice(list(L))
        test_new_orbital = True
        for x in M:
            if tuple(a) in x:
                test_new_orbital = False
                break
            else:
                pass
        if test_new_orbital == True:
            P = G.orbit(tuple(a),"OnTuples")
            M.append(list(P))
            n = len(M)
        #print n,r
    return M

def association_scheme(G):
    M = orbitals(G)
    AS = []
    for x in M:
        A = [[0]*G.degree() for i in range(G.degree())]
        for y in x:
            A[y[0]-1][y[1]-1] = 1
        AS.append(Matrix(A))
    return rearrange(AS)

def rearrange(M):
    T = []
    for x in M:
        if len(set(x.eigenvalues())) == 1:
            T.append(x)
            j = M.index(x)
    for i in range(len(M)):
        if i != j:
            T.append(M[i])
    return T

def conjugacy_class_scheme(G):
    T = []
    CC = G.conjugacy_classes()
    for x in CC:
        A = [[0]*G.order() for i in range(G.order())]
        for i in range(G.order()):
            for j in range(G.order()):
                if G[j]*G[i].inverse() in x:
                    A[i][j] = 1
        T.append(Matrix(A))
    return rearrange(T)
