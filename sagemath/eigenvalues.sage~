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
def is_derangement(G,x):
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
    X = G.cayley_graph(generators = get_derangements(G))
    return Graph(X)

def min_list(L):
    t = L[0]
    for j in range(len(L)):
        print L[j],t,t-L[j]<0
        if t-L[j]<0:
            t = L[j]
        else:
            pass
        #print t
    print "t_min=",t
    return t

def max_list(L):
    s = L[0]
    for i in L:
        if i>s:
            s = i
    return s

def test_graph(X):
    X.relabel()
    G = X.automorphism_group()
    Y = derangement_graph(G)
    independent_number = Y.independent_set(value_only = True)
    #clique_number = Y.clique_number()
    eigenvalues = list(eigenvalues_group(G))
    print "-----------------------------+"
    print "\n Independence number = ",independent_number, "\n stabilizer = ",G.stabilizer(1).order(),"\n transitive", X.is_vertex_transitive()#,"\n clique-coclique =", float(G.order()/clique_number)
    #print "ratio bound = ",ratio_bound(G)
    #return eigenvalues

#def ratio_bound(G):
#    eigenvalues = eigenvalues_group(G)
#    A = eigenvalues
  #  return float(G.order()/(1 - (max(A)/(min(A)))))
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
#LL = [graphs.TutteCoxeterGraph(),graphs.CoxeterGraph(),graphs.HeawoodGraph(),graphs.DodecahedralGraph(),graphs.BiggsSmithGraph(),graphs.NauruGraph(),graphs.MoebiusKantorGraph(),graphs.CompleteBipartiteGraph(3,3),graphs.DesarguesGraph()]
#test_graphs(LL)
#test_graph(graphs.SylvesterGraph())
