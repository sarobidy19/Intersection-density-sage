#!/usr/local/bin/sage

import group_vs_der
import numpy as np
#import graph_list
from sage.groups.group import is_Group

def circulant_graph(G,Gen):
    #G = CyclicPermutationGroup(n)
    G0 = list(G)
    G0.pop(0)
    #print G0
    #Gens = np.random.choice(G0,2)#[G[5],G[5].inverse(),G[4],G[4].inverse()]
    print "Cay gens",Gen
    X = G.cayley_graph(generators = list(Gen))
    X.relabel()
    G = X.automorphism_group()
    Gens = group_vs_der.get_derangements(G)
    #print Gens
    X = G.cayley_graph(generators = [i for i in Gens])
    X = Graph(X)
    Y = X.complement()
    Y = Graph(Y)
    L = Y.cliques_maximum()
    #g = X.plot()
    #g.show(layout = 'circular')
    #g.save("Bidy.png")
    return L,len(Y.edges()),Y.order()

def max_clq(L):
    for X in L[0]:
        x = X[0]
        S = [y*x.inverse() for y in X]
        #s = S[0]*S[0].inverse()
        #for i in S:
        #    s = s*i
        #print s
        if L[1] != 0: #s != x.inverse()*x:
           if PermutationGroup(S).order() != len(S): #test whether S is a group or not
              print S
           print "size", L[2]

def test():
    G = graphs.CycleGraph(4).disjoint_union(graphs.CycleGraph(4))
    G.relabel()
    A = G.automorphism_group()
    D = group_vs_der.get_derangements(A)
    #print D
    X = A.cayley_graph(generators = D)
    X = Graph(X)
    print X.is_connected()
    Y = X.complement()
    Max = Y.cliques_maximum()
    #print A.order(),len(X.edges())-binomial(A.order(),2),len(Max)
    for S in Max:
        s = S[0]
        P = [i*s.inverse() for i in S]
        if PermutationGroup(P).order() != len(P):
            print P
def get_derangements(A):
    return filter(is_derangement,A)
def is_derangement(x):
    for i in A.domain():
        if x(i) == i:
            return False
        else:
            pass
    return True

G = graphs.TutteCoxeterGraph()
G.relabel()
A = G.automorphism_group()

def test1():
    G = graphs.TutteCoxeterGraph()
    G.relabel()
    A = G.automorphism_group()
    #A = PermutationGroup(['(3,4)', '(2,3)(4,5)', '(1,2)(5,6)'])
    D = get_derangements(A)
    X = A.cayley_graph(generators = D)
    X = Graph(X)
    #A = X.adjacency_matrix()
    #E = X.eigenspaces()
    #print X.eigenspaces()
    print X.independent_set(value_only=True),A.stabilizer(1).order(),A.is_transitive(),X.clique_number()#,X.chromatic_number()##,X.order()/X.clique_number()#,float(X.order()/(1-(max(E)/min(E))))
    B = X.independent_set()
    C = []
    y = B[0].inverse()
    for x in B:
        C.append(y*x)
    f = open("coclique1.txt","w+")
    f.write('{0}'.format(C))
    f.close()
    #for x in G.vertices():
    #    print len(set(A.stabilizer(x)).intersection(set(C)))
    #print set(A.stabilizer(1))
    #print C
    return C
def test2():
    L = graph_list()
    for G in L:
        G.relabel()
        A = G.automorphism_group()
        #A = PermutationGroup(['(3,4)', '(2,3)(4,5)', '(1,2)(5,6)'])
        D = group_vs_der.get_derangements(A)
        X = A.cayley_graph(generators = D)
        X = Graph(X)
        #E = X.eigenspaces()
        #print E
        print X.independent_set(value_only=True),A.stabilizer(1).order(),A.is_transitive()#,X.chromatic_number()#G.clique_number()#,X.order()/X.clique_number()#,float(X.order()/(1-(max(E)/min(E))))


def main():
    G = CyclicPermutationGroup(8)
    G0 = list(G)
    G0.pop(0)
    i = 0
    for A in Subsets(G0,2):
        i += 1
        print i
        A = list(A)
        if A[0]*A[1] == A[0].inverse()*A[0]:
            L = circulant_graph(G,A)
            max_clq(L)

def main1():
    G = graph.CycleGraph(6).disjoint_union(graphs.CycleGraph(6))
    A = G.automorphism_group()
    X = A.cayley_graph(generators = get_derangements(A))
    Max = X.cliques_maximum()
    print A.order(),len(Max)
    for S in Max:
        s = S[0]
        P = [i*s.inverse() for i in S]
        if PermutationGroup(P).order() != len(P):
            print P

def graph_list():
        #LstJG = []
        #for i in range(1,10):
        #    for j in range(2,9):
        #        LstJG.append(graphs.JohnsonGraph(i,j))
        G = graphs.TutteCoxeterGraph()
        LstCommonGraphs = [G]#[graphs.RobertsonGraph(),graphs.NauruGraph(),graphs.MoebiusKantorGraph(),graphs.F26AGraph(),graphs.DyckGraph()]#[graphs.PappusGraph(),graphs.HeawoodGraph(),graphs.CoxeterGraph(),graphs.TutteCoxeterGraph(),graphs.DodecahedralGraph(),graphs.DesarguesGraph(),graphs.BiggsSmithGraph(),graphs.FosterGraph(),graphs.HoffmanSingletonGraph()]
        return LstCommonGraphs



#main()
#test1()
#X = graphs.CycleGraph(6).disjoint_union(graphs.CycleGraph(6))


#G = X.automorphism_group()
#L = circulant_graph(G,)
