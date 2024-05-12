#!/usr/local/bin/sage

#contains all functions

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
    return eigenvalues

def derangement_graph(G):
    D = get_derangements(G)
    X = G.cayley_graph(generators = D)
    X = Graph(X)
    return X

def test_graphs(L):
    for i in range(len(L)):
        X = L[i]
        X.relabel()
        G = X.automorphism_group()
        Y = derangement_graph(G)
        independent_number = Y.independent_set(value_only = True)
        #clique_number = Y.clique_number()
        eigenvalues = list(eigenvalues_group(G))
        print "-----------------------------"
        print "\t No",int(i+1)
        print "\n Independence number = ",independent_number, "\n stabilizer = ",G.stabilizer(1).order(),"\n transitive", X.is_vertex_transitive()#,"\n clique-coclique =", float(G.order()/clique_number)
        print " EKR",G.stabilizer(1).order() == independent_number
    print "-----------------------------"

def test_groups(L):
    for i in range(len(L)):
        G = L[i]
        Y = derangement_graph(G)
        independent_number = Y.independent_set(value_only = True)
        #clique_number = Y.clique_number()
        eigenvalues = list(eigenvalues_group(G))
        print "-----------------------------"
        print "\t No",int(i+1)
        print "\n Independence number = ",independent_number, "\n stabilizer = ",G.stabilizer(1).order(),
        print " EKR",G.stabilizer(1).order() == independent_number
        print "eigenvalues",eigenvalues
    print "-----------------------------"

#print derangement_graph(SymmetricGroup(5))
