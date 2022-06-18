{:title "Rake y precondiciones arbitrarias"
 :layout :post
 :tags ["es" "Ruby" "Rake"]}

**Rake** es una herramienta muy poderosa que nos permite automatizar
tareas repetitivas de manera **eficiente**.

En el artículo [Rake, dependencias y
archivos](https://jgomo3.info/pages-output/rake-dependencias-y-archivos/)
doy una pequeña introducción de **Rake**. Si no estás familiarizado
con **Rake**, te invito a leer ese artículo antes de continuar con
este.

La eficiencia de **Rake** es evidente sobre todo cuando lo utilizamos
para derivar archivos a partir de archivos fuente.

Pero esa eficiencia aparentemente limitada a tareas relacionadas con
archivos, puede ser explotada para cualquier tipo de tarea arbitraria.

En este artículo pretendo explicar cómo lograrlo.

Para ello empecemos repasando cómo **Rake** nos brinda dicha
eficiencia cuando trabajamos con archivos.

## Cómo Rake omite la reconstrucción innecesaria de archivos

Una característica bien conocida de **Rake** es que puede ahorrar
tiempo evitando ejecutar tareas que dependen de archivos fuentes que
no hayan sido modificados.

El ejemplo con el que trato de explicar este concepto en el artículo
que dediqué a **Rake** es el siguiente:

```ruby
file 'el-documento.odt'

file 'el-documento.pdf' => ['el-documento.odt'] do
  sh "lowriter --convert-to pdf el-documento.odt"
end
```

Sabemos que, a menos que modifiquemos el archivo `el-documento.odt` o
que el archivo `el-documento.pdf` no exista, la tarea
`el-documento.pdf` no será ejecutada (lo que nos ahorra tiempo).

Pero algo no muy conocido es el hecho de que **Rake** hace esta
verificación **SIEMPRE** antes de ejecutar cualquier tipo de tarea,
sea creada con el método `file`, con el método `task` o como sea que
haya sido creada la tarea.

Lo que sucede es que cuando una tarea es creada convencionalmente (por
ejemplo, con el método `task`) esta tarea siempre necesita ejecutarse.

Por el contrario, cuando una tarea es creada con el método `file`,
ella es una tarea especial que necesita ser ejecutada según las fechas
de última modificación del archivo correspondiente y el de los
archivos asociados a las tareas de las cuales depende.

En cualquier caso, **Rake** le pregunta a la tarea misma si necesita
ser ejecutada. Para ello invoca el método `needed?` de la tarea.

Podemos verificar esto desde la consola de **Ruby**. Supongamos que
`el-documento.pdf` está recién creado y ejecutemos lo siguiente en la
consola de **Ruby**:

```ruby
> require 'rake'
> load 'Rakefile'
> Rake::Task['el-documento.pdf'].needed?
false
```

Como esperábamos, la tarea `el-documento.pdf` no necesita ser
ejecutada (porque el PDF está recién creado). Pero si modificamos el
archivo `el-documento.odt` y volvemos a preguntar:

```ruby
> Rake::Task['el-documento.pdf'].needed?
true
```

**Rake** considera que la tarea `el-documento.pdf` necesita ser
ejecutada.

## Cómo hacer que Rake omita cualquier tipo de tarea con condiciones arbitrarias

¿Podemos aprovechar este mecanismo para omitir tareas por otras
razones que no sean la fecha de última modificación de algún archivo?

Sí. Gracias al dinamismo de Ruby, es muy sencillo. Sólo debemos
sobrescribir el método `needed?` de las tareas a precondicionar.

Un ejemplo muy sencillo sería definir tareas que debería ejecutarse sí
y sólo si una variable de entorno está definida.

El siguiente archivo `Rakefile` ilustra la idea

```ruby
def luz_verde?
  !!ENV['LUZ_VERDE']
end

task :una_tarea do
  puts "Una tarea dice: ¡Hola!"
end
def (Rake::Task[:una_tarea]).needed?
  luz_verde?
end
```

Con esta tarea así definida, desde la consola del sistema podemos
pedirle a **Rake** que ejecute la tarea `una_tarea`, pero a menos que
la variable de entorno `LUZ_VERDE` esté definida, sus acciones no se
van a ejecutar:

```sh
$ rake una_tarea
# Nada pasa
$ LUZ_VERDE= rake una_tarea
Una tarea dice: ¡Hola!
```

Limitar una tarea con variables de entorno podría ser útil para
proteger sistemas de tareas que sólo deberían ejecutarse en ciertos
entornos.

Por ejemplo, algunas tareas de prueba que modifiquen bases de datos
pueden ser peligrosas en entornos de producción.

Un caso de uso donde estoy utilizando esta técnica es en la gestión de
[contenedores Linux (LXC)](https://linuxcontainers.org/).

Una tarea que «lance» un contenedor puede verificar primero si existe
o no dicho contenedor.

Igualmente una tarea que «elimine» un contenedor, puede verificar si
existe antes de intentarlo.

## Refinamiento

En vez de modificar cada tarea una y otra vez, podemos crear una clase
especializada de `Rake::Task` que redefina el método `needed?`

**Rake** mismo tiene varias especializaciones que pueden servir de
inspiración:

 - [FileTask](https://github.com/ruby/rake/blob/73a21161bbd0db02804bbd11606a7529e2a0aaa2/lib/rake/file_task.rb): Es el tipo de tarea especial que crea `file`.
 - [FileCreationTask](https://github.com/ruby/rake/blob/73a21161bbd0db02804bbd11606a7529e2a0aaa2/lib/rake/file_creation_task.rb): caso especial de `FileTask`.
 - [MultiTask](https://github.com/ruby/rake/blob/73a21161bbd0db02804bbd11606a7529e2a0aaa2/lib/rake/multi_task.rb): Ejecuta las tareas de las que depende en forma paralela.
 - [PackageTask](https://github.com/ruby/rake/blob/73a21161bbd0db02804bbd11606a7529e2a0aaa2/lib/rake/packagetask.rb): Crea tareas para empaquetar archivos (tar, zip, etc).
 - [TestTask](https://github.com/ruby/rake/blob/73a21161bbd0db02804bbd11606a7529e2a0aaa2/lib/rake/testtask.rb): Tarea especializada en ejecutar pruebas.

En particular, `FileTask` y `FileCreationTask` sobreescriben el método
`needed?`.

## Conclusiones

Gracias al dinamismo de Ruby, podemos explorar esta técnica
modificando tareas específicas, y si percibimos un patrón podemos
expresarlo en una clase especializada de `Rake::Task`.

Esta técnica me parece muy valiosa porque le nos permite usar **Rake**
para controlar la ejecución de las tareas basandonos en condiciones
arbitrarias del estado de sistemas, no necesariamente relacionadas con
archivos.

Ahora sabemos que podemos asociar una tarea con el estado de sistemas
como los contenedores de Linux, variables de entorno.

Pero más importante aún, sabemos que podemos verificar cualquier
condición, como objetos en bases de datos, usuarios, retos (palabras
clave), fechas (días festivos por ejemplo), etc.
