# Aplicación web educativa desarrollada con Ruby y Sinatra.

require "sinatra"
require "fileutils"

set :bind, "127.0.0.1"
set :port, 4567
set :public_folder, File.join(__dir__, "public")
set :views, File.join(__dir__, "views")

ARCHIVO_DATOS = File.join(__dir__, "data", "datos_usuarios.txt")

helpers do
  # Evita que los datos ingresados se interpreten como código HTML.
  def escapar(texto)
    Rack::Utils.escape_html(texto.to_s)
  end
end

def datos_del_formulario
  {
    nombre: params.fetch("nombre", "").strip,
    edad: params.fetch("edad", "").strip,
    correo: params.fetch("correo", "").strip
  }
end

def validar(datos)
  errores = []

  errores << "El nombre es obligatorio." if datos[:nombre].empty?

  if !datos[:edad].match?(/\A\d+\z/)
    errores << "La edad debe contener solamente números."
  elsif !datos[:edad].to_i.between?(1, 120)
    errores << "La edad debe estar entre 1 y 120 años."
  end

  patron_correo = /\A[^\s@]+@[^\s@]+\.[^\s@]+\z/
  unless datos[:correo].match?(patron_correo)
    errores << "Ingrese un correo electrónico válido."
  end

  errores
end

def guardar_en_txt(datos)
  FileUtils.mkdir_p(File.dirname(ARCHIVO_DATOS))

  # Se eliminan saltos de línea y separadores para mantener un registro por línea.
  valores_seguros = datos.transform_values do |valor|
    valor.gsub(/[\r\n|]/, " ")
  end

  registro = [
    "Nombre: #{valores_seguros[:nombre]}",
    "Edad: #{valores_seguros[:edad]}",
    "Correo: #{valores_seguros[:correo]}"
  ].join(" | ")

  # El modo "a" agrega el registro sin borrar el contenido anterior.
  File.open(ARCHIVO_DATOS, "a:utf-8") do |archivo|
    archivo.puts(registro)
  end
end

get "/" do
  erb :index, locals: {
    valores: { nombre: "", edad: "", correo: "" },
    errores: [],
    resultado: nil,
    aviso: nil
  }
end

post "/procesar" do
  valores = datos_del_formulario
  errores = validar(valores)
  resultado = nil
  aviso = nil

  if errores.empty?
    resultado = valores

    if params["accion"] == "guardar"
      begin
        guardar_en_txt(valores)
        aviso = "Los datos se guardaron correctamente en datos_usuarios.txt."
      rescue SystemCallError => error
        errores << "No se pudo guardar el archivo: #{error.message}"
      end
    end
  else
    status 422
  end

  erb :index, locals: {
    valores: valores,
    errores: errores,
    resultado: resultado,
    aviso: aviso
  }
end

