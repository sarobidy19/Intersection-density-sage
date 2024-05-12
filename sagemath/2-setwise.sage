#!/usr/local/bin/sage

#To run this code, run the command chmod +x three-setwise.sage in the terminal. Then run the command ./three-setwise.sage n key


import sys

def is_derangement(x,P): #input a permutation x and a set P of all partitions of the integer 3 (consisting of)
    u = Permutation(x).cycle_type()
    for y in P:
        if is_submultiset(y,u) == True:
            return False
    return True

def is_submultiset(A,B): #Checks whether A is a submultiset of B
    B = list(B)
    n = len(A)
    a = True
    i = 0
    while i<n and a == True:
        u = A[i]
        if u in B:
            B.remove(u)
        else:
            a = False
        i += 1
    return a

def VA(m):  #initialize the variables that are used in the weightings on the conjugacy classes of Sym(n)
      t = ''
      for i in range(m):
          if i == m-1:
              t += 'X{0}'.format(i)
          else:
              t += 'X{0},'.format(i)
      return var(t)


# n = argument of Sym(n), k = 3, L = a set of conjugacy classes (as partitions of n), M = a set of partitions of n whose corresponding eigenvalue is -1.
#This function checks whether there is a solution to the system of linear equation of conjugacy classes in L and irreducible characters in M.

def weights(n,k,L,M):
    P = Partitions(k)
    G = SymmetricGroup(n)
    l,m = len(L),len(M)   #L = conjugacy class and M irreducible characters
    #print l,m
    V = VA(m)
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
    print "--------------------------------------------------------------------------------------------------"
    for chi in char:
        phi = chi#.to_character()
        t = 0
        for i in range(m):
            t += V[i]*phi(CC_size[i][1]).trace()*CC_size[i][0]
            print chi,V[i],phi(CC_size[i][1]).trace(),CC_size[i][1].cycle_type()
        if phi == SymmetricGroupRepresentation([n]):
            Eq.append(t == binomial(n,k) -1)  #The maximum eigenvalue is set to be C(n,k) - 1
        else:
            Eq.append(t == -phi(G[0]).trace())  #The eigenvalue corresponding to phi is set to be equal to -1
        print "---------------------------------------------------------------------------------------------------"
    solutions = solve(Eq,V)
    print "\n","Weight possible?", len(solutions) != 0,"\n"
    if len(solutions) == 0:
        return sys.exit()
##################################################################
    derangement_conjugacy_classes_representatives = []
    CC = G.conjugacy_classes_representatives()
    for x in CC:
        if is_derangement(x,P) == True:
            derangement_conjugacy_classes_representatives.append(x)
    Q = derangement_conjugacy_classes_representatives
    #print len(Q)
    W = [0]*len(Q)
    for i in range(len(Q)):
        u = Q[i].cycle_type()
        #print u
        for j in range(m):
            if u == Partition(L[j]):
                W[i] = solutions[0][j].rhs()
    print "System of linear equations","\n"
    for x in Eq:
        print x
    print "------------------------------------------------------------------------------------------------","\n"
    print "Weights"
    for x in solutions[0]:
        print x
    print "------------------------------------------------------------------------------------------------","\n"
    return [solutions[0][i].rhs() for i in range(len(solutions[0]))],W #W is the appropriate wgenvalues_weightshtings for the conjugacy classes of derangements


# This function takes a weighting W of the conjugacy classes of derangements and produces eigenvalues of the corresponding weighted spanning subgraph.
# The argument W is the weights of the conjugacy classes of derangements
# key is an option to print the eigenvalues during the computation

def eigenvalues_weights(n,k,W,key):
    print "Computing the eigenvalues ...",'\n',"this might take a few minutes",'\n'

    P = Partitions(k)
    eigenvalues = []
    G = SymmetricGroup(n)
    derangement_conjugacy_classes_representatives = []
    CC = G.conjugacy_classes_representatives()
    for x in CC:
        if is_derangement(x,P) == True:
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
        if key == 'true':
            print s
        elif key == 'false':
            pass
        else:
            print "Stoped! Set key = true or key = false"
            return sys.exit()

    print "Eigenvalues","\n"
    print len(eigenvalues)
    if n in  [9,11]:
        A,B,C,D = [eigenvalues[i] for i in [0,1,2,3]]
        var('r1,r2')
        new_solutions = solve([A>=-1,B>=-1,C>=-1,D >=-1],r1,r2)[5]
        a = new_solutions[2].lhs()
        b = new_solutions[3].rhs()
        A = (a+b)/2
        c = new_solutions[0].lhs().substitute(r2 = A)
        d = new_solutions[1].rhs().substitute(r2 = A)
        B = (c+d)/2
        final_eigenvalues = []
        for x in eigenvalues:
            final_eigenvalues.append(x.substitute(r1 = B,r2 = A))
        print "Eigenvalues for a particular weighting",'\n',final_eigenvalues,'\n'
        print 'The largest eigenvalue is ',max(final_eigenvalues),'\n'
        print 'The least eigenvalue is ',min(final_eigenvalues),'\n'
        print "--------------------------------------------------",'\n','The general eigenvalues are','\n'
    elif n in [6,8,10]:
        A,B,C,D = [eigenvalues[i] for i in [0,1,2,3]]
        var('r1,r2')
        new_solutions = solve([A>=-1,B>=-1,C>=-1,D >=-1],r1,r2)[0]
        a = new_solutions[2].lhs()
        b = new_solutions[3].rhs()
        A = (a+b)/2
        c = new_solutions[0].lhs().substitute(r2 = A)
        d = new_solutions[1].rhs().substitute(r2 = A)
        B = (c+d)/2
        final_eigenvalues = []
        for x in eigenvalues:
            final_eigenvalues.append(x.substitute(r1 = B,r2 = A))
        print "Eigenvalues for a particular weighting",'\n',final_eigenvalues,'\n'
        print 'The largest eigenvalue is ',max(final_eigenvalues),'\n'
        print 'The least eigenvalue is ',min(final_eigenvalues),'\n'
        print "--------------------------------------------------",'\n','The general eigenvalues are','\n'
    if n in  [7]:
        A,B,C,D = [eigenvalues[i] for i in [0,1,2,3]]
        var('r1,r2')
        new_solutions = solve([A>=-1,B>=-1,C>=-1,D >=-1],r1,r2)[-1]
        a = new_solutions[2].lhs()
        b = new_solutions[3].rhs()
        A = (a+b)/2
        c = new_solutions[0].lhs().substitute(r2 = A)
        d = new_solutions[1].rhs().substitute(r2 = A)
        B = (c+d)/2
        final_eigenvalues = []
        for x in eigenvalues:
            final_eigenvalues.append(x.substitute(r1 = B,r2 = A))
        print "Eigenvalues for a particular weighting",'\n',final_eigenvalues,'\n'
        print 'The largest eigenvalue is ',max(final_eigenvalues),'\n'
        print 'The least eigenvalue is ',min(final_eigenvalues),'\n'
        print "--------------------------------------------------",'\n','The general eigenvalues are','\n'

    return eigenvalues

def is_derangement_on_point(x):
     if len(Permutation(x).fixed_points()) == 0:
         return True
     else:
         return False

def der_graph(G):
    CC = G.conjugacy_classes_representatives()
    D = []
    for x in CC:
        if is_derangement_on_point(x) == True:
            D += G.conjugacy_class(x).list()
    return Graph(G.cayley_graph(generators = D))

#######################
n = int(sys.argv[1])
key = sys.argv[2] # true or false
k = 2
G = SymmetricGroup(n)
#######################

if n in [3,4,5,6]:
    X = graphs.KneserGraph(n,2)
    X.relabel([1..X.order()])
    G = X.automorphism_group()
    if n == 4:
        T = G.conjugacy_classes_subgroups()
        G = T[29]
    X = der_graph(G)
    print "The largest intersecting families of Sym({0}) acting on the 2-subsets have size".format(n),X.independent_set(value_only = True)
    Y = X.complement()
    M = Y.cliques_maximum()
    print "Are there maximum non-canonically intersecting families?",len(M)!= G.degree()^2

if n>=7:
    W = weights(n,k,[[n],[n-1,1],[n-3,3],[n-4,3,1]],[[n],[n-1,1],[n-2,2],[n-1,1]])
    L =  eigenvalues_weights(n,k,W[1],key)
    print L
