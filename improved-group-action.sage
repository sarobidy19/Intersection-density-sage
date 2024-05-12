#!/usr/local/sage


def find_representatives(G,H):
	C = G.cosets(H)
	return [x[0] for x in C]

def is_derangement_wrt_cosets(G,H,g):
	C = find_representatives(G,H)
	for x in C:
		if x*g*x.inverse() in H:
			return False
		else:
			pass
	return True

def find_conjugacy_classes_of_derangements(G,H):
	CC = G.conjugacy_classes_representatives()
	D = []
	for g in CC:
		if is_derangement_wrt_cosets(G,H,g) == True:
			D.append(g)
		else:
			pass
	return D

def pair_derangements(G,H):
	D = find_conjugacy_classes_of_derangements(G,H)
	Sym = []
	Asym = []
	while len(D)>0:
		i = 0
		g = D[i]
		h = g.inverse()
		if h in g.conjugacy_class():
			Sym.append([g])
			D.pop(i);
		else:
			for j in range(len(D)):
				z = D[j]
				if h in z.conjugacy_class():
					Asym.append([g,z])
					D.pop(j);
					D.pop(i); #It is important to remove the larger of the two first, otherwise the indices with shift
					break
	return Sym+Asym 

def index(G,H):
	return G.order()/H.order()

def rank_of_group(G):
	return len(G.stabilizer(1).orbits())

def pair_characters(G,irreducible_characters,a):
	# = G.irreducible_characters()
	Sym = []
	Asym = []
	Irr = irreducible_characters.copy()
	while len(Irr)>0:
		i = 0
		phi = Irr[0]
		for j in range(len(Irr)):
			psi = Irr[j]
			if j>i and psi(a) != phi(a.inverse()):
				Asym.append([phi,psi])
				Irr.pop(j);
				Irr.pop(i)
				break
			else:
				Sym.append([phi])
				Irr.pop(i)
				break
	return Sym + Asym#,irreducible_characters

def dictionary_of_characters(G,char):
	#Irr = G.irreducible_characters()
	D = dict()
	for i in range(len(char)):
		D[i] = char[i]
	return D

def theta_function(G,H,name):
	D = find_conjugacy_classes_of_derangements(G,H)
	Irr = G.irreducible_characters()
	V = VA(len(Irr))
	d = dictionary_of_characters(G,Irr)
	Triv = []
	Non_triv = []
	for i in range(len(D)):
		s = 0
		F = pair_characters(G,Irr,D[i])
		for f in F:
			if len(f) == 2:
				phi1,phi2 = f
				a,b = phi1(D[i]),phi2(D[i])
				s += (V[list(d.keys())[list(d.values()).index(phi1)]]*ComplexNumber(real(a).n() ,0*imag(a).n())*phi1.degree() + V[list(d.keys())[list(d.values()).index(phi2)]]*ComplexNumber(real(b).n() ,0*imag(a).n())*phi2.degree())
				#print (s)
			elif len(f) == 1:
				phi = f[0]
				if phi not in Irr:
					phi = phi.decompose()[0][1] #bug: the character sometimes is not a character after pairing
				a = phi(D[i])
				s += V[list(d.keys())[list(d.values()).index(phi)]]*ComplexNumber(real(a).n() ,0*imag(a).n())*phi.degree() # It might approximate it if this is not done, I don't know.
				#print (s)
		if s == 0:
			pass
		else:
			c = str(s == 0)
			c = c.replace("*"," ")
			c = c.replace("==","=")
			Non_triv.append(c)
	Triv = V[list(d.keys())[list(d.values()).index(G.trivial_character())]]
	t = 0
	for i in range(len(V)):
		phi = Irr[i]
		t += (phi.degree()^2).n()*V[list(d.keys())[list(d.values()).index(phi)]]
	d = str(t == G.order())
	d = d.replace("*"," ")
	d = d.replace("==","=")
	Non_triv.append(d)
	for i in range(len(V)):
		Non_triv.append(str(V[i] >= 0))
	f = open("{0}.lp".format(name),"w+")
	f.writelines("Maximize \n \n")
	f.writelines("{0}\n".format(Triv))
	f.writelines("Subject To \n \n")
	for x in Non_triv:
	   f.writelines("{0}\n".format(x))
	f.writelines("End")
	f.close()
	print("Done")






"""	D = pair_derangements(G,H)
	V = VA(len(D))
	Irr = G.irreducible_characters()
	Triv = []
	Non_triv = []
	for i in range(len(D)):
		s = 0
		for phi in Irr:
 			if len(D[i]) == 2:
				a = phi(D[i][0])
				s += 2*V[i]*ComplexNumber(real(a).n() ,0*imag(a).n())*len(G.conjugacy_class(D[i][0]))
               #print s
			elif len(CD[i]) == 1:
				b = D[i][0]
				a = phi(D[i][0])
				if b.inverse() == b:
					s += V[i]*a*len(G.conjugacy_class(D[i][0]))
				else:
					s += V[i]*ComplexNumber(real(a).n() ,0*imag(a).n())*len(G.conjugacy_class(D[i][0])) # It might approximate it if this is not done, I don't know.
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
				c = str(s*phi.degree() == 0)
				c = c.replace("*"," ")
				b = b.replace("*"," ")
				Non_triv.append(c)
				Non_triv.append(b)
"""