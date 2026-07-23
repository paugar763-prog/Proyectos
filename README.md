# Formulario web con Ruby

Aplicación educativa desarrollada con Ruby y Sinatra. Permite ingresar nombre,
edad y correo electrónico, validar los datos, mostrarlos en pantalla y guardarlos
opcionalmente en un archivo de texto.

## Requisitos

- Ruby con Devkit para Windows.
- Visual Studio Code.
- Acceso a internet durante la instalación inicial de las gemas.

## Instalación en Windows

1. Descarga e instala **Ruby+Devkit x64** desde:
   https://rubyinstaller.org/downloads/
2. Durante la instalación, conserva marcada la opción para agregar Ruby al PATH.
3. Cierra y vuelve a abrir Visual Studio Code.
4. Abre esta carpeta como proyecto.
5. Abre la terminal integrada y comprueba la instalación:

   ```powershell
   ruby --version
   ```

6. Instala las dependencias del proyecto:

   ```powershell
   gem install bundler
   bundle install
   ```

## Ejecución

En la terminal integrada de VS Code ejecuta:

```powershell
bundle exec ruby app.rb
```

Abre en el navegador:

http://localhost:4567

Para detener la aplicación, regresa a la terminal y presiona `Ctrl+C`.

## Archivos principales

- `app.rb`: rutas, validación y guardado de datos.
- `views/index.erb`: formulario y presentación de resultados.
- `public/styles.css`: diseño visual adaptable.
- `data/datos_usuarios.txt`: se crea al guardar el primer registro.

## Validaciones

- El nombre no puede quedar vacío.
- La edad debe contener solo números y estar entre 1 y 120.
- El correo debe tener un formato básico válido.

