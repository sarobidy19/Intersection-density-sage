#!/usr/local/bin/sage

import sys,random

"""def intersecting(L):
     for i in range(len(L)):
         for j in range(len(L)):
             a = 'intersecting'

             for k in range(1,n+1):
                 if L[i](k) == L[j](k):
                     a = 'intersecting'
                     print k,
                     print L[i],L[j]
                     break
                 else:
                     print L[i](k),L[j](k)
                     a = 'not-intersecting'
             print (L[i],L[j])
             return False
     return True"""

def intersecting_family(F):
    for i in range(len(F)):
        for j in range(len(F)):
            print F[i],F[j]
            if intersecting(F[i],F[j]) == True:
                pass
            else:
                print F[i],F[j]
                return False
    return "The family is intersecting!!!"

def intersecting(x,y):
     for i in range(1,n+1):
         if x(i) == y(i):
             return True
     return False

def is_regular(F):
    N = []
    print len(F)
    for u in range(5):
        M = []
        i = random.choice(range(1,n+1))
        j = random.choice(range(1,n+1))
        for x in F:
            if x(i) == j:
                M.append(x)
        N.append([len(M),i,j])
    return N

n = int(sys.argv[1])

G = SymmetricGroup(n)
C = G.conjugacy_class([floor((n+1)/2)]+[1]*(n-floor((n+1)/2)))
print C
print is_regular(C)
