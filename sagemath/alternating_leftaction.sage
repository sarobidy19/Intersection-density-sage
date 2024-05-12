#!/usr/local/bin/sage

def label_pairs(n):
    L = tuples([1..n],2)
    for x in L:
        if x[0] == x[1]:
            L.remove(x)
        else:
            pass
    D = dict()
    i = 1
    for x in L:
        D[x] = i
        i += 1
    return D,L

def action_of_element_as_permutation(f,T):
    return (f.inverse()(T[0]),f.inverse()(T[1]))

def Alt_acting_on_pairs(n):
    PermGens = []
    G = AlternatingGroup(n)
    S = G.minimal_generating_set()
    K = label_pairs(n)
    L = K[1]
    D = K[0]
    for g in S:
        N = [0]*len(L)
        for x in L:
            i = D[x]
            j = D[action_of_element_as_permutation(g,x)]
            N[i-1] = j
        PermGens.append(Permutation(N))
    return PermutationGroup(PermGens)
