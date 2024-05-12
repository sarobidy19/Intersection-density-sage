#!/usr/local/bin/sage

def get_derangements(G):
    Drep = []
    D = []
    CC = G.conjugacy_classes_representatives()
    for x in CC:
        if is_derangement(G,x) == True:
            Drep.append(x)
        else:
            pass
    for x in Drep:
          D += list(G.conjugacy_class(x))
    return D
    #return filter(is_derangement,G)
def is_derangement(G,x):  # needs G to be defined beforehand
    for i in G.domain():
        if x(i) == i:
            return False
        else:
            pass
    return True

def eigenvalues_group(G):
    IRR = G.irreducible_characters()
    derangement_conjugacy_classes_representatives = []
    eigenvalues = []
    CC = G.conjugacy_classes_representatives()
    for x in CC:
        if is_derangement(G,x) == True:
            derangement_conjugacy_classes_representatives.append(x)
    for phi in IRR:
        s = 0
        for x in derangement_conjugacy_classes_representatives:
            s += (1/phi.degree()) * ( G.conjugacy_class(x).cardinality()*phi(x) )
        eigenvalues.append(s)
    return list(eigenvalues),gap.Minimum(eigenvalues),gap.Maximum(eigenvalues)

def eigenvalues_group_and_multi(G):
    IRR = G.irreducible_characters()
    derangement_conjugacy_classes_representatives = []
    eigenvalues, multiplicity = [], []
    CC = G.conjugacy_classes_representatives()
    for x in CC:
        if is_derangement(G,x) == True:
            derangement_conjugacy_classes_representatives.append(x)
    for phi in IRR:
        s = 0
        for x in derangement_conjugacy_classes_representatives:
            s += (1/phi.degree()) * ( G.conjugacy_class(x).cardinality()*phi(x) )
        eigenvalues.append(s)
        multiplicity.append(phi(G.identity())^2)
    return eigenvalues,multiplicity

def eigenvalues_group_and_characters(G):
    IRR = G.irreducible_characters()
    derangement_conjugacy_classes_representatives = []
    eigenvalues_characters = []
    CC = G.conjugacy_classes_representatives()
    for x in CC:
        if is_derangement(G,x) == True:
            derangement_conjugacy_classes_representatives.append(x)
    for phi in IRR:
        s = 0
        for x in derangement_conjugacy_classes_representatives:
            s += (1/phi.degree()) * ( G.conjugacy_class(x).cardinality()*phi(x) )
        eigenvalues_characters.append([s,phi.values()])
    return list(eigenvalues_characters)

def derangement_graph(G):
    D = get_derangements(G)
    X = G.cayley_graph(generators = D)
    X = Graph(X)
    return X

def test_groups(L,K):
    j = 0
    f = open("imprimitiveeeeEKR4.txt","w+")
    for i in range(len(L)):
        j += 1 #not needed anymore if the list is a sage list not a GAP one.
        G = L[i]
        #print gap.Print(K[j])
        Y = derangement_graph(G)
        independent_number = Y.independent_set(value_only = True)
        #clique_number = Y.clique_number()
        evalue_multiplicity = eigenvalues_group_and_multi(G)
        eigenvalues = list(evalue_multiplicity[0])
        multiplicity = list(evalue_multiplicity[1])
        evalue_min_max = eigenvalues_group(G)
        print "----------------------------------------------------------"
        print "\t No",int(i+1)
        print "\n group =",gap.StructureDescription(K[i])
        print " Size = ",G.order()
        print " Domain = ",G.domain()
        #print " Generators = ",G.gens()
        print " Independence number = ",independent_number, "\n stabilizer = ",G.stabilizer(1).order()
        print " EKR",G.stabilizer(1).order() == independent_number
        print " eigenvalues",eigenvalues
        print " multiplicity", multiplicity
        print " Blocks",G.blocks_all()
        print " Join", evalue_min_max[2]-evalue_min_max[1] == G.order()
        print " ratio-bound", (G.order())/(1-(evalue_min_max[2]/evalue_min_max[1]))
        f.write("----------------------------------------------------------------------------- \n \t No {0}\n group = {1}\n Size = {2}\n Domain = {6} \n EKR {3}\n eigenvalues = {4}\n multiplicity = {7} \n Blocks = {5}\n \n----------------------------------------------------------------------------- \n".format(int(i+1),gap.StructureDescription(K[i]),G.order(),G.stabilizer(1).order() == independent_number,eigenvalues,G.blocks_all(),G.domain(),multiplicity))
    print "----------------------------------------------------------"
    f.close()


def divide_lists(L,k):
    S = []
    s = len(L)%k
    q = (len(L)-s)/k
    for i in range(q):
        S.append([L[j] for j in range(i*k,i*k+k)])
    if s != 0 :
        S.append([L[i] for i in range(q*k,q*k+s)])
    return S

def fixed_pts(g):
    return len(Permutation(g).fixed_points())

def fix_char(G):
    derangement_conjugacy_classes_representatives = []
    CC = G.conjugacy_classes_representatives()
    for x in CC:
        if is_derangement(G,x) == True:
            derangement_conjugacy_classes_representatives.append(x)
    s = 0
    for x in derangement_conjugacy_classes_representatives:
        s += ( G.conjugacy_class(x).cardinality()*(fixed_pts(x)-1) )
    return s

def get_max_block(G):
    B = G.blocks_all()
    max = B[0]
    for X in B:
        if len(X) >len(max):
            max = X
    return max

def test_min_evalue(L):
    for G in L:
        V = get_max_block(G)
        Dset = set(get_derangements(G))
        H = G.stabilizer(tuple(V),"OnSets")
        Hset = set(H)
        ev = eigenvalues_group(G)
        print G.order(),len(H),len(Hset.intersection(Dset)) - H.order(),ev[1], V,H.is_normal(G), G.blocks_all()

def get_all_max_block(G):
    V = get_max_block(G)
    Orb = G.orbit(tuple(V),"OnSets")
    ORB_list = []
    for T in Orb:
        ORB_list.append(tuple(T))
    return ORB_list

def stabilizer_setwise(G,L):
    V = [set(G.stabilizer(tuple(L[i]),"OnSets").list()) for i in range(len(L))]
    S = V[0]
    for X in V:
        S = S.intersection(X)
    return S
  #  else:
  #      V = []
  #      for


#print divide_lists(range(500),9)
L = gap.AllTransitiveGroups(gap.NrMovedPoints,[1..30],gap.Size,[(3)^i for i in range(2,5)],gap.IsPrimitive,gap.false)
L = list(L)
print "List of size ",len(L)
Q = divide_lists(L,500)
#print "a"
#print LL
#print Q
#for X in Q:
#    LL = [PermutationGroup(gap.Elements(G)) for G in X]
#    test_groups(LL,X)
#print L[0]
