#!/usr/local/bin/sage

def exactly_one_transitive(n):
    L = TransitiveGroups(n)
    Groups = []
    for x in L:
        if gap.Transitivity(G) != 2:
            Groups.append(x)
        else:
            pass
    return Groups

def small_groups():
    Groups = []
    for n in [3..37]:
        Groups += exactly_one_transitive(n)
    return Groups

def get_generators(L):
    Generators = []
    for G in L:
           N = []
           X = G.gens()
           for x in X:
               N.append("{0}".format(x))
           Generators.append(N)
    return Generators

def write_generators(T,name):
     S = []
     for G in T:
         N = []
         Z = G.gens()
         for x in Z:
             N.append("{0}".format(x))
         S.append(N)
     f = open("{0}".format(name),"w+")
     f.writelines("{0}".format(S))
     f.close()
     print "done"
     return S

def generate_groups(L):
    Groups = []
    for x in L:
        Groups.append(PermutationGroup(x))
    return Groups

def has_cliques(G):
    M = G.conjugacy_classes_subgroups()
    for x in M:
        if x.is_regular() == True:
            return True
    return False

def RatioBound(G):
    K = eigenvalues_group(G)
    if 1 - K[2]/K[1] == 0:
        return 0
    else:
        return G.order()/(1 - K[2]/K[1])

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

def equality_ratio_bound(G):
    return RatioBound(G) == G.stabilizer(1).order()

def categorize(L):
    EKR = []
    No_EKR = []
    i = 0
    while len(L) >0:
        print len(L)
        G = L[i]
        if G.is_primitive() == False:
            if has_cliques(G) == True:
                EKR.append(G)
            elif equality_ratio_bound(G) == True:
                EKR.append(G)
            elif has_cliques(G) != True and equality_ratio_bound(G) != True and G.order() < 1000:
                H = stab_union(G)
                X = der_graph(H)
                if X.independent_set(value_only = True) == G.stabilizer(1).order():
                    EKR.append(G)
                else:
                    No_EKR.append(G)
        else:
            pass
        L.remove(G)
        i += 1
    return EKR,No_EKR
def stab_union(G):
     H = []
     for i in G.domain():
         H += G.stabilizer(i).list()
     K = set(H)
     return PermutationGroup(list(K))

def der_graph(G):
    CC = G.conjugacy_classes_representatives()
    D = []
    for x in CC:
        if is_derangement(x) == True:
            D += G.conjugacy_class(x).list()
    return Graph(G.cayley_graph(generators = D))

def is_derangement(x):
     if len(Permutation(x).fixed_points()) == 0:
         return True
     else:
         return False

for n in [3..37]:
    T = exactly_one_transitive(n)
    name = 'exactly_one_transitive_degree_{0}.sage'.format(n)
    write_generators(T,name)
#for
