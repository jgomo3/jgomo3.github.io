{:title "Rake y precondiciones arbitrarias"
 :layout :post
 :tags ["es" "Ruby" "Rake"]}

[Rake](https://ruby.github.io/rake/index.html), el
[Make](https://www.gnu.org/software/make/) de
[Ruby](https://www.ruby-lang.org/es/), pone a nuestra disposición un
Lenguaje de Dominio Específico (DSL son sus siglas en inglés) que nos
permite expresar tareas repetitivas que típicamente realizamos los
programadores al desarrollar un proyecto de software (aunque en
realidad, puede ser utilizado para expresar cualquier tipo de
automatización).

El componente fundamental de dicho DSL es la «Tarea». Con ella podemos
expresar unas acciones que luego podemos ordenar al computador que las
ejecute mencionando el nombre de la tarea.

Nada del otro mundo por ahora. Lo que hace de estas herramientas algo
casi necesario en el arsenal de los programadores, es que puedemos
expresar relaciones de dependencia entre una tarea y otra. De esta
manera, al solicitarle al computador que realize una simple tarea, es
posible que realice muchas si dicha tarea depende de otras.

Antes de proceguir, veamos un ejemplo.

Expresemos 2 tareas:

 1. Pedir algo: Imprime el texto «Dame eso»
 2. Decir por favor: Imprime el texto «Por favor»

La idea es que al ejecutar la tarea «Pedir algo», la tarea «Decir por
favor» deba ejecutarse primero, es decir, que al ejecutar lo siguiente
en la consola:

```sh
rake pedir_algo
```

El resultado sea:

```sh
Por favor
Dame eso
```

Para lograr esto, escribimos lo siguiente en un archivo llamado `Rakefile`:

```ruby
task :decir_por_favor do
  puts "Por favor"
end

task pedir_algo: [:decir_por_favor] do
  puts "Dame eso"
end
```

Y así obtemos el resultado esperado. Nota que además de poder «pedir
algo», podemos «decir por favor» independientemente:

```sh
rake decir_por_favor
```

Genera el mensaje:

```sh
Por favor
```

También nota que no se puede «pedir algo» si «decir por favor».

Cuando las tareas producen archivos (derivados) a partir de otros
(fuentes), **Rake** (y las otras herramientas de este tipo) aprovechan
las relaciones de dependencia expresadas para omitir tareas que no
hagan falta.

Para ello, **Rake** compara la fecha de la última modificación entre
los archivos generados por tareas interdependientes para determinar si
realizar la tarea o no.

Si una tarea (A) genera un archivo «derivado» de otro archivo
«fuente» que es generado por otra tarea (B), cuando le pedimos al
computador que ejecute la tarea A, primero verifica si la fecha de
última modificación del archivo «fuente» es más reciente que la
fecha de última modificación del archivo «derivado» y sólo en ese caso
ejecuta la tarea A.

Por ejemplo, supongamos que estamos redactando un documento en Libre
Office Writer (.odt) y queremos generar un archivo PDF (.pdf) a
partir del documento. La orden para lograr esto es:

```sh
lowriter --convert-to pdf <el-nombre-del-documento>
```

Si expresamos esta tarea en **Rake** declarando que el PDF depende del
documento, entonces esa tarea no se ejecutará a menos que el documento
haya sido modificado, incluso si le pedimos al computador que realice
dicha tarea.

Una forma de expresar esto en **Rake** sería escribiendo lo siguiente
en el archivo `Rakefile`:

```ruby
file 'el-documento.odt'

file 'el-documento.pdf' => ['el-documento.odt'] do
  `lowriter --convert-to pdf el-documento.odt`
end
```

La novedad aquí es que en vez de utilizar el método `task` usamos el
método `file`. Este método crea una forma especial de tarea que está
asociada a un archivo (el archivo tiene como nombre el mismo nombre de
la tarea). De esta manera le indicamos a **Rake** que se comporte como
ya hemos descrito.

Es decir, si ejecutamos la tarea `el-documento.pdf`, las acciones
sucederán sólo si el archivo `el-documento.odt` se ha modificado
recientemente o si el archivo `el-documento.pdf`. Si no, no hace falta
y por ende no se ejecutan las acciones.

Veamoslo en acción. Supongamos que sólo tenemos en una carpeta el
archivo Rakefile con las tareas `el-documento.odt` y
`el-documento.pdf` definidas, y el archivo `el-documento.odt` con
algún contenido.

Entonces, desde esa carpeta, ejectamos lo siguiente:

```sh
rake --trace el-documento.pdf
```

La opción --trace hace que **Rake** reporte qué tareas está
considerando realizar y si las realiza o no, y en qué orden.

El resultado de la orden anterior es que el archivo `el-documento.pdf`
existe y el siguiente reporte de **Rake**:

```sh
** Invoke el-documento.pdf (first_time)
** Invoke el-documento.odt (first_time, not_needed)
** Execute el-documento.pdf
```

Con `Invoke el-documento.pdf (first_time)` **Rake** nos está indicando
que va a procesar la tarea `el-documento.pdf` por primera vez durante
la ejecución de esta orden.

Luego, con `Invoke el-documento.odt (first_time, not_needed)` nos
indica algo similar pero con la tarea `el-documento.odt` pero además
nos indica que no es necesario ejecutar las acciones de la tarea. Si
revisas la definición de la tarea, verás que no tiene acciones.

Por último, con `Execute el-documento.pdf` **Rake** nos está indicando
que está ejecutando las acciones de la tarea `el-documento.pdf`.

Si volvemos a ejecutar la misma orden inmediatamente:

```sh
rake --trace el-documento.pdf
```

Obtenemos este reporte:

```sh
** Invoke el-documento.pdf (first_time, not_needed)
** Invoke el-documento.odt (first_time, not_needed)
```

**Rake** concluyó que no hace falta ejecutar ninguna tarea, y en
efecto, no lo hace.

Si en algún momento modificamos el archivo fuente `el-documento.odt` o
eliminamos el archivo derivado `el-documento.pdf`, **Rake** volverá a
ejecutar las acciones de la tarea `el-documento.pdf` si se lo pedimos.

**Rake** hace esta verificacion de la fecha de última modificación de
los archivos para determinar si ejecutar o no una tarea definida con
el método `file`.

Pero algo no muy conocido es el hecho de que **Rake** hace esta
verificación **SIEMPRE** antes de ejecutar cualquier tipo de tarea
(sea creada con el método `file`, con el método `task` o como sea que
haya sido creada la tarea).

Sucede que a menos que se diga lo contrario, una tarea siempre
necesita ser ejecutada. Pero `file` crea una tarea especial que
necesita ser ejecutada según las fechas de última modificación del
archivo correspondiente y el de los archivos asociados a las tareas de
las cuales depende.

**Rake** le pregunta a la tarea misma si necesita ser ejecutada. Para
ello invoca el método `needed?` de la tarea.

Podemos verificar esto desde la consola de Ruby. Supongamos que
`el-documento.pdf` está recien creado:

```ruby
require 'rake'
load 'Rakefile'
Rake::Task['el-documento.pdf'].needed? # => false
```

La tarea `el-documento.pdf` no necesita ser ejecutada. Pero si
modificamos el archivo `el-documento.odt` y volvemos a preguntar:

```ruby
Rake::Task['el-documento.pdf'].needed? # => true
```

**Rake** considera que la tarea `el-documento.pdf` necesita ser
ejecutada.

¿Pero qué pasa si queremos que nuestras tareas se ejecuten
condicionalmente independientemente de si son tareas asociadas a
archivos, y con condiciones arbitrarias determinadas por otros
contextos?

Gracias al dinamísmo de Ruby, es muy sencillo. Sólo debemo
sobreescribir el métdo `needed?` de nuestras tareas con dicha lógica
arbitraria.

Un ejemplo muy sencillo sería definir tareas que vamos a ejecutar sí y
sólo si una variable de entorno tiene un valor específico. El
siguiente archivo `Rakefile` ilustra la idea

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

Entonces, desde la consola del sistema podemos pedirle a **Rake** que
ejecute la tarea `una_tarea`, pero al menos que la variable de entorno
`LUZ_VERDE` esté definida, sus acciones no se van a ejectuar:

```sh
rake una_tarea
LUZ_VERDE= rake una_tarea
Una tarea dice: ¡Hola!
```

Un caso de uso para este ejemplo de la variable de entorno sería
proteger tareas para que sean ejecutadas sólo en ciertos entornos. Por
ejemplo, tareas de prueba que no puedas ser ejecutadas en entornos de
producción para evitar pérdidas de datos accidentales.

Un caso de uso donde estoy utilizando esta técnica por los momentos
(hasta que encuentre una mejor) es en la gestión de contenedores Linux
(LXC).

Una tarea que «lance» un contenedor puede verificar primero si existe
o no dicho contenedor. Igualmente una tarea que «elimine» un
contenedor, puede verificar si existe antes de intentarlo.

En este caso en particular de los contenedores, estoy considerando la
alternativa de utilizar gestión de errores en vez de estas
precondiciones.

Pero en todo caso, las precondiciones arbitrarias son una idea
interesante que merece ser explorada aún más.

El siguiente paso es crear módulos o clases especializadas de
`Rake::Task` para casos de uso específicos.

**Rake** mismo tiene varias especializaciones que pueden servir de
inspiración:

 - `FileTask`: The one created by the method `file`
 - `FileCreationTask`: especial case of `FileTask`
 - `MultiTask`: Run dependencies in parallel
 - `PackageTask`: Creates tasks for packaging files in archive files
   (tar, zip, etc).
 - `TestTask`: Task for running tests

En particular, `FileTask` y `FileCreationTask` sobreescriben el método
`needed?`.

Esta técnica me parece muy valiosa porque le abre las puertas a
**Rake** para controlar la ejecución de las tareas basado en el estado
de sistemas que no tengan que depender de la existencia o condiciones
de archivos. El estado puede ser cualquier cosa que quieras.
