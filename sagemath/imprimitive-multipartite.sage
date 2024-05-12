L = gap.AllTransitiveGroups(gap.Size,[500..1000],gap.NrMovedPoints,36,gap.IsPrimitive,gap.false)
Groups = []
for G in Groups:
     a = 'ok'
     if G.order() > 2000:
         print "nah"
         a = 'notok'
     if a == 'ok':
             print "-----------------------------------------------------------"
             print  G.structure_description(),G.order()
             X = der_graph(G)
             print X,G.stabilizer(1).order()
             if X[1] == G.stabilizer(1).order():
                 X = G
             print "-----------------------------------------------------------"

def get_generators(L):
      for G in L:
           N = []
           X = gap.GeneratorsOfGroup(G)
           for x in X:
               N.append("{0}".format(x))
           Generators.append(N)

def write_generators(T,name):
     S = []
     for G in T:
         N = []
         Z = G.gens()
         for x in Z:
             N.append("{0}".format(x))
         S.append("{0},\n ".format(N))
     f = open("{0}".format(name),"w+")
     f.write("{0}".format(S))
     f.close()
     print "done"
     return S



def get_generators_from_gap_list(L,name):
    S = []
    f = open("{0}.sage".format(name),"w+")
    for x in L:
        N = []
        Z = gap.GeneratorsOfGroup(x);
        for y in Z:
            N.append("{0}".format(y))
        S.append(N)
    f.write("{0}".format(S))
    f.close()
    print "Done"
    return S



def is_derangement(x):
....:     if len(Permutation(x).fixed_points()) == 0:
....:         return True
....:     else:
....:         return False


def stab_union(G):
....:     H = []
....:     for i in G.domain():
....:         H += G.stabilizer(i).list()
....:     K = set(H)
....:     return PermutationGroup(list(K))
....:

def der_graph(G):
    D = []
    CC = G.conjugacy_classes_representatives()
    for x in CC:
        if is_derangement(x) == True:
            D.append(x)
    Der = []
    for x in D:
        Der += G.conjugacy_class(x).list()
    return Graph(G.cayley_graph(generators = Der)),Der

def der_graph(G):
....:     CC = G.conjugacy_classes_representatives()
....:     D = []
....:     Der = []
....:     for x in CC:
....:         if is_derangement(x) == True:
....:             D.append(x)
....:     for x in D:
....:         Der += G.conjugacy_class(x).list()
....:     X = G.cayley_graph(generators=Der)
....:     return Graph(X)

def is_bipartite_derangement_graph(G):
    ev = eigenvalues_group(G)[0]
    for x in ev:
        if -1*x in ev:
            pass
        else:
            return False
    return True
