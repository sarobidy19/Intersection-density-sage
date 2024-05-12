#!/usr/local/bin/sage

def test(G,Z,x,k):
    C = Combinations(Z,k-1)
    for y in C:
        X = y + [x]
        if intersecting_on_points(G,X) == True:
            pass
        else:
            return False
    return True

def intersecting_on_points(G,L):
    main_key = False
    for i in G.domain():
        N = []
        for x in L:
            N.append(x(i))
        key = True
        a = N[0]
        for x in N:
            if x != a:
                key = False
                break
            else:
                pass
        if key == True:
            return key
        else:
            pass
    return main_key
"""
C = Combinations(D,5)
sage: for x in C:
....:     print "----------------------------------------------------"
....:     print x
....:     Z = Combinations(x,3)
....:     a = True
....:     for y in Z:
....:         if intersecting_on_points(G,y) == True:
....:              pass
....:         else:
....:             a = False
....:             break
....:     if a == True:
....:         H = PermutationGroup(shifted(x))
....:         if len(H.fixed_points()) == 0 and H.is_subgroup(G.stabilizer(5)) == False:
....:             R = x
....:             break
....:     else:
....:         pass
....:     print "----------------------------------------------------"
....:


"""
