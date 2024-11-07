#!/usr/local/bin/sage


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


def AGL_to_permutation_group_on_lines(n,q):
    L = find_line_generators(n,q)
    P = find_line(L)
    G = GL(n,GF(q))
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
            j = list(D.keys())[list(D.values()).index(action_of_element_on_lines(S,g[0],g[1],D[i]))]
            #print i,j
            N[i-1] = j
        #print N
        PermGrp.append(Permutation(N))
    return permutation_group(PermutationGroup(PermGrp))

def stabilizer_of_blocks(G,L):
    N = []
    Perms = []
    L = G.blocks_all()[0]
    L = G.orbit(tuple(L),"OnSets")
    for x in L:
        N.append(G.stabilizer(tuple(x),"OnSets"))
    x = set(N[0])
    for s in N:
        x = set(s).intersection(x)
    return PermutationGroup(list(x))

def is_halftransitive(G):
     Z = G.orbits()
     for x in Z:
         if len(x) != len(Z[0]):
             return False
     return True
def shifted(U):
     x = U[0].inverse()
     return [x*i for i in U]

def stab_union(G):
     H = []
     for i in G.domain():
         H += G.stabilizer(i).list()
     K = set(H)
     return PermutationGroup(list(K))

def FindCocliques(q,k):
    G = AGL_to_permutation_group_on_lines(2,q)
    L = find_line_generators(2,q)
    L = find_line(L)
    H = stabilizer_of_blocks(G,L)
    U = G.cosets(H)
    print(binomial(len(U),k))
    Cocliques = []
    SubCosets = Combinations(U,k)
    for i in range(2000):
         #i = ZZ.random_element(171230,1712304)
         x = SubCosets[i]
         E = []
         for y in x:
             E += y
         print(intersecting(G,E),len(E),i)
         if intersecting(G,E) == True:
             Cocliques.append(x)
             break
    return Cocliques

def IntersectingCosets(A,B,H,G):
    Reps = []
    for x in [A,B]:
        Reps.append(x[0])
    #print Reps
    for h in H:
        if intersecting(G,[Reps[0]*Reps[1].inverse(), h]) == False:
            #print Reps[0]*Reps[1].inverse(), h
            return False
        else:
            pass
    return True

def IntersectingAllCosets(T,H,G):
    for x in T:
        for y in T:
            if IntersectingCosets(x,y,H,G) == False and y != x:
                return False
        else:
            pass
    return True

def RatioBound(G):
    K = eigenvalues_group(G)
    return G.order()/(1 - K[2]/K[1])

def  GraphOfCosets(G,H):
    U = G.cosets(H)
    Reps = []
    for x in U:
        Reps.append(x[0])
    X = Graph()
    X.add_vertices(Reps)
    for x in X.vertices():
        for y in X.vertices():
            if x!=y:
                if is_derangement(x*y.inverse()) == True:
                    X.add_edge((y,x))
                else:
                    pass
    return X

def intersecting_on_points(G,L):
    main_key = False
    for i in G.domain():
        N = []
        for x in L:
            N.append(x(i))
        key = True
        a = N[0]
        for x in N:
            if x != a:
                key = False
                break
            else:
                pass
        if key == True:
            return key
        else:
            pass
    return main_key

def find_derangement_classes_representatives(G):
    D = []
    CC = G.conjugacy_classes_representatives()
    for x in CC:
        if is_derangement(x) == True:
            D.append(x)
        else:
            pass
    return D

def number_of_derangements(G):
    D = find_derangement_classes_representatives(G)
    Der = []
    for x in D:
        Der += G.conjugacy_class(x).list()
    return len(Der)

def VA(m):
    t = ''
    for i in range(1,m+1):
        if i == m:
            t += 'x{0}'.format(i)
        else:
            t += 'x{0},'.format(i)
    return var(t)

#T = find_derangement_classes_representatives(G)
def weights(G,L,M,T):
    #G = AGL_to_permutation_group_on_lines(2,q)
    l,m = len(L),len(M)   #L = conj and M char
    print(l,m)
    V = VA(m)
    var('z')
    CC_size = []
    char_values = []
    Eq = []

    for F in L:
        for x in T:
            if x == F:
                x = F
                CC_size.append([G.conjugacy_class(x).cardinality(),x])
            #    break
            else:
                pass
    char = M   #[SymmetricGroupRepresentation(M[i]) for i in range(m)]
    print(CC_size)
    for chi in char:
        phi = chi
        t = 0
        for i in range(m):
            t += V[i]*phi(CC_size[i][1])*CC_size[i][0]
            print(V[i],phi(CC_size[i][1]))#,CC_size[i][1].cycle_type()
        if list(phi.values()) == [1]*len(G.conjugacy_classes_representatives()):
            Eq.append(t == G.degree() -1)  ######## maximum eigenvalue
        else:
            Eq.append(t == -phi.degree())
        Sol = solve(Eq,V)
    print("Weight possible?", len(Sol) != 0)
    if len(Sol) == 0:
        return False
##################################################################
    Q = T #find_derangement_classes_representatives(G)
    print(len(Q))
    W = [0]*len(Q)
    for i in range(len(Q)):
        u = Q[i]
        #print u
        for j in range(m):
            if u == L[j]:
                W[i] = Sol[0][j].rhs()
    print("Equation",Eq)
    print(Sol)
    return [Sol[0][i].rhs() for i in range(len(Sol[0]))],W

def eigenvalues_weights(G,W):
    eigenvalues = []
    derangement_conjugacy_classes_representatives = find_derangement_classes_representatives(G)
    Irr = G.irreducible_characters()
    D = []
    CC = G.conjugacy_classes_representatives()
    #for x in CC:
#        if is_derangement(x) == True:
#            D.append(1)
#        else:
#            D.append(0)
    for psi in Irr:
        #phi = psi.to_character()
        s = 0
        L = derangement_conjugacy_classes_representatives
        print(len(L))
        for i in range(len(W)):
            s += (1/psi.degree()) * ( W[i]*G.conjugacy_class(L[i]).cardinality()*psi(L[i]) )
        eigenvalues.append(s)
        print(s)
    return eigenvalues,gap.Minimum(eigenvalues)

def Run(q):
    G = AGL_to_permutation_group_on_lines(2,q)
    print(G.order())
    S = G.conjugacy_classes_subgroups()
    Good = []
    for x in S:
        if x.is_transitive() == True:
             Good.append(x)
    Good.pop(len(Good)-1)
    print(len(Good))
    Great = []
    for x in Good:
         print(x.order())
         #H = stab_union(G)
         if x.order() != (q^2-1)*q^2:
             pass
         else:
             H = stab_union(x)
             print(intersecting(G,H) == True, x.structure_description())
             Great.append(x)

def is_derangement(x): #has bug from sage
     if len(Permutation(x).fixed_points()) == 0 and x.order()>1:
         return True
     else:
         return False

def is_derangement(x):
    if 1 in x.cycle_type():
        return False
    else:
        return True 

def stab_union(G):
     H = []
     for i in G.domain():
         H += G.stabilizer(i).list()
     K = set(H)
     return PermutationGroup(list(K))

def regularity(G,F):
    N = []
    n = len(G.domain())
    for i in range(1,n+1):
        for j in range(1,n+1):
            M = []
            for x in F:
                if x(i) == j:
                    M.append(x)
            N.append((i,j,len(M)))
            print ((i,j,len(M)))
    #return N

def intersecting(G,F):
     n = len(G.domain())
     for x in F:
         for y in F:
             a = 'intersecting'
             for i in range(1,n+1):
                 if x(i) == y(i):
                     a = 'intersecting'
                     #print x,y,i
                     break
                 else:
                     a = 'not-intersecting'
                     pass
             if a == 'intersecting':
                 pass
             else:
                 #print (x,y)
                 return False
     return True

def test(q):
    G = AGL_to_permutation_group_on_lines(2,q)
    L = find_line_generators(2,q)
    L = find_line(L)
    H = stabilizer_of_blocks(G,L)
    S = G.conjugacy_classes_subgroups()
    print("subgroups found ...")
    Special = []
    for x in S:
        if x.order() == q^2*(q^2-1):
            Special.append(x)
    K = Special[-1]
    Good = []
    for x in Special:
        if x.is_isomorphic(K) == True:
            Good.append(x)
    Special = Good
    C = Special[0].cosets(H)
    F = C[1]
    for i in range(1,len(Special)):
        C = Special[i].cosets(H)
        for x in C:
            if intersecting(G,F+x) == True:
                F += x
                print("size ",len(set(F)),"...")
                break
    return len(set(F))

q = sys.argv[1]
#Run(int(q))


def eigenvalues_group(G):
    IRR = G.irreducible_characters()
    derangement_conjugacy_classes_representatives = []
    eigenvalues = []
    CC = G.conjugacy_classes_representatives()
    for x in CC:
        if is_derangement(x) == True:
            derangement_conjugacy_classes_representatives.append(x)
    for phi in IRR:
        s = 0
        for x in derangement_conjugacy_classes_representatives:
            s += (1/phi.degree()) * ( G.conjugacy_class(x).cardinality()*phi(x) )
        eigenvalues.append(s)
    return list(eigenvalues),gap.Minimum(eigenvalues),gap.Maximum(eigenvalues)


def eigenvalues_group_with_conjugacy_classes(G,C):
    IRR = G.irreducible_characters()
    derangement_conjugacy_classes_representatives = []
    eigenvalues = []
    CC = G.conjugacy_classes_representatives()
    for x in CC:
        if is_derangement(x) == True:
            derangement_conjugacy_classes_representatives.append(x)
    for phi in IRR:
        s = 0
        for x in derangement_conjugacy_classes_representatives:
            for Y in C:
                if x in Y:
                    s += (1/phi.degree()) * ( G.conjugacy_class(x).cardinality()*phi(x) )
        eigenvalues.append(s)
    return list(eigenvalues),gap.Minimum(eigenvalues),gap.Maximum(eigenvalues)

def eigenvalues_group_with_dim(G):
     IRR = G.irreducible_characters()
     derangement_conjugacy_classes_representatives = []
     eigenvalues = []
     CC = G.conjugacy_classes_representatives()
     for x in CC:
         if is_derangement(x) == True:
             derangement_conjugacy_classes_representatives.append(x)
     for phi in IRR:
         s = 0
         for x in derangement_conjugacy_classes_representatives:
             s += (1/phi.degree()) * ( G.conjugacy_class(x).cardinality()*phi(x) )
         eigenvalues.append((s,phi.degree()^2))
     return list(eigenvalues)#,gap.Minimum(eigenvalues),gap.Maximum(eigenvalues)

def eigenvalues_group_with_all_dim(G):
     IRR = G.irreducible_characters()
     derangement_conjugacy_classes_representatives = []
     eigenvalues = []
     CC = G.conjugacy_classes_representatives()
     for x in CC:
         if is_derangement(x) == True:
             derangement_conjugacy_classes_representatives.append(x)
     for phi in IRR:
         s = 0
         for x in derangement_conjugacy_classes_representatives:
             s += (1/phi.degree()) * ( G.conjugacy_class(x).cardinality()*phi(x) )
         eigenvalues.append((s,phi.degree()^2))
     Eigenvalues = []
     eigenvalue_set = list(set(eigenvalues_group(G)[0]))
     for x in eigenvalue_set:
         N = []
         for y in eigenvalues:
             if x == y[0]:
                 N.append(y[1])
             else:
                 pass
         Eigenvalues.append((x,sum(N)))

     return Eigenvalues
def inertia_bound(G):
     Ev = eigenvalues_group_with_all_dim(G)
     p,n,z = 0,0,0
     for x in Ev:
         if int(x[0])<0:
             n += x[1]
         if int(x[0]) > 0:
             p += x[1]
         if int(x[0]) == 0:
             z += x[1]
     return min(z + n, z+p)

def find_label(n,q,y):
    G = GL(n,GF(q))
    S = VectorSpace(GF(q),n)
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
def is_join(G):
     Ev = eigenvalues_group(G)
     return -Ev[1] + Ev[2] == G.order()
def has_cliques(G,k):
     CC = G.conjugacy_classes_representatives()
     for x in CC:
         if x.order() == k and is_derangement(x) == True:
             return True
     return False

def der_graph(G):
    CC = G.conjugacy_classes_representatives()
    D = []
    for x in CC:
        if is_derangement(x) == True:
            D += G.conjugacy_class(x).list()
    return Graph(G.cayley_graph(generators = D))

def guroby_code_old(G,name):
    C = find_derangement_classes_representatives(G)
    Irr = G.irreducible_characters()
    V = VA(len(C))
    Non_triv = []
    Labels = []
    for i in C:
        Labels.append(V[i],Permutation(V[i]).cycle_type())
    for phi in Irr:
        s = 0
        for i in range(len(C)):
            s += V[i]*phi(C[i])*float(len(G.conjugacy_class(C[i])))
        if list(phi.values()) == [1]*len(G.conjugacy_classes()):
            Triv = s/phi.degree()
        else:
            Non_triv.append(s>= -phi.degree())
            Non_triv.append(s<= phi.degree()*(G.degree()-1))
    f = open("{0}.lp".format(name),"w+")
    f.writelines("Maximize \n \n")
    f.writelines("{0}\n".format(Triv))
    f.writelines("Subject To \n \n")
    for x in Non_triv:
        f.writelines("{0}\n".format(x))
    f.writelines("End")
    f.close()
    print("Done")
    return Labels

def has_regular_subgroup(G):
    M = G.conjugacy_classes_subgroups()
    for x in M:
        if x.is_regular() == True:
            return True
        else:
            pass
    return False

def intersection_density(G):
    H = stab_union(G)
    if H.order() != 1 and H.order() != G.order():
        X = der_graph(H)
        return X.independent_set(value_only = True)/H.stabilizer(1).order()
    else:
        X = der_graph(G)
        return X.independent_set(value_only = True)/G.stabilizer(1).order()

def almost_intersecting(G,F):
    for x in F:
        n = 0
        for y in F:
            if is_derangement(x*y.inverse()) == True:
                n += 1
                print(n)
                if n>1:
                    return False
                else:
                    pass
            else:
                pass
    return True

def eigenvalues_group_conjugacy_class(G,C):
    IRR = G.irreducible_characters()
    derangement_conjugacy_classes_representatives = C
    eigenvalues = []
    for phi in IRR:
        s = 0
        for x in derangement_conjugacy_classes_representatives:
            s += (1/phi.degree()) * ( G.conjugacy_class(x).cardinality()*phi(x) )
        eigenvalues.append(s)
    return list(eigenvalues),gap.Minimum(eigenvalues),gap.Maximum(eigenvalues)

def guroby_code_error(G,name):
      C = find_derangement_classes_representatives(G)
      Irr = G.irreducible_characters()
      V = VA(len(C))
      Non_triv = []
      Labels = []
      for i in range(len(C)):
          Labels.append((V[i],Permutation(C[i]).cycle_type()))
      for phi in Irr:
          s = 0
          for i in range(len(C)):
              a = phi(C[i])
              s += V[i]*ComplexNumber(real(a).n() ,0*imag(a).n())*len(G.conjugacy_class(C[i]))
          if list(phi.values()) == [1]*len(G.conjugacy_classes()):
              Triv = s/phi.degree()
              Non_triv.append(Triv >= -1)
          else:
              Non_triv.append(s/phi.degree() >= -1)
              Non_triv.append(s/phi.degree() <= (G.degree()-1))
      f = open("{0}.lp".format(name),"w+")
      f.writelines("Maximize \n \n")
      f.writelines("{0}\n".format(Triv))
      f.writelines("Subject To \n \n")
      for x in Non_triv:
          f.writelines("{0}\n".format(x))
      f.writelines("End")
      f.close()
      print("Done")
      return Labels

def gerneralized_der_graph(S):
    C = Combinations(S,2)
    X = Graph()
    E = []
    X.add_vertices(S)
    for x in C:
        if is_derangement(x[0]*x[1].inverse()) == True:
            E.append(x)
    X.add_edges(E)
    return X

def characteristic_vector(G,S):
    v = []
    for x in G:
        if x in S :
            v.append(1)
        else:
            v.append(0)
    return v

def is_in_span(G,S):
    T = [characteristic_vector(G,G.stabilizer(i)) for  i in G.domain()]
    s = Matrix(T).rank()
    T.append(characteristic_vector(G,S))
    A = Matrix(T)
    if A.rank() == s:
        print(A.rank(),s)
        return True
    else:
        print(A.rank(),s)
        return False

def ordering(n):
    D = []
    d = []
    T = tuples([1..n],2)
    for i in [1..n]:
        D.append((i,i))
    for x in T:
        if x[0] != x[1]:
            D.append(x)
            d.append(x)
    return D,d



def characterization_matrix_M(G):
    D = ordering(G.degree())[0]
    M = []
    for g in G:
        T = []
        for x in D:
            if g(x[0]) == x[1]:
                T.append(1)
            else:
                T.append(0)
        M.append(T)
    return Matrix(M)

def characterization_matrix_N(G):
    D = ordering(G.degree())[1]
    N = []
    C = find_derangement_classes_representatives(G)
    CC = []
    for x in C:
        CC += G.conjugacy_class(x).list()
    for g in CC:
        T = []
        for x in D:
            if g(x[0]) == x[1]:
                T.append(1)
            else:
                T.append(0)
        N.append(T)
    return Matrix(N)

def fix_conj(G):
    S = []
    CC = G.conjugacy_classes_representatives()
    for g in CC:
        if len(Permutation(g).fixed_points()) == 1:
            S += G.conjugacy_class(g).list()
    return S

def sort_conjugacy_classes(G):
    CC = G.conjugacy_classes_representatives()
    L = []
    for i in range(len(CC)):
        g = CC[i].inverse()
        for j in range(len(CC)):
            if g in G.conjugacy_class(CC[j]) and i != j:
                L.append((CC[i],CC[j]))
            elif  g in G.conjugacy_class(CC[j]) and i == j:
                L.append(tuple(CC[i]))
    return list(set(L))

def list_ratio_bound(n,L): #new delete this one if you find the original
    return float(n/(1-max(L)/min(L)))

def eigenvalues_group_conjugacy_class(G,C):
    IRR = G.irreducible_characters()
    derangement_conjugacy_classes_representatives = C
    eigenvalues = []
    for phi in IRR:
        s = 0
        for x in derangement_conjugacy_classes_representatives:
            s += (1/phi.degree()) * ( G.conjugacy_class(x).cardinality()*phi(x) )
        eigenvalues.append(s)
    return list(eigenvalues),gap.Minimum(eigenvalues),gap.Maximum(eigenvalues)

def eigenvalues_group_conjugacy_class_and_weights(G,W,L):
    IRR = G.irreducible_characters()
    eigenvalues = []
    for phi in IRR:
        s = 0
        for i in [0..len(L)-1]:
            s += (1/phi.degree()) *ComplexNumber(W[i]) * ( G.conjugacy_class(L[i]).cardinality()*phi(L[i]) )
        eigenvalues.append(s)
    return eigenvalues


def inner_product(G,f,g):
     CC = G.conjugacy_classes_representatives()
     s = 0
     for x in CC:
         s += f(x)*conjugate(g(x))*len(G.conjugacy_class(x))
     return s/G.order()
