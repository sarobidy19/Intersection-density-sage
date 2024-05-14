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
      for x in F:
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


def GL_to_permutation_group_on_lines(n,q):
    L = find_line_generators(n,q)
    P = L
    G = GL(n,GF(q))
    S = VectorSpace(GF(q),n)
    D = label_field_for_lines(S,P)
    Ggens = list(G.gens())
    Sbasis = S.basis()
    Group = []
    PermGrp = []
    for A in Ggens:
        Group.append((A,0))
    for g in Group:
        N = [0]*(len(P))
        for i in range(1,len(P)+1):
            j = list(D.keys())[list(D.values()).index(action_of_element_on_lines(S,g[0],g[1],D[i]))]
            #print i,j
            N[i-1] = j
        #print N
        PermGrp.append(Permutation(N))
    return PermutationGroup(PermGrp)

def GL_to_permutation_group_on_pairs(n,q):
    L = find_line_generators(n,q)
    P = L
    G = GL(n,GF(q))
    S = VectorSpace(GF(q),n)
    D = label_field_for_lines(S,P)
    Ggens = list(G.gens())
    Sbasis = S.basis()
    Group = []
    PermGrp = []
    for A in Ggens:
        Group.append((A,0))
    for g in Group:
        N = [0]*(len(P))
        for i in range(1,len(P)+1):
            j = list(D.keys())[list(D.values()).index(action_of_element_on_lines(S,g[0],g[1],D[i]))]
            #print i,j
            N[i-1] = j
        #print N
        PermGrp.append(Permutation(N))
    return PermutationGroup(PermGrp)

def GL_to_permutation_group_on_points(n,q):
    G = GL(n,GF(q))
    S = VectorSpace(GF(q),n)
    D = label_field([S[i] for i in range(1,len(S))])
    Ggens = list(G.gens())
    Sbasis = S.basis()
    Group = []
    PermGrp = []
    for A in Ggens:
        for a in Sbasis:
            Group.append((A,a))
    for g in Group:
        N = [0]*(q^n-1)
        for x in [S[i] for i in range(1,len(S))]:
            i = D[tuple(x)]
            j = D[tuple(action_of_element(g[0],0,x))]
            N[i-1] = j
        PermGrp.append(Permutation(N))
    return permutation_group(PermutationGroup(PermGrp))

def SL_to_permutation_group_on_points(n,q):
    G = SL(n,GF(q))
    S = VectorSpace(GF(q),n)
    D = label_field([S[i] for i in range(1,len(S))])
    Ggens = list(G.gens())
    Sbasis = S.basis()
    Group = []
    PermGrp = []
    for A in Ggens:
        for a in Sbasis:
            Group.append((A,a))
    for g in Group:
        N = [0]*(q^n-1)
        for x in [S[i] for i in range(1,len(S))]:
            i = D[tuple(x)]
            j = D[tuple(action_of_element(g[0],0,x))]
            N[i-1] = j
        PermGrp.append(Permutation(N))
    return permutation_group(PermutationGroup(PermGrp))

def find_label(n,q,y):
    G = GL(n,GF(q))
    D = label_field(S)
    for A in [G[0]^G.order()]:
        for b in S:
            N = [0]*(q^n)
            for x in S:
                i = D[tuple(x)]
                j = D[tuple(action_of_element(A,b,x))]
                N[i-1] = j
            if Permutation(y) == Permutation(N):
                return (A,b)

def is_canonical(G,F):
    F = shifted(F)
    for x in F:
        if x.order() > 1:
            u = x
            break
    L = Permutation(u).fixed_points()
    i = L[0]
    return set(F).issubset(set(G.stabilizer(i)))

def find_affine_lines(q):
    L = find_line(find_line_generators(2,q))
    AL = []
    #AL += [L[0]]
    for x in L:
        #print x[-1] , L[q-1][-1]
        if x[-1] == L[q-1][-1]:
            pass
        else:
            AL.append(sorted(x))
    return AL

def label_lines(q):
    D = dict()
    i = 1
    L = find_affine_lines(q)
    for x in L:
        D[i] = tuple(sorted(x))
        i += 1
    return D
