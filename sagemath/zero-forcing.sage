#!/usr/local/bin/sage

def check_zero_forcing(G,S):
    L = []
    a = 'impossible'
    for x in S:
        X = G.neighbors(x)
        M = G.neighbors(x)
        #print X,'ito'
        for y in X:
            if y in S:
                M.remove(y)
            #print X
        L.append(len(M))
    #print L
    for x in L:
        if x == 1:
            a = 'possible'
    return a

def color_in_black(G,S):
    T,M = [],[]
    #print S
    for x in S:
        #print "x=",x
        X = G.neighbors(x)
        #print X,"ITOOOOOO"
        M = G.neighbors(x)
        #print "M",M,S
        for i in range(len(X)):
            y = X[i]
            #print y,"values"
            if y in S:
                M.remove(y)
                #print y,"removed"
        if len(M) == 1:
            T.append(M[0])
    return S+T


def forcing(G,S):
    a = check_zero_forcing(G,S)
    while a == 'possible':
        S = color_in_black(G,S)
        #print S
        a = check_zero_forcing(G,S)
    if len(set(S)) == G.order():
        return True
    else:
        return False

def unitary_cayley_graph(n):
    C = [0..n-1]
    U = []
    for x in C:
        for y in C:
            if x != y and gcd(n,y-x) == 1:
                U.append((x,y))
    X = Graph()
    X.add_edges(U)
    return X
