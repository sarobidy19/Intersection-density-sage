#!/usr/local/bin/sage

def eigenvalues_cycles(n,k):
     G = SymmetricGroup(n)
     CC = G.conjugacy_classes_representatives()
     for x in CC:
         if x.cycle_type()[0] == n-k and x.cycle_type()[1] <= 1:
             y = x
             break
     print y.cycle_type()
     Irr = G.irreducible_characters()
     Ev = []
     for phi in Irr:
         s = phi(y)/phi(G[0])*len(G.conjugacy_class(y))
         Ev.append(s)
     return Ev

def eigenvalues_cycles_with_multiplicities(n,k):
     G = SymmetricGroup(n)
     CC = G.conjugacy_classes_representatives()
     for x in CC:
         if x.cycle_type()[0] == n-k and x.cycle_type()[1] <= 1:
             y = x
             break
     print y.cycle_type()
     Irr = G.irreducible_characters()
     Ev = []
     for phi in Irr:
         s = phi(y)/phi(G[0])*len(G.conjugacy_class(y))
         Ev.append((s,phi.degree()^2))

     Eigenvalues = []
     eigenvalue_set = list(set(eigenvalues_cycles(n,k)))
     for x in eigenvalue_set:
        N = []
        for y in Ev:
            if x == y[0]:
                N.append(y[1])
            else:
                pass
        Eigenvalues.append((x,sum(N)))
     return Eigenvalues

def second_largest(n,k):
    Ev = eigenvalues_cycles(n,k)
    k = Ev[len(Ev)-2]
    Ev.pop(-1)
    Ev.pop(0)
    M = gap.Maximum(Ev)
    return M,k

def grap_cycle(n,k):
    G = SymmetricGroup(n)
    X = Graph()
    X.add_vertices(G.list())
    C = Combinations(X.vertices(),2)
    for x in C:
        if x[0] != x[1] and Permutation(x[0]*x[1].inverse()).cycle_type() == [k]+[1]*(n-k):
            X.add_edge((x[0],x[1]))
    return X

def eigenvalues_cycles_ratio(n,k):
     G = SymmetricGroup(n)
     CC = G.conjugacy_classes_representatives()
     for x in G:
         if x.cycle_type()[0] == k and x.cycle_type()[1] <= 1:
             y = x
             break
     print y.cycle_type()
     Irr = G.irreducible_characters()
     Ev = []
     for phi in Irr:
         s = phi(y)/phi(G[0])
         Ev.append(s)
     return Ev
