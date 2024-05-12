def sort_derangement_conjugacy_classes(G):
    CC = G.conjugacy_classes_representatives()
    L = []
    M = []
    for i in range(len(CC)):
        g = CC[i]
        h = g.inverse()
        if len(Permutation(g).fixed_points()) == 0:
            for j in range(len(CC)):
                if h in G.conjugacy_class(CC[j]) and i != j:
                    L.append((CC[i],CC[j]))
                elif  h in G.conjugacy_class(CC[j]) and i == j:
                    M.append([CC[i]])
    return list(set(L))+M

def sort_derangement_conjugacy_classes_by_normalizers(G):
    CC = find_derangement_classes_representatives(G)
    L = []
    M = []
    Test = CC
    while len(Test) >0:
        i = 0
        g = Test[i]
        h = g.inverse()
        if len(Permutation(g).fixed_points()) == 0:
            #N = G.normalizer(h)
            for j in range(len(Test)):
                T = list(G.conjugacy_class(Test[j]))
                if h in T and i != j:
                    L.append((g,CC[j]))
                    Test.pop(j);
                    Test.pop(i); #larger and the smaller
                    break
                elif  h in T and i == j:
                    M.append([g])
                    if len(Test) == 0:
                        pass
                    else:
                        Test.pop(j);
                    break
    return list(set(L))+M


""" 
def sort_derangement_conjugacy_classes_by_normalizers(G):
    CC = find_derangement_classes_representatives(G)
    L = []
    M = []
    for i in range(len(CC)):
            g = CC[i]
            h = g.inverse()
            if len(Permutation(g).fixed_points()) == 0:
                #N = G.normalizer(h)
                for j in range(len(CC)):
                    T = list(G.conjugacy_class(CC[j]))
                    if h in T and i != j:
                        L.append((g,CC[j]))
                    elif  h in T and i == j:
                        M.append([g])
    return list(set(L))+M"""

def gurobi_code(G,CC,name):
      Irr = G.irreducible_characters()
      V = VA(len(CC))
      Non_triv = []
      Labels = []
      for i in range(len(CC)):
          Labels.append((V[i],Permutation(CC[i][0]).cycle_type()))
      for phi in Irr:
          s = 0
          for i in range(len(CC)):
              if len(CC[i]) == 2:
                  a = phi(CC[i][0])
                  s += 2*V[i]*ComplexNumber(real(a).n() ,0*imag(a).n())*len(G.conjugacy_class(CC[i][0]))
              elif len(CC[i]) == 1:
                  a = phi(CC[i][0])
                  s += V[i]*a*len(G.conjugacy_class(CC[i][0]))
          if list(phi.values()) == [1]*len(G.conjugacy_classes()):
              Triv = s/phi.degree()
              Non_triv.append(Triv >= -1)
          else:
              Non_triv.append(s/phi.degree() >= -1)
              Non_triv.append(s/phi.degree() <= (G.degree()-1))
      f = open("{0}.lp".format(name),"w+")
      f.writelines("Maximize \n \n")
      f.writelines("{0}\n".format(Triv))
      f.writelines("Subject To \n \n")
      for x in Non_triv:
          f.writelines("{0}\n".format(x))
      f.writelines("End")
      f.close()
      print("Done")
      return Labels

def gurobi_code(G,CC,name):
       Irr = G.irreducible_characters()
       if len(CC)>1:
            V = VA(len(CC))
       else:
            V = tuple([VA(1)])
       Non_triv = []
       Labels = []
       for i in range(len(CC)):
           Labels.append((V[i],CC[i]))
           #Labels.append((V[i],Permutation(CC[i][0]).cycle_type()))
       for phi in Irr:
           s = 0
           for i in range(len(CC)):
               if len(CC[i]) == 2:
                   a = phi(CC[i][0])
                   s += 2*V[i]*ComplexNumber(real(a).n() ,0*imag(a).n())*len(G.conjugacy_class(CC[i][0]))
                   #print s
               elif len(CC[i]) == 1:
                   b = CC[i][0]
                   a = phi(CC[i][0])
                   if b.inverse() == b:
                       s += V[i]*a*len(G.conjugacy_class(CC[i][0]))
                   else:
                       s += V[i]*ComplexNumber(real(a).n() ,0*imag(a).n())*len(G.conjugacy_class(CC[i][0]))
           #print s
           if s == 0:
               pass
           else:
               if list(phi.values()) == [1]*len(G.conjugacy_classes()):
                   Triv = s/phi.degree()
                   a = str(Triv >= -1)
                   a = a.replace("*"," ")
                   Non_triv.append(a)
                   b = str(Triv)
                   Triv = b.replace("*"," ")
               else:
                   c = str(s/phi.degree() >= -1)
                   b = str(s/phi.degree() <= (G.degree()-1))
                   c = c.replace("*"," ")
                   b = b.replace("*"," ")
                   Non_triv.append(c)
                   Non_triv.append(b)
       f = open("{0}.lp".format(name),"w+")
       f.writelines("Maximize \n \n")
       f.writelines("{0}\n".format(Triv))
       f.writelines("Subject To \n \n")
       for x in Non_triv:
           f.writelines("{0}\n".format(x))
       f.writelines("End")
       f.close()
       print("Done")
       return Labels


def find_maxi_ratio_bound(G):
    D = sort_derangement_conjugacy_classes_by_normalizers(G)
    L = gurobi_code(G,D,"test-more")
    model = gurobipy.read("test-more.lp")
    model.optimize()
    maxi = model.ObjVal
    return maxi

def arrange_conjugacy_classes_of_derangements_and_weights(G):
    D = sort_derangement_conjugacy_classes_by_normalizers(G)
    L = gurobi_code(G,D,"test-more")
    model = gurobipy.read("test-more.lp")
    model.optimize()
    C = []
    W = []
    for z in L:
        m = model.getVarByName("{0}".format(z[0]))
        W.append(m.getAttr('x'))
        C.append(z[1])
    return W,C

def eigenvalues_group_conjugacy_class_and_weights_gurobi(G):
    W,C = arrange_conjugacy_classes_of_derangements_and_weights(G)
    IRR = G.irreducible_characters()
    eigenvalues = []
    for phi in IRR:
        s = 0
        for i in [0..len(C)-1]:
            if len(C[i]) == 1:
                s += (1/phi.degree()) *ComplexNumber(W[i]) * ( G.conjugacy_class(C[i][0]).cardinality()*phi(C[i][0]) )
            else:
                s += (1/phi.degree()) *ComplexNumber(W[i]) * ( G.conjugacy_class(C[i][0]).cardinality()*(phi(C[i][0])+phi(C[i][1])) )
        eigenvalues.append([s,phi])
    return eigenvalues,W

def intersecting_subgroup_order(G,k):
    M = G.conjugacy_classes_subgroups()
    for x in M:
        if x.order() == k and intersecting(x,x):
            return True
        else:
            pass
    return False 

def intersecting_subgroup_order_evalues(G,k):
    if k == G.degree()-1:
        return True
    else:
        M = G.conjugacy_classes_subgroups()
        for x in M:
            if x.order() == k and len(eigenvalues_group_with_all_dim(x)) == 1:
                return True
            else:
                pass
        return False 


def intersection_spectrum(G):
    M = G.conjugacy_classes_subgroups()
    L,N = [],[]
    for  x in M:
        if x.order() not in [1,G.order()] and is_prime_power(ZZ(G.order()/x.order())) == False:
            K = group_action_on_cosets(G,x)
            T = eigenvalues_group_conjugacy_class_and_weights_gurobi(K)[0]
            if ceil(T[0][0]) > float(T[0][0]) and floor(T[0][0]) < float(T[0][0]) :
                m = ceil(T[0][0])
            else:
                m = float(T[0][0])
            n = K.order()/(m+1)
            N.append([m,K.degree(),x.structure_description()])
            if n.is_integer() and intersecting_subgroup_order(K,n) == True:
                L.append(K.degree()/(m+1))
    return L,N
