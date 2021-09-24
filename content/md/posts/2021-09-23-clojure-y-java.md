{:title "Clojure y Java"
 :layout :post
 :tags ["es" "Clojure" "Java"]}

## Clojure el jar

Clojure es distribuído en realidad como un paquete `.jar`.

La forma más básica de utilizarlo es ejecutando:

```shell
$ java -jar clojure.jar
```

En cuyo caso el "REPL" arranca.

```Clojure
Clojure 1.11.0-master-SNAPSHOT
user=> (+ 1 1)
2
```

Otra forma de interesante de invocar Clojure es incluyendo el paquete
`clojure.jar` explícitamente en el "Class Path" y ejecutar su "clase
principal".

```shell
$ java -cp clojure.jar clojure.main
Clojure 1.11.0-master-SNAPSHOT
user=> 
```

Nota:

La clase principal de un paquete ".jar" está definida en su
manifiesto (META-INF/MANIFEST.MF).

```shell
$ jar xf clojure.jar META-INF/MANIFEST.MF
$ grep Main-Class META-INF/MANIFEST.MF 
Main-Class: clojure.main
```

Pasar un libreto («script») como argumento evita el "REPL" y Clojure
interpreta expresión por expresión dicho libreto.

Supongamos que tenemos un archivo llamado `hola.clj` con el siguiente
contenido:

```Clojure
(println "Hola Infinito")
```

Entonces el mensaje "Hola Infinito" será producido por la salida
estándar después de ejecutar lo siguiente:

```Shell
$ java -jar clojure.jar hola.clj
Hola Infinito
$ 
```

Si el libreto es `-`, entonces lee dicho libreto de la entrada
estándar. Es decir, otra forma de lograr el mismo resultado de
ejecutar el libreto "hola.clj", hubiera sido:

```Shell
$ echo '(println "Hola Infinito")' | java -jar clojure.jar -
Hola Infinito
```

Que también podría haberse logrado usando la opción `-e`, que hace que
clojure evalúe la expresión determinada Y la produzca por la salida
estándar.

```Shell
$ java -jar clojure.jar -e '"Hola Infinito"'
Hola Infinito
```

Nota:

En este caso, no hizo falta utilizar la función `println`, porque `-e`
no sólo evalúa la expresión dada, sino que su resultado lo coloca en
la salida estándar.

Las comillas simples son para indicarle al «shell» que no trate de
interpretar nada del contenido que encierran. De esta manera, podemos
escribir las comillas dobles (`"`) con la seguridad de que serán
recibidas por Clojure, en cuyo momento, representan el inicio y el
final de una cadena de carateres.

Puedes pedirle a Clojure que evalúe varias expresiones a la
vez. Producirá una línea por valor en la salida estándar:

```Shell
$ java -jar clojure.jar -e 1 -e 2 -e 3
1
2
3
```

Pero ¿cómo obtener el `.jar`?

Una forma de generarlo es siguiendo as instrucciones de la guía de iniciación («Getting Started») en la sección «Otras maneras de correr Clojure» («Other ways to run Clojure»)[1]:

```
git clone https://github.com/clojure/clojure.git
cd clojure
mvn -Plocal -Dmaven.test.skip=true package
```

El paquete `clojure.jar` generado tendrá todas las dependencias
necesarias para soportar todo el lenguaje.

[1] https://clojure.org/guides/getting_started#_other_ways_to_run_clojure

## Clojure CLI

clojure.org pone a nuestra disposición unas herramientas que nos
permite utilizar Clojure de una forma más simple y a su vez con más
funcionalidades.

Estas herramientas se conocen como «Las herramientas para el
Intérprete de la Línea de Órdenes» («CLI Tools»).

Hay varios métodos de instalación. Cada distribución de Sistema
Operativo muy posiblemente las tendrá a disposición con el nombre de
`clojure`.

Exploraremos aquí la manera de instalar estas herramientas
independientemente de la distribución de Sistema Operativo.

Estas herramientas necesitan:

 - bash
 - java
 - rlwrap (opcional)

En clojure.org hay un libreto de instalación. Para el día de hoy, la
versión estable de Clojure es la versión `1.10.3.986`, así que
descargaremos el instalador de dicha versión y lo ejecutamos.

Si no indicamos nada, el instalador intentará instalar las
herramientas a nivel del sistema (`/usr/bin`, etc.). En ese caso,
habría que tener permisos para hacerlo (`sudo` por ejemplo).

Pero con la opción `--prefix` se puede indicar un destino alternativo. Hagamos eso, instalemos en `~/clojure`

```bash
wget https://download.clojure.org/install/linux-install-1.10.3.986.sh
chmod linux-install-1.10.3.986.sh
./linux-install-1.10.3.986.sh --prefix=~/clojure
...
Installing libs into /home/.../clojure/lib/clojure
Installing clojure and clj into /home/.../clojure/bin
Installing man pages into /home/.../clojure/share/man/man1
```

En la carpeta donde se instaló, las herramientas están en la
 subcarpeta `bin`: `clojure` y `clj`.

`clojure` es la herramienta principal, es una herramienta de línea de
órdenes para iniciar programas escritos en Clojure (el lenguaje).

`clj` es un simple envoltorio alrededor de `clojure` para hacer más
amena la interacción con el "REPL".

En la subcarpeta `share/man` se encuentra el manual en línea de estas
herramientas.

Entonces recomiendo indicarle al sistema la ubicación de estas
herramientas y sus manuales:

 - Añadiendo a la variable de entorno `PATH` la subcarpeta `bin`
 - Añadiendo una entrada `MANDATORY_MANPATH` al archivo `.manpath` del «$HOME».
 
