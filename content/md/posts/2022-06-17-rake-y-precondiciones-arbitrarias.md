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
partir del documento. El comando para lograr esto es:

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

