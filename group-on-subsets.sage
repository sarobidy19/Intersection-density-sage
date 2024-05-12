def label_three_subsets(n):
    L = Combinations([1..n],3)
    D = dict()
    i = 1
    for x in L:
        D[tuple(x)] = i
        i += 1
    return D,L


def action_of_element_as_permutation_on_three_subsets(f,T):
    u = (f(T[0]),f(T[1]),f(T[2]))
    return sorted(u)


def group_acting_on_three_subsets(G):
    PermGens = []
    n = G.degree()
    S = G.gens()
    K = label_three_subsets(n)
    L = K[1]
    D = K[0]
    for g in S:
        N = [0]*binomial(n,3)
        for x in L:
            i = D[tuple(x)]
            j = D[tuple(action_of_element_as_permutation_on_three_subsets(g,x))]
            N[i-1] = j
        PermGens.append(Permutation(N))
    return PermutationGroup(PermGens)

def label_subsets(n,k):
    L = Combinations([1..n],k)
    D = dict()
    i = 1
    for x in L:
        D[tuple(x)] = i
        i += 1
    return D,L


def action_of_element_as_permutation_on_subsets(k,f,T):
    u = tuple([f(T[i]) for i in [0..k-1]])
    return sorted(u)


def group_acting_on_subsets(G,k):
    PermGens = []
    n = G.degree()
    S = G.gens()
    K = label_subsets(n,k)
    L = K[1]
    D = K[0]
    for g in S:
        N = [0]*binomial(n,k)
        for x in L:
            i = D[tuple(x)]
            j = D[tuple(action_of_element_as_permutation_on_subsets(k,g,x))]
            N[i-1] = j
        PermGens.append(Permutation(N))
    return PermutationGroup(PermGens)

def group_acting_on_subsets_with_labels(n,k):
    PermGens = []
    G = SymmetricGroup(n)
    CC = G.conjugacy_classes_representatives()
    S = G.gens()
    K = label_subsets(n,k)
    L = K[1]
    D = K[0]
    Labels = []
    for g in S:
        N = [0]*binomial(n,k)
        for x in L:
            i = D[tuple(x)]
            j = D[tuple(action_of_element_as_permutation_on_subsets(k,g,x))]
            N[i-1] = j
        PermGens.append(Permutation(N))
    for g in CC:
        N = [0]*binomial(n,k)
        for x in L:
            i = D[tuple(x)]
            j = D[tuple(action_of_element_as_permutation_on_subsets(k,g,x))]
            N[i-1] = j
        Labels.append((g,Permutation(N).cycle_type()))
    P = Partitions(k)
    for x in Labels:
        if is_Derangement(x[0],P):
            print(x[0].cycle_type(),"<------------------>", x[1])
    return PermutationGroup(PermGens)

def is_Derangement(x,P): #input a permutation x and a set P of all partitions of the integer 3 (consisting of)
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
