#!/usr/local/bin/sage

f = open("ha.g6","r") #r:= read
L = f.readlines()
Graphs = []
for w in L:
    Graphs.append(Graph(w))
f.close()

def integral_test(L):
    a = True
    for i in L:
        if i.is_integer() == False:
            return False
        else:
            pass
    return a


#G = Graphs[0]
for G in Graphs:
    print "\n"
    L = G.laplacian_matrix()
    E = L.eigenvalues()
    if integral_test(E) == True:
        print "Eigenvalues of the Laplacian",E
        P = L.eigenmatrix_right()[1]
        print "transpose\n",P.transpose()*P
