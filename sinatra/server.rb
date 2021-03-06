require 'rubygems'
require 'sinatra'
require 'haml' 
require "./Lector.rb" 

listaElem =[]

set :bind, '0.0.0.0'
#El index de la página
get "/" do
	haml :index
end

# Handle GET-request (Show the upload form)
get "/analizar" do
  haml :cargaArchivo
end

get "/resultados" do
	#listaElem = [["X","3","int"],["S","3.45","float"],["tuplis","(5,7)","int*int"],["lista","[6,8,7,4,3]","int list"]]
  haml :resultados, :locals => {:resultados => listaElem}
end

get "/error_archivo" do
	#listaElem = [["X","3","int"],["S","3.45","float"],["tuplis","(5,7)","int*int"],["lista","[6,8,7,4,3]","int list"]]
  haml :resultado_error
end

# Handle POST-request (Receive and save the uploaded file)
post "/analizar" do 
  File.open('uploads/' + params['file'][:filename], "w") do |f|
    f.write(params['file'][:tempfile].read)
  end
  name= params['file'][:filename]
	#puts "PRUEBA DE SUBIDA" + name.to_s
	if name.to_s.split(".")[1]!="sml"
		listaElem=[["Archivo invalido","",""]]
		return redirect "/error_archivo"
	end
	listaElem=carga_archivo(name.to_s)
	#puts listaElem
  return redirect "/resultados"
end

