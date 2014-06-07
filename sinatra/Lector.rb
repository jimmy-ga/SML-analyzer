require 'find'
$indice = 0
class Lector
	@@abc = ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z']
	@@lista_ns = ['1','2','3','4','5','6','7','8','9','0','+','-','/','*']
	@@lista_var = []
	@@tabla_simbolos=[] #lista que contiene los valores finales evaluados
	@@tabla_final=[]
	
	def initialize(lista,str) #constructor que tiene el codigo y lista con variables
		@lista = lista
		@str = str
	end

	def self.concatena_var(codigo,res)
		if codigo[0] == " "
			return res
		else
			return Lector.concatena_var(codigo.slice(1..codigo.length),res+codigo[0])
		end
	end

	def self.buscar_var(str)
		for i in @@lista_var
			if str==i
				return true
			end
		end
		false
	end

	def self.buscar_n(str)
		for i in @@lista_ns
			if str==i
				return true
			end
		end
		false
	end

	def self.buscar_abc(str)
		for i in @@abc
			if str==i
				return true
			end
		end
		false
	end

	def encuentra_strings(codigo,variable) #Saca los strings
		variable = variable + codigo[$indice]
		$indice = $indice + 1
		while codigo[$indice]!="'" and codigo[$indice]!= '"' do #Concatena los strings
			variable = variable + codigo[$indice]
			$indice = $indice + 1
		end
		variable = variable + codigo[$indice] #Concatena los strings y los va guardando en variable. Ejm. 'v'+'a'+'r'+' '+'='+...
		$indice = $indice + 1
		variable
	end

	def encuentra_tuplas_listas(codigo,variable)
		num_parentesis = 0
		if codigo[$indice] == '[' or codigo[$indice] == '('
			num_parentesis = num_parentesis + 1
		end
		variable = variable + codigo[$indice]
		$indice = $indice + 1
		while codigo[$indice]!="]" and codigo[$indice]!= ')' do #Concatena las listas y tuplas
			if codigo[$indice] == '[' or codigo[$indice] == '('
				num_parentesis = num_parentesis + 1 
			end
			variable = variable + codigo[$indice]
			$indice = $indice + 1
		end
		while num_parentesis > 0 do
			if codigo[$indice] == ']' or codigo[$indice] == ')'
				num_parentesis = num_parentesis - 1
			elsif codigo[$indice] == '[' or codigo[$indice] == '('
				num_parentesis = num_parentesis + 1
			end
			variable = variable + codigo[$indice]
			$indice = $indice + 1
		end
		variable = variable + codigo[$indice] #Concatena los strings y los va guardando en variable. Ejm. 'v'+'a'+'r'+' '+'='+...
		$indice = $indice + 1
		variable
	end

	def encuentra_int_float(codigo,variable)
		copia = codigo
		vf = false
		x = Lector.concatena_var(copia,"")
		while (not Lector.buscar_abc(codigo[$indice])) or vf do
			variable = variable + codigo[$indice]
			$indice = $indice + 1
			x = Lector.concatena_var(copia[$indice..copia.length],"")
			vf = false
			if Lector.buscar_var(x)
				vf = true
			end
		end
		variable
	end

		def busca_variables() #Busca todas las variables de un codigo y las mete en el atributo lista
		codigo = @str + " x <3"#@str es el codigo SML que contiene el objeto
		variable = '' #aqui se almacena la varible temporalmente para despues meterla a la lista
		largo_str = codigo.length #largo del codigo restante
		while largo_str > 0 and codigo.index('val') do  #codigo.index determina si existe el string "var", si existe devuelve el indice donde se encuentra, sino devuelve nil
			$indice = codigo.index('val')				   #el primer while recorre todo el codigo en busca de var
			copia = codigo
			@@lista_var = @@lista_var + [Lector.concatena_var(copia.slice($indice+4..copia.length),"")] #agregar las variables a una lista
			num_espacios = 0 #variable para determinar
			while codigo[$indice] != nil and num_espacios < 4 do #este while va aumentando el indice y concatena hasta terminar de leer la variable
				if codigo[$indice]=="'" or codigo[$indice]== '"' #Para encontrar los valores de los strings
					variable = encuentra_strings(codigo,variable)
					break
				elsif codigo[$indice]=="[" or codigo[$indice]== '(' #Para encontrar los valores de las listas y tuplas
					variable = encuentra_tuplas_listas(codigo,variable)
					break
				elsif (codigo[$indice]+codigo[$indice+1]+codigo[$indice+2])=="let"
					variable = variable + codigo[$indice]+codigo[$indice+1]+codigo[$indice+2]
					$indice = $indice + 3
					while (codigo[$indice]+codigo[$indice+1]+codigo[$indice+2])!="end" do
						variable = variable + codigo[$indice]
						$indice = $indice + 1
					end
					variable = variable + codigo[$indice]
					$indice = $indice + 1
					break
				elsif Lector.buscar_n(codigo[$indice])
					variable = encuentra_int_float(codigo,variable)
					break
				end
				variable = variable + codigo[$indice] #Concatena los strings y los va guardando en variable. Ejm. 'v'+'a'+'r'+' '+'='+...
				$indice = $indice + 1
				if codigo[$indice] == ' '
					num_espacios = num_espacios + 1
				end
			end
			codigo = codigo.slice($indice..codigo.length) #corta el codigo ya utilizado para no volverlo a usar, ya que no se ocupa
			largo_str = codigo.length #largo del codigo restante
			@lista = @lista + [variable] #concatena la variable con el resto de la lista
			variable = '' #La variable se vuelve a poner vacia
		end
		#puts @@lista_var
		#puts @lista
		ambientes(@lista)
		#pruebaTipos(convierteLista("5 + 2.8989 / 34 - 99676 + 576567"))
		#pruebaTipos(convierteLista("34 + r"))
	end

#	def busca_variables(tira)
#		tira2=tira.split
#		#puts tira2.to_s
#		tira3=[]
#		temporal=[]
#		for i in tira2
##			temporal=[]
#			if i.to_s=="val" or temporal!=[]
#				tira3=tira3+temporal
#				temporal=[]				
#				temporal=temporal+[i]
#			end
#		end
#		#puts "fin \n"
#		#puts tira3.to_s
#		ambientes(tira3)
#	end

	def splitear(valor)#separa un string con expresiones matematicas y espacios y las devuelve sin estos(ej.: 3 +4* 5 devuelve 3+4*5)
		salida=[]
		temp=""
		contador=0
		while valor[contador].nil? == false do
			variable=valor[contador]
			if variable!="+" and variable!="/" and variable!="*" and variable!="-"
				temp.concat(variable)
			else
				salida=salida+[temp]+[variable]
				temp=""
			end	
			contador+=1		
		end
		salida=salida+[temp]
		return salida
	end

	def convierteLista(valor) #
		lista= valor.delete " " #borra los espacios en blanco
		#metodo para split manteniendo los caracteres
		lista=splitear(lista)
		#puts lista.to_s
		i=0
		listares=[]
		while lista[i].nil? == false do
			posicion=lista[i]
			if posicion=="+" or posicion=="-" or posicion=="*" or posicion=="/"
				listares=listares+[posicion]
			elsif posicion.include? "." or posicion.include? ","
				posicion=posicion.to_f
				listares=listares+[posicion]
			else 
				for simbolo in @@tabla_simbolos
					if simbolo[0]==posicion
						posicion=simbolo[1]
					end
				end			
				listares=listares+[posicion.to_i]
			end
			i+=1
		end
		#puts @@tabla_simbolos[0].split(",")[1]
		#puts listares.to_s
		return listares
	end
	
	def pruebaTipos(lista)#resuelve las expresiones matematicas de un string (ej.: 3+2 retorna 5)
		contador=0
		#puts lista
		while lista[contador].nil? ==false do
			if lista[contador]=="*"
			lista[contador]=lista[contador-1]*lista[contador+1]
			lista.delete_at(contador-1)
			lista.delete_at(contador)
			elsif lista[contador]=="/"
			lista[contador]=lista[contador-1]/lista[contador+1]
			lista.delete_at(contador-1)
			lista.delete_at(contador)
			end
			contador+=1
		end
		while lista.length>1 do
			contador=0
			while lista[contador].nil? ==false do
				if lista[contador]=="+"
				lista[contador]=lista[contador-1]+lista[contador+1]
				lista.delete_at(contador-1)
				lista.delete_at(contador)
				end
				if lista[contador]=="-"
				lista[contador]=lista[contador-1]-lista[contador+1]
				lista.delete_at(contador-1)
				lista.delete_at(contador)
				end
				contador+=1
			end
		end
		#puts [lista[0],lista[0].class.to_s]
		return lista[0]
	end

	def get_tipo_lista(lista)
		numeros= %w{1 2 3 4 5 6 7 8 9 0}
		lista=lista.tr("[]","")
		if  numeros.include?(lista[0])
			return "Int list"
		elsif lista[0].class==String and lista[0].length==1
			return "Char list"
		else
			return "String list"
		end
		
	end
	def ambientes(lista) #funcion principal para obtener los valorres dinamicos y estaticos
		for i in lista
			actual=i.split
			if actual[0]=="val"
			valor=""
				variable=actual[1]
				comienza=3
				while actual[comienza].nil? == false do
					valor.concat(actual[comienza])
					comienza=comienza+1
				end
				numeros= %w{1 2 3 4 5 6 7 8 9 0}
				#puts valor[0].class.to_s
				if  numeros.include?(valor[0])
					#puts "antes: "+valor.to_s
					valor=pruebaTipos(convierteLista(valor))					
					#puts "despues: "+valor.to_s+valor.class.to_s
				end
				@@tabla_simbolos=[]
				if valor.class==Fixnum
						@@tabla_simbolos=@@tabla_simbolos+[[variable,valor,"Int"]]
				elsif valor.class==Float
						@@tabla_simbolos=@@tabla_simbolos+[[variable,valor,"Float"]]
				#puts valor
				elsif valor.class==String
						valor=valor.downcase
						if valor=="true" or valor=="false"
							@@tabla_simbolos=@@tabla_simbolos+[[variable,valor,"Boolean"]]
							#puts "Variable: "+variable+" Valor: "+valor.to_s+" Tipo: Boolean"
						elsif valor.start_with? "(" and valor.end_with? ")"
							@@tabla_simbolos=@@tabla_simbolos+[[variable,valor,"Tupla"]]
							#puts "Variable: "+variable+" Valor: "+valor.to_s+" Tipo: Tupla"
						elsif valor.start_with? "["
							tipo_lista=get_tipo_lista(valor)
							@@tabla_simbolos=@@tabla_simbolos+[[variable.to_s,valor.to_s,tipo_lista.to_s]]
							#puts "Variable: "+variable+" Valor: "+valor.to_s+" Tipo: "+tipo_lista
						end
						#puts @@tabla_simbolos.to_s
				end
				#for i in @@tabla_simbolos
				#	puts "Variable: "+i[0].to_s+" Valor: "+i[1].to_s+" Tipo: "+i[2].to_s
				#end
				#puts @@tabla_simbolos.to_s
				@@tabla_final=@@tabla_final+@@tabla_simbolos
				#return @@tabla_simbolos
				#@@tabla_simbolos=@@tabla_simbolos+[[variable,valor]]
					#puts "Variable: "+variable+" Valor: "+valor.to_s+" Tipo: "+valor.class.to_s
			end
		end
	#puts @@tabla_final.to_s
	return @@tabla_final
	end	
end

class Separador
	def initialize(variable,tipo,valor,str) #Constructor para crear un objeto que tenga la variable, valor, tipo. Esto para facilitar la construccion de la tabla
		@variable = variable
		@valor = valor
		@tipo = tipo
	end
end

def carga_archivo(nombre)	 
		archivo=""
		File.open('uploads/'+nombre.to_s, 'r') do |f1|
			while linea = f1.gets
				archivo.concat(linea)
#				puts linea
			end
		end
		#puts archivo
		a=Lector.new(["Estas son la valiables"],archivo)
		return a.busca_variables()
#	puts archivo
		#a = Lector.new("[variables]",archivo)
		#a.busca_variables()
end

#carga_archivo("fichero.sml")
#Es un ejemplo de codigo => "fun x(lista:int list) = val x = 9 val y = 10"
#a = Lector.new(["Estas son la valiables"],"fun x(lista:int list) = val r = 16 + 7 val largo_lisp = (((5,6),(9+9,354)),((76,32),(5654,456))) let if x == 1 end val y = 'Hola mundo' val er = 34 + r val z = true val n = [1,2,3] if x>3")
#puts a.busca_variables()
