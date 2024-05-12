def get_transversal(G,H):
    C = G.cosets(H)
    T = []
    for x in C:
        T.append(x[0])
    return T

def label_cosets(C):
    D = dict()
    #C = G.cosets(H)
    i = 1
    for x in C:
        D[x] = i
        i += 1
    return D

def action_on_cosets(g,x,C,H):
    u = x*g
    for v in C:
        if u*v.inverse() in H:
            break
    return v

def group_action_on_cosets(G,H):
    C = get_transversal(G,H)

    L = label_cosets(C)
    Ggens = list(G.gens())
    PermGrp = []
    for g in Ggens:
        N = [0]*(len(L))
        for x in C:
            i = L[x]
            j = L[action_on_cosets(g,x,C,H)]
            N[i-1] = j
        PermGrp.append(Permutation(N))
    return PermutationGroup(PermGrp) 

def group_action_on_cosets_intransitive(G,H,K):
    C = get_transversal(G,H)

    L = label_cosets(C)
    Ggens = list(K.gens())
    PermGrp = []
    for g in Ggens:
        N = [0]*(len(L))
        for x in C:
            i = L[x]
            j = L[action_on_cosets(g,x,C,H)]
            N[i-1] = j
        PermGrp.append(Permutation(N))
    return PermutationGroup(PermGrp) 