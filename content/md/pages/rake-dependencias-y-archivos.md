{:title "Rake, dependencias y archivos"
 :layout :page
 :page-index 1
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
expresar relaciones de dependencia entre una tarea y otra.

## Dependencia entre tareas

Al expresar que unas tareas dependen de otras, si le pedimos a
**Rake** que realice una tarea, es posible que realice muchas si dicha
tarea depende de otras.

Veamos un ejemplo.

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

## Rake y la generación de archivos

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
  sh "lowriter --convert-to pdf el-documento.odt"
end
```

La novedad aquí es que en vez de utilizar el método `task` usamos el
método `file`. Este método crea una forma especial de tarea que está
asociada a un archivo (el archivo tiene como nombre el mismo nombre de
la tarea). De esta manera le indicamos a **Rake** que se comporte como
ya hemos descrito.

Veamos esto en acción. Supongamos que sólo tenemos en una carpeta el
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
existe en la carpeta y además **Rake** muestra el siguiente reporte:

```sh
** Invoke el-documento.pdf (first_time)
** Invoke el-documento.odt (first_time, not_needed)
** Execute el-documento.pdf
lowriter --convert-to pdf el-documento.odt
```

Con `Invoke el-documento.pdf (first_time)` **Rake** nos está indicando
que va a procesar la tarea `el-documento.pdf` por primera vez durante
la ejecución de esta orden.

Luego, con `Invoke el-documento.odt (first_time, not_needed)` nos
indica algo similar pero con la tarea `el-documento.odt` pero además
nos indica que no es necesario ejecutar las acciones de la tarea. Si
revisas la definición de la tarea, verás que no tiene acciones.

Con `Execute el-documento.pdf` **Rake** nos está indicando
que está ejecutando las acciones de la tarea `el-documento.pdf`.

Finalmente nos muestra la acción (`lowriter ...`) porque utilizamos el
método `sh` en la definición de las acciones de la tarea. Una forma
más de ratificar que las acciones se ejecutaron.

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

## Conclusión

Gracias a las dependencias entre tareas, podemos desencadenar una gran
cantidad de tareas con tan solo ejecutar una, si diseñamos bien la red
de interdependencias, con lo cual podemos ahorrar mucho tiempo en
tareas repetitivas.

Adicionalmente, el trato especial que le da **Rake** a las tareas
creadas con el método `file` permite que **Rake** omita tareas
innecesarias cuando no haga falta derivar un archivo que ya está
derivado y sus fuentes no han cambiado.

Gracias a esto, no tenemos que pensar a la hora de ejecutar tareas
repetitivas. Simplemente le indicamos a **Rake** que realice las
tareas y él determinará si las realiza o no.

## Más información

Para indagar más acerca de **Rake**, consulta [la documentación
oficial del proyecto](https://ruby.github.io/rake/) (por los momentos,
en inglés).
