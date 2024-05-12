#!/usr/local/bin/sage

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


def is_derangement(x):
     if len(Permutation(x).fixed_points()) == 0:
         return True
     else:
         return False


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
    print "subgroups found ..."
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
                print "size ",len(set(F)),"..."
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
        if phi.values() == [1]*len(G.conjugacy_classes()):
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
    print "Done"
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
                print n
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

def guroby_code(G,name):
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
          if phi.values() == [1]*len(G.conjugacy_classes()):
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
      print "Done"
      return Labels

def find_all(n):
    Good = [n]
    L = TransitiveGroups(n)
    m = len(list(L))
    for i in [1..m]:
        G = L[i]
        if G.is_primitive() == False:
            E = eigenvalues_group(G)[0]
            print E
            if len(set(E)) == 3:
                Good.append(i)
    return Good

f = open("degree_less_than_10","w+")
for n in [3..10]:
    T = find_all(n)
    f.writelines("{0}\n".format(T))
f.close()


def find_all_and_write(n):
    f = open("degree_less_than_{0}".format(n),"w+")
    f.writelines("[{0},".format(n))
    Good = [n]
    L = TransitiveGroups(n)
    m = len(list(L))
    for i in [1..m]:
        G = L[i]
        if G.is_primitive() == False:
            E = eigenvalues_group(G)[0]
            print E,i
            if len(set(E)) == 3:
                Good.append(i)
                f.writelines("{0},".format(i))
    f.close()
    return Good
