class permutation_group(sage.groups.perm_gps.permgroup_named.PermutationGroup_generic):
	def number_of_derangements(self):
	    D = find_derangement_classes_representatives(self)
	    Der = []
	    for x in D:
	        Der += self.conjugacy_class(x).list()
	    return len(Der)
	def action_on_subsets(self,k):
	    PermGens = []
	    n = self.degree()
	    S = self.gens_small()
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
	def eigenvalues_group_with_all_dim(self):
	     IRR = self.irreducible_characters()
	     derangement_conjugacy_classes_representatives = []
	     eigenvalues = []
	     CC = self.conjugacy_classes_representatives()
	     for x in CC:
	         if is_derangement(x) == True:
	             derangement_conjugacy_classes_representatives.append(x)
	     for phi in IRR:
	         s = 0
	         for x in derangement_conjugacy_classes_representatives:
	             s += (1/phi.degree()) * ( self.conjugacy_class(x).cardinality()*phi(x) )
	         eigenvalues.append((s,phi.degree()^2))
	     Eigenvalues = []
	     eigenvalue_set = list(set(eigenvalues_group(self)[0]))
	     for x in eigenvalue_set:
	         N = []
	         for y in eigenvalues:
	             if x == y[0]:
	                 N.append(y[1])
	             else:
	                 pass
	         Eigenvalues.append((x,sum(N)))

	     return Eigenvalues
	def der_graph(self):
		CC = self.conjugacy_classes_representatives()
		D = []
		for x in CC:
			if is_derangement(x) == True:
				D += self.conjugacy_class(x).list()
		return Graph(self.cayley_graph(generators = D))
	def ratio_bound(self):
		K = self.eigenvalues_group()
		return self.order()/(1 - K[2]/K[1])
	def eigenvalues_group(self):
	    IRR = self.irreducible_characters()
	    derangement_conjugacy_classes_representatives = []
	    eigenvalues = []
	    CC = self.conjugacy_classes_representatives()
	    for x in CC:
	        if is_derangement(x) == True:
	            derangement_conjugacy_classes_representatives.append(x)
	    for phi in IRR:
	        s = 0
	        for x in derangement_conjugacy_classes_representatives:
	            s += (1/phi.degree()) * ( self.conjugacy_class(x).cardinality()*phi(x) )
	        eigenvalues.append(s)
	    return sorted(list(set(eigenvalues))),gap.Minimum(eigenvalues),gap.Maximum(eigenvalues)

	def is_join(self): #Test whether the derangement graph is a join or not
	     Ev = self.eigenvalues_group()
	     return -Ev[1] + Ev[2] == self.order()
	def has_regular_subgroup(self,description=False):
		M = self.conjugacy_classes_subgroups()
		if description == False:
			for x in M:
				if x.is_regular() == True:
					return True
				else:
					pass
			return False
		else:
			key = False 
			for x in M:
				if x.is_regular() == True:
					print(x.structure_description())
					key = True
				else:
					pass
			if key == False:
				return False 
	def stab_union(self):
		H = []
		for i in self.domain():
			H += self.stabilizer(i).list()
		K = set(H)
		U = PermutationGroup(list(K))
		return PermutationGroup(U.gens_small())
	def sort_derangement_conjugacy_classes_by_normalizers(self):
	    CC = find_derangement_classes_representatives(self)
	    L = []
	    M = []
	    Test = CC
	    while len(Test) >0:
	        i = 0
	        g = Test[i]
	        h = g.inverse()
	        if len(Permutation(g).fixed_points()) == 0:
	            for j in range(len(Test)):
	                T = list(self.conjugacy_class(Test[j]))
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
	def gurobi_code(self,CC,name):
	       Irr = self.irreducible_characters()
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

	def rank_of_group(self):
		return len(self.stabilizer(1).orbits())

	def group_action(self,H):
		X = self.cosets(H,side = 'left')
		d = ZZ(self.order()/H.order())
		transversal = [x[0] for x in X]
		dic = dict()
		for i in [1..d]:
			dic[i] = transversal[i-1]
		#action = lambda g,x: g*x[0]
		index_of_element = lambda x: list(dic.keys())[list(dic.values()).index(x)]
		action_on_transversal = lambda g,x,y: y if y.inverse()*g*x in H else ZZ(1) #x and y are elements of a transversal 
		gens = self.gens_small()
		generators_as_permutations = []
		for g in gens:
			N = [0]*d
			for x in transversal:
				i = index_of_element(x)
				for y in transversal:
					if action_on_transversal(g,x,y) != 1: # there is a bug that makes the identity element of the group and 0 (and False) equal. 
						j = index_of_element(y)
						N[i-1] = j
			generators_as_permutations.append(PermutationGroupElement(N))
		return PermutationGroup(generators_as_permutations)



