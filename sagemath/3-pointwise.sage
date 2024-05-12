#!/usr/local/bin/sage

def label_pairs(n):
    N = []
    L = tuples([1..n],3)
    for x in L:
        #print x[0] == x[1] or x[0] == x[2] or x[1] == x[2]
        if x[0] == x[1] or x[0] == x[2] or x[1] == x[2]:
            pass
        else:
            N.append(x)
    D = dict()
    i = 1
    for x in N:
        D[x] = i
        i += 1
    return D,N

def action_of_element_as_permutation(f,T):
    return (f(T[0]),f(T[1]),f(T[2]))

def SymmetricGroup_acting_on_triples(n):
    PermGens = []
    G = SymmetricGroup(n)
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

def is_derangement(x):  # for 3 intersecting
    if len(Permutation(x).fixed_points()) <= 2:
          return True
    else:
        return False

def VA(m):
    t = ''
    for i in range(m):
        if i == m-1:
            t += 'X{0}'.format(i)
        else:
            t += 'X{0},'.format(i)
    return var(t)

def weights(n,L,M):
    l,m = len(L),len(M)   #L = conj and M char
    print l,m
    V = VA(m)
    var('z')
    CC_size = []
    char_values = []
    Eq = []
    for F in L:
        for x in SymmetricGroup(n).conjugacy_classes_representatives():
            if x.cycle_type() == F:
                CC_size.append([SymmetricGroup(n).conjugacy_class(x).cardinality(),x])
                break
            else:
                pass
    char = [SymmetricGroupRepresentation(M[i]) for i in range(m)]
    print CC_size
    for chi in char:
        phi = chi.to_character()
        t = 0
        for i in range(m):
            t += V[i]*phi(CC_size[i][1])*CC_size[i][0]
            print chi,V[i],phi(CC_size[i][1]),CC_size[i][1].cycle_type()
        if phi.values() == [1]*len(SymmetricGroup(n).conjugacy_classes_representatives()):
            Eq.append(t == 6*binomial(n,3) -1)  ######## maximum eigenvalue
        else:
            Eq.append(t == -phi.degree())
        Sol = solve(Eq,V)
    print "Weight possible?", len(Sol) != 0
    if len(Sol) == 0:
        return sys.exit()
##################################################################
    G = SymmetricGroup(n)
    derangement_conjugacy_classes_representatives = []
    CC = G.conjugacy_classes_representatives()
    for x in CC:
        if is_derangement(x) == True:
            derangement_conjugacy_classes_representatives.append(x)
    Q = derangement_conjugacy_classes_representatives
    print len(Q)
    W = [0]*len(Q)
    for i in range(len(Q)):
        u = Q[i].cycle_type()
        #print u
        for j in range(m):
            if u == Partition(L[j]):
                W[i] = Sol[0][j].rhs()
    print "Equation",Eq
    print Sol
    return [Sol[0][i].rhs() for i in range(len(Sol[0]))],W

def eigenvalues_weights(n,W):
    eigenvalues = []
    G = SymmetricGroup(n)
    derangement_conjugacy_classes_representatives = []
    CC = G.conjugacy_classes_representatives()
    for x in CC:
        if is_derangement(x) == True:
            derangement_conjugacy_classes_representatives.append(x)
    #print derangement_conjugacy_classes_representatives
    Irr = G.irreducible_characters()#
    #Irr = SymmetricGroupRepresentations(n)
    for psi in Irr:
        #phi = psi.to_character()
        s = 0
        L = derangement_conjugacy_classes_representatives
        for i in range(len(L)):
            s += (1/psi.degree()) * ( W[i]*G.conjugacy_class(L[i]).cardinality()*psi(L[i]) )
        eigenvalues.append(s)
        print (s,psi)
        #if psi.degree() == binomial(n-1,2)-1:
        #    print "ITOOOOOOOOOOOOOOOOOOOOOOOOOOO",s
    return eigenvalues,gap.Minimum(eigenvalues)

n = int(sys.argv[1])
W = weights(n,[[n],[n-1,1],[n-2,2],[n-3,2,1],[n-3,3],[n-2,1,1],[n-4,3,1]],[[n],[n-1,1],[n-2,2],[n-2,1,1],[n-3,3],[n-3,1,1,1],[n-3,2,1]])
L =  eigenvalues_weights(n,W[1])
print L


def find_derangement_classes_representatives_3_derangements(G):
    P = Partitions(3)
    CC = G.conjugacy_classes_representatives()
    N = []
    for x in CC:
        if is_derangement(x,P):
            N.append(x)
        else:
            pass
    return N

def group_acting_on_triples(G):
    PermGens = []
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
