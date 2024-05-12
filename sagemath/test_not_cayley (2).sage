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

def test_graph6():
    L = graph6_to_list()
    LL = [Graph(L[i]) for i in range(len(L))]
    f = open("output_graph6.txt","w+")
    for i in range(len(LL)):
        X = LL[i]
        X.relabel()
        G = X.automorphism_group()
        Y = derangement_graph(G)
        independent_number = Y.independent_set(value_only = True)
        #clique_number = Y.clique_number()
        evalue_multiplicity = eigenvalues_group_and_multi(G)
        eigenvalues = list(evalue_multiplicity[0])
        multiplicity = list(evalue_multiplicity[1])
        evalue_min_max = eigenvalues_group(G)
        print "\t No",int(i+1)
        print "\n group =",gap.StructureDescription(G)
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
        f.write("----------------------------------------------------------------------------- \n \t No {0}\n group = {1}\n Size = {2}\n Domain = {6} \n EKR {3}\n eigenvalues = {4}\n multiplicity = {7} \n Blocks = {5}\n \n----------------------------------------------------------------------------- \n".format(int(i+1),gap.StructureDescription(G),G.order(),G.stabilizer(1).order() == independent_number,eigenvalues,G.blocks_all(),G.domain(),multiplicity))
    print "----------------------------------------------------------"
    f.close()


        #print "-----------------------------+"
        #print "\n Independence number = ",independent_number, "\n stabilizer = ",G.stabilizer(1).order(),"\n transitive", X.is_vertex_transitive()#,"\n clique-coclique =", float(G.order()/clique_number)
        #print "ratio bound = ",ratio_bound(G)
        #return eigenvalues

def graph6_to_list():
    L = [10,15,16,18,20,24,26,28,30]
    print L
    LL = []
    for i in range(len(L)):
        f = open("noncay{0}.g6".format(L[i]),"r")
        LL += f.readlines()
        f.close()
    LLL = []
    for i in range(len(LL)):
        LLL.append(LL[i].replace("\n",""))
    return LLL

#test_graph6()
print len(graph6_to_list())
