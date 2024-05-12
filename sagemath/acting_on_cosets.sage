#!/usr/local/bin/sage

def is_derangement(x,B):
    #print B
    for i in range(len(B)):
        print B[i]
        if x(B[i]) == B[i]:
            return False
        else:
            pass
    return True

def cosets(G,H):
    return G.cosets(H)

def derangement_graph(G,H):
    D = []
    Der = []
    B = cosets(G,H)
    CC = G.conjugacy_classes_representatives()
    for x in CC:
        if is_derangement(x,B) == True:
            D.append(x)
        else:
            pass
    for x in D:
        Der += G.conjugacy_class(x).list()
    print "k"
    return Graph(G.cayley_graph(generators = Der))

G = SymmetricGroup(6)
H = PermutationGroup(['(1,3,4)(5,6)', '(1,2)(3,4)'])
print H.is_subgroup(G)
print H.domain()
X = derangement_graph(G,H)
print X.independent_set(value_only = True)
