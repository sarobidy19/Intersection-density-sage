def vector_to_tuple(x):
    X = []
    for i in x:
        X.append(tuple(i))
    return X

def tuple_to_vector(x):
    X = []
    for i in x:
        X.append(vector(i))
    return X

def action_of_element(A,a,v):
    #print A,v,a
    return A*vector(v) +a

def action_of_element_on_lines(V,A,a,l):
    L = []
    for x in l:
        L.append(action_of_element(A,a,x))
    return set(vector_to_tuple(L))

def label_field(F):
      D = dict()
      i = 1
      for x in F.list():
          D[tuple(x)] = i
          i += 1
      return D

def label_field_for_lines(V,F):
      D = dict()
      i = 1
      for x in F:
          D[i] = set(vector_to_tuple(x))
          i += 1
      return D

def AGL_to_permutation_group_on_points(n,q):
    G = GL(n,GF(q))
    S = VectorSpace(GF(q),n)
    D = label_field(S)
    Ggens = list(G.gens())
    Sbasis = S.basis()
    Group = []
    PermGrp = []
    for A in Ggens:
        for a in Sbasis:
            Group.append((A,a))
    for g in Group:
        N = [0]*(q^n)
        for x in S:
            i = D[tuple(x)]
            j = D[tuple(action_of_element(g[0],g[1],x))]
            N[i-1] = j
        PermGrp.append(Permutation(N))
    return PermutationGroup(PermGrp)

def find_line_generators(n,q):
    V = VectorSpace(GF(q),n)
    S = V.list()
    Orbits = []
    while len(S) >1:
        x = S[0]
        N = []
        U = V.subspace([x])
        for y in S:
            if (y in U) == True:
                N.append(y)
            else:
                pass
        Orbits.append(N)
        for z in N:
            S.remove(z)
    s = Orbits[0][0]
    Orbits.pop(0)
    for x in Orbits:
        x.append(s)
    return Orbits

def find_line(L):
    Lines = []
    for i in range(len(L)):
        l = L[i]
        lines_generated = []
        if i != 0 and i != 1:
            for x in L[0]:
                N = []
                for y in l:
                    N.append(y+x)
                lines_generated.append(N)
        elif i == 0:
            for x in L[1]:
                N = []
                for y in l:
                    N.append(y+x)
                lines_generated.append(N)
        elif i == 1:
            for x in L[0]:
                N = []
                for y in l:
                    N.append(y+x)
                lines_generated.append(N)
        Lines += lines_generated
    return Lines


def ASL_to_permutation_group_on_lines(n,q):
    L = find_line_generators(n,q)
    P = find_line(L)
    G = SL(n,GF(q))
    S = VectorSpace(GF(q),n)
    D = label_field_for_lines(S,P)
    Ggens = list(G.gens())
    Sbasis = S.basis()
    Group = []
    PermGrp = []
    for A in Ggens:
        for a in Sbasis:
            Group.append((A,a))
    for g in Group:
        N = [0]*(len(P))
        for i in range(1,len(P)+1):
            j = D.keys()[D.values().index(action_of_element_on_lines(S,g[0],g[1],D[i]))]
            #print i,j
            N[i-1] = j
        #print N
        PermGrp.append(Permutation(N))
    return PermutationGroup(PermGrp)

def FindCocliques(q,k,M):
    G = ASL_to_permutation_group_on_lines(2,q)
    L = find_line_generators(2,q)
    L = find_line(L)
    H = stabilizer_of_blocks(G,L)
    print H.structure_description()
    U = G.cosets(H)
    Cocliques = []
    SubCosets = Combinations(U,k)
    for i in M:
         #i = ZZ.random_element(171230,1712304)
         x = SubCosets[i]
         E = []
         for y in x:
             E += y
         print intersecting(G,E),len(E),i
         if intersecting(G,E) == True:
             Cocliques.append(x)
             break
    return Cocliques

def intersecting_cosets(G,H,C1,C2):
    y = C2[0]
    x = C1[0]
    for h in H:
        if intersecting(G,[x*y^(-1),h]) == False:
            return False
        else:
            pass
    return True



def coset_der_graph(G):
    q = sqrt(G.socle().order())
    L = find_line_generators(2,q)
    L = find_line(L)
    H = stabilizer_of_blocks(G,L)
    X = Graph()
    C = G.cosets(H)
    n = len(C)
    for i in range(n):
        for j in range(n):
            if intersecting_cosets(G,H,C[i],C[j]) == False:
                X.add_edge((i,j))
    return X
def coset_der_graph1(G,M):
     X = Graph()
     C = G.cosets(M)
     n = len(C)
     for i in range(n):
         for j in range(n):
             if intersecting_cosets(G,M,C[i],C[j]) == False:
                 X.add_edge((i,j))
     return X
