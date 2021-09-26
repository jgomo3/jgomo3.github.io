{:title "Clojure y Java"
 :layout :post
 :tags ["es" "Clojure" "Java" "borrador"]}

## Clojure el jar (BORRADOR)

Clojure es distribuído en realidad como un paquete `.jar`.

La forma más básica de utilizarlo es ejecutando:

```shell
$ java -jar clojure.jar
```

En cuyo caso, una sesión interactiva con el "REPL" inicia.

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

Pasar un libreto («script») como argumento evita la sesión interactiva
con el "REPL" y Clojure interpreta expresión por expresión dicho
libreto.

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

Con la opción `-m`, Clojure llama la función `-main` del espacio de
nombre que especifiquemos.

Supongamos un archivo llamado `hola.clj` en la carpeta actual, con
este contenido:

```Clojure
(ns hola)

(defn -main [& args]
  (println "Hola Infinitio"))
```

Entonces, esa función `-main` la podemos ejecutar de la siguiente manera:

```Shell
$ java -cp ".:clojure.jar" clojure.main -m hola
```

Nota que utilizamos la forma con el `-cp` en vez del `-jar`. Esto es
debido a que debemos colocar en el Class Path el directorio actual
(`.`) para que consiguiera nuestro archivo `hola.clj`.

Pero ¿cómo obtener el `.jar`?

Una forma de generarlo es siguiendo as instrucciones de la guía de
iniciación («Getting Started») en la sección «Otras maneras de correr
Clojure» («Other ways to run Clojure»)[1]:

```
git clone https://github.com/clojure/clojure.git
cd clojure
mvn -Plocal -Dmaven.test.skip=true package
```

El paquete `clojure.jar` generado tendrá todas las dependencias
necesarias para soportar todo el lenguaje.

[1] https://clojure.org/guides/getting_started#_other_ways_to_run_clojure

## Clojure CLI

Hasta ahora hemos visto cómo utilizar Clojure de forma muy
trivial. Para claridad me refirire a esta forma como `clojure.main`.

Para programas más complejos, dividido en módulos, que dependan de
bibliotecas de terceros, que requieran «recursos», etc., puede ser muy
complicado preparar el entorno de ejecución para que el programa pueda
acceder a dichas elementos.

**clojure.org** pone a nuestra disposición unas herramientas que nos
permite utilizar Clojure de una forma más simple desde la línea de
órdenes, y organiza los elemntos mencionados en el párrafo anterior
(en particular, construyen el Class Path por nosotros).

Estas herramientas se conocen como «Las herramientas para el
Intérprete de la Línea de Órdenes», a las cuales nos referiremos como
«Clojure CLI»

Hay varios métodos de instalación. Cada distribución de Sistema
Operativo muy posiblemente las tendrá a disposición con el nombre de
`clojure`.

Exploraremos aquí la manera de instalar estas herramientas
independientemente de la distribución de Sistema Operativo.

Estas herramientas necesitan:

 - bash
 - java
 - rlwrap (opcional)

En **clojure.org** hay un libreto de instalación. Para el día de hoy,
la versión estable de Clojure es la versión `1.10.3.986`, así que
descargaremos el instalador de dicha versión y lo ejecutamos.

Si no indicamos nada, el instalador intentará instalar las
herramientas a nivel del sistema (`/usr/bin`, etc.). En ese caso,
habría que tener permisos para hacerlo (`sudo` por ejemplo).

Pero con la opción `--prefix` se puede indicar un destino
alternativo. Hagamos eso, instalemos en `~/clojure`

```bash
$ wget https://download.clojure.org/install/linux-install-1.10.3.986.sh
$ chmod linux-install-1.10.3.986.sh
$ ./linux-install-1.10.3.986.sh --prefix=~/clojure
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
 - Enseñandole a `man` cómo encontrar los manuales:
   - Si usas una distribución de Linux basada en Debian, añadiendo
     `MANDATORY_MANPATH` al archivo `.manpath` del «$HOME».
   - Añadiendo una entrada al MANPATH\_MAP que relacione la subcarpeta
     `bin` con la subcarpeta `share/man`.
 
En este caso de ejemplo, y suponiendo un sistema Ubuntu:
 
 ```bash
$ echo 'export PATH="$HOME/clojure/bin/:$PATH"' >> ~/.bashrc
$ echo 'MANDATORY_PATH home/ubuntu/clojure/share/man' >> ~/.manpath
```

Cuando utilizamos Clojure desde la cónsola, normalmente utilizamos
`clj` por ergonomía, y `clojure` en los libretos.

Las Clojure CLI están dirigidas por un archivo llamado `deps.edn`, que
merece su artículo completo.

Como las Clojure CLI son unos envoltorios alrededor de `clojure.main`,
todas las opciones del `clojure.main` están a nuestra
disposición. `-M` indica ejecutar `clojure.main`:

```Shell
$ clj -M -e '(+ 1 1)'
```

Además de ellas, hay opciones para controlar las
direcciones establecidas por el `deps.edn`.

Creo que debo detener el artículo aquí. Mi intención era establecer un
puente entre las Clojure CLI y el `clojure.main`.
