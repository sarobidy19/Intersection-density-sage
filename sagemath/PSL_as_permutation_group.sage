#!/usr/local/bin/sage

def label_pairs(q):
    L = tuples([1..q+1],2)
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

def label_subsets(q):
    L = Combinations([1..q+1],2)
    D = dict()
    i = 1
    for x in L:
        D[tuple(x)] = i
        i += 1
    return D,L

def action_of_element_as_permutation(f,T):
    return (f(T[0]),f(T[1]))

def action_of_element_as_permutation_on_subsets(f,T):
    u = (f(T[0]),f(T[1]))
    return sorted(u)

def PSL_acting_on_pairs(q):
    PermGens = []
    G = PSL(2,q)
    S = G.minimal_generating_set()
    K = label_pairs(q)
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

def PSL_acting_on_subsets(q):
    PermGens = []
    G = PSL(2,q)
    S = G.minimal_generating_set()
    K = label_subsets(q)
    L = K[1]
    D = K[0]
    for g in S:
        N = [0]*binomial(q+1,2)
        for x in L:
            i = D[tuple(x)]
            j = D[tuple(action_of_element_as_permutation_on_subsets(g,x))]
            N[i-1] = j
        PermGens.append(Permutation(N))
    return PermutationGroup(PermGens)

def PGL_acting_on_pairs(q):
    PermGens = []
    G = PGL(2,q)
    S = G.minimal_generating_set()
    K = label_pairs(q)
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

def RatioBoundList(G,L):
     M = gap.Maximum(L)
     m = gap.Minimum(L)
     return (G.order()/(1-M/m))

def AGL_acting_on_pairs(n,q):
    PermGens = []
    G = AGL_to_permutation_group_on_points(n,q)
    S = G.gens()
    K = label_pairs(q^n-1)
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

def Dihedral_acting_on_pairs(n):
    PermGens = []
    G = DihedralGroup(n)
    S = G.gens()
    K = label_pairs(G.degree()-1)
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

def SymmetricGroup_acting_on_pairs(n):
    PermGens = []
    G = SymmetricGroup(n)
    S = G.gens()
    K = label_pairs(G.degree()-1)
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

Groups = [PrimitiveGroup(x[0],x[1]) for x in [(35,1),(35,3),(31*5,1),(23*11,3),(55,1),(55,4),(77,1),(23*11,4),(23*11,5),(19*3,1),(29*7,1),(59*29,1),(61*31,1)]]
