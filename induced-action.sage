#!/usr/local/bin/sage

def is_derangement_on_block(g,B):
    L = Permutation(g).fixed_points()
    for x in L:
        if x in set(B):
            return False
        else:
            pass
    return True


def check_graphs(x,y,stabilizer,block):
    S = stabilizer
    B = block
    V1 = [i*x for i in S]
    V2 = [i*y for i in S]
    E = []
    X = Graph()
    X.add_vertices(V1+V2)
    for a in V1:
         for b in V2:
             if is_derangement_on_block(a*b.inverse(),B) == True:
                 #print Permutation(a*b.inverse()).fixed_points(),B
                 E.append((a,b))
    X.add_edges(E)
    return X
    #print X.independent_set(value_only=True)

def graph_two_cosets(g1,g2,G,H):
    V1 = [x*g1 for x in H]
    V2 = [x*g2 for x in H]
    X = Graph()
    E = []
    for x in V1:
        for y in V2:
            if is_derangement(y*x.inverse()) == True:
                E.append((x,y))
    X.add_edges(E)
    S = H.stabilizer(1)
    T = H.transversals(1)
    L = []
    U = []
    for x in T:
        N = [i*x*g1 for i in S]
        M = [i*x*g2 for i in S]
        L.append(N)
        U.append(M)
    N = []
    M = []
    V = X.vertices()
    for x in T:
        U1 = []
        U2 = []
        A = X.neighbors(x*g1)
        B = X.neighbors(x*g2)
        #print len(A),set(A).issubset(set(V2))
        for y in V2:
            #print y not in A
            if y not in A:
                U1.append(y)
        for y in V1:
            if y not in B:
                U2.append(y)
        N.append(U1)
        M.append(U2)
    #print len(set(N[0]+N[1]+N[2]))
    #print [len(x) for x in N]
    """for x in N:
        U = []
        for y in V1:
            if X.neighbors(y) != x:
                U.append(y)
        M.append(U)"""
    for x in N:
        for y in M:
            Y = X.subgraph(x+y)
            #print Y.order(),Y.size(),S.order()^2
    return X,M,N

def is_a_coset_of_a_stabilizer(M):#H,
    for x in M:
        U = shifted(x)
        K = H.subgroup(U)
        if len(U) == K.order() and len(K.fixed_points())>0:
            pass
        else:
             return False#, K.fixed_points()
    return True

"""C = G.cosets(H)
for C1 in C:
    for C2 in C:
        g1 = C1[0]
        g2 = C2[0]
        if g1 != g2:
            X,N,M = graph_two_cosets(g1,g2,G,H)
            if len(N[0])>0:
                print(is_a_coset_of_a_stabilizer(N),is_a_coset_of_a_stabilizer(M))"""


"""G = TransitiveGroup(33,30)
#M = G.conjugacy_classes_subgroups()
#K = M[58]
#H = stab_union(K)
H = G.socle()
T = H.transversals(1)
B = G.blocks_all()[0]
for x in T:
     for y in T:
         X = check_graphs(x,y,H.stabilizer(1),B)
         print(y == x)
         print(X.independent_set(value_only=True))
         print("\n --------------------------------------------------- \n")"""


def induced_action(G,B):
    H = G.stabilizer(tuple(B),"OnSets")
    return group_action_on_cosets(G,H)

def label_blocks(G):
    O = G.orbit(tuple(G.blocks_all()[0]),"OnSets")
    D = dict()
    i = 1
    for x in O:
        D[tuple(sorted(x))] = i
        i += 1
    return D

def action_of_permutation_on_blocks(g,B):
    u = tuple([g(x) for x in B])
    return sorted(u)

def induced_action_label(G):
     PermGens = []
     n = G.degree()
     S = G.gens()
     D = label_blocks(G)
     for g in S:
         N = [0]*len(D)
         for x in D:
             i = D[tuple(x)]
             j = D[tuple(action_of_permutation_on_blocks(g,x))]
             N[i-1] = j
             #print(N)
         PermGens.append(Permutation(N))
     return PermutationGroup(PermGens)





def label_blocks_fixed(G,i):
    O = G.orbit(tuple(G.blocks_all()[i]),"OnSets")
    D = dict()
    i = 1
    for x in O:
        D[tuple(sorted(x))] = i
        i += 1
    return D

def action_of_permutation_on_blocks_fixed(g,B):
    u = tuple([g(x) for x in B])
    return sorted(u)

def induced_action_label_fixed(G,i):
     PermGens = []
     n = G.degree()
     S = G.gens()
     D = label_blocks_fixed(G,i)
     for g in S:
         N = [0]*len(D)
         for x in D:
             i = D[tuple(x)]
             j = D[tuple(action_of_permutation_on_blocks(g,x))]
             N[i-1] = j
             #print(N)
         PermGens.append(Permutation(N))
     return PermutationGroup(PermGens)
