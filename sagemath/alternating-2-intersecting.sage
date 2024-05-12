#!/usr/local/bin/sage

#This works because the sets given in Combinations are sorted.  The action of a permutation is also sorted. 

def label_pairs(n):
    N = Combinations([1..n],2)
    L = [tuple(x) for x in N]
    D = dict()
    i = 1
    for x in L:
        D[tuple(x)] = i
        i += 1
    return D,L

def action_of_element_as_permutation(f,T):
    x = (f(T[0]),f(T[1]))
    return tuple(sorted(x))

def AlternatingGroup_acting_on_pairs(n):
    PermGens = []
    G = AlternatingGroup(n)
    S = G.gens()
    K = label_pairs(G.degree())
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
