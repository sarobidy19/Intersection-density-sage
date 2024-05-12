def intersecting(x,y):
    for i in range(1,n+1):
         if x(i) == y(i):
             return True
    return False

"""def set_intersecting(F):
     for x in F:
         for y in F:
             if intersecting(x,y) == True:
                 pass
             else:
                 print x,y
                 return False
     return True"""

def regularity(G,F):
    N = []
    n = len(G.domain())
    for i in range(1,n+1):
        for j in range(1,n+1):
            M = []
            for x in F:
                if x(i) == j:
                    M.append(x)
            N.append((i,j,len(M)))
            print ((i,j,len(M)))
    #return N

def intersecting(G,F):
     n = len(G.domain())
     for x in F:
         for y in F:
             a = 'intersecting'
             for i in range(1,n+1):
                 if x(i) == y(i):
                     a = 'intersecting'
                     #print x,y,i
                     break
                 else:
                     a = 'not-intersecting'
                     pass
             if a == 'intersecting':
                 pass
             else:
                 #print (x,y)
                 return False
     return True

for G in Groups:
     print gap.StructureDescription(G)
     C = G.conjugacy_classes()
     F = []
     for i in range(len(C)):
        a = intersecting(G,C[i])
        print a,i
        if a == True:
            F += C[i].list()
     print "Symmetric Intersecting"
     print regularity(G,F)
     print "-------------------------------"
