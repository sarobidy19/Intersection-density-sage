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
    return list(set(L))+M


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
          if phi.values() == [1]*len(G.conjugacy_classes()):
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
      print "Done"
      return Labels

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
               if phi.values() == [1]*len(G.conjugacy_classes()):
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
       print "Done"
       return Labels
