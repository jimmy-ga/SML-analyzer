class Lector
	def initialize(variable,tipo,valor,str) #Constructor para crear un objeto que tenga la variable, valor, tipo. Esto para facilitar la construccion de la tabla
		@variable = variable
		@valor = valor
		@tipo = tipo
	end

	def initialize(lista,str) #constructor que tiene el codigo y lista con variables
		@lista = lista
		@str = str
	end

	def busca_variables() #Busca todas las variables de un codigo y las mete en el atributo lista
		codigo = @str #@str es el codigo SML que contiene el objeto
		indice = 0 #indice para recorrer el codigo
		variable = '' #aqui se almacena la varible temporalmente para despues meterla a la lista
		largo_str = codigo.length #largo del codigo restante
		while largo_str > 0 and codigo.index('var') != nil do  #codigo.index determina si existe el string "var", si existe devuelve el indice donde se encuentra, sino devuelve nil
			indice = codigo.index('var')					   #el primer while recorre todo el codigo en busca de var
			num_espacios = 0 #variable para determinar
			while codigo[indice] != nil and num_espacios < 4 do #este while va aumentando el indice y concatena hasta terminar de leer la variable
				if codigo[indice]=="'" or codigo[indice]== '"' #Para encontrar los valores de los strings
					variable = variable + codigo[indice]
					indice = indice + 1
					while codigo[indice]!="'" and codigo[indice]!= '"' do #Concatena los strings
						variable = variable + codigo[indice]
						indice = indice + 1
					end
					variable = variable + codigo[indice] #Concatena los strings y los va guardando en variable. Ejm. 'v'+'a'+'r'+' '+'='+...
					indice = indice + 1
					break
				elsif codigo[indice]=="[" or codigo[indice]== '(' #Para encontrar los valores de las listas y tuplas
					variable = variable + codigo[indice]
					indice = indice + 1
					while codigo[indice]!="]" and codigo[indice]!= ')' do #Concatena las listas y tuplas
						variable = variable + codigo[indice]
						indice = indice + 1
					end
					variable = variable + codigo[indice] #Concatena los strings y los va guardando en variable. Ejm. 'v'+'a'+'r'+' '+'='+...
					indice = indice + 1
					break
				end
				variable = variable + codigo[indice] #Concatena los strings y los va guardando en variable. Ejm. 'v'+'a'+'r'+' '+'='+...
				indice = indice + 1
				if codigo[indice] == ' ' and (codigo[indice+1]!="*" or codigo[indice+1]!="/" or codigo[indice+1]!="-" or codigo[indice+1]!="+")
					num_espacios = num_espacios + 1
				end
			end
			codigo = codigo.slice(indice..codigo.length) #corta el codigo ya utilizado para no volverlo a usar, ya que no se ocupa
			largo_str = codigo.length #largo del codigo restante
			@lista = @lista + [variable] #concatena la variable con el resto de la lista
			variable = '' #La variable se vuelve a poner vacia
		end
		puts @lista
	end
end
#Es un ejemplo de codigo => "fun x(lista:int list) = var x = 9 var y = 10"
a = Lector.new(["Estas son la variables"],"fun x(lista:int list) = var largo_lisp = (5,6) if x == 1 var y = 'Hola mundo' var z = True var n = [1,2,3]")
a.busca_variables()