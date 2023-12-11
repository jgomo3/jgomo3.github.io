{:title "Clase magistral de arquitectura y diseño (día 6) - Principio de Segregación de Interfaces"
 :layout :post
 :tags ["es" "arquitectura" "software" "programación" "desarrollo" "diseño" "limpio" "limpia" "organizado" "organizada" "tío bob" "robert c. martin" "principios" "psi" "isp" "principio de segregaión de interfaces" "solid"]}

Desde el pasado 6 de septiembre hasta el 13 de diciembre, todos los
miércoles (excepto por 2) [Robert
C. Martin](https://es.wikipedia.org/wiki/Robert_C._Martin) (mejor
conocido como «El tío Bob»), ha impartido y estará impartiendo una
clase magistral dedicada a la Arquitectura de Software.

Cada clase dura aproximadamente 2 horas y es impartida por Zoom.

Por mi parte, dedicaré una entrada al blog por cada clase a la que
asista, con la intención de registrar parte de mis notas y las
reflexiones que me surjan cada vez.

# Día 6: El Principio de Segregación de Interfaces (ISP)

## Ejercicio de diseño ¿Cómo encender un bombillo?

¿Cómo diseñarías un programa con el que pudieras encender (solamente
encender) un bombillo?

¿Cómo modelarías el sistema?

### Modelo sencillo

Un primer modelo muy sencillo pudiera ser el siguiente:

![img](/img/bombillo-simple.svg)

Pero...

### Principio Abierto/Cerrado

Pero los interruptores pueden usarse para encender otros dispositivos
además de los bombillos.

¿Qué tal si definimos una interfaz entre el interruptor y el
bombillo, que el bombillo pueda implementar y el interruptor utilizar
para *encender* el bombillo?

![img](/img/bombillo-interfaz.svg)

Y gracias a este cambio, el programa puede adaptarse fácilmente para
que el interruptor pueda *encender* otros dispositivos (televisores,
licuadoras, ventiladores, etc.)

![img](/img/interruptor-extendido.svg)

Aquí vemos en práctica el Principio «Abierto/Cerrado». Hemos extendido
el programa anterior sin modificar los componentes existentes.

### Nomenclatura

Parece un buen plan. Entonces, ¿Qué nombre le ponemos a esa interfaz?

Una tendencia popular hace muchos años era asignar nombres acordes a
los componentes que implementan las interfaces.

Si siguiéramos esa tendencia, el nombre sería «Bombillo Abstracto».

Pero ese nombre no colabora con la idea «Abierto/Cerrado»; no es útil
para significar la extensión del programa para los otros dispositivos.

Por eso la otra tendencia ha sido la dominante: asignar nombres acorde
a los usuarios de las interfaces.

Seguiremos esta dirección y por ende el nombre sería «Encendible».

Pero tenemos otro problema ...

### Propiedad de los componentes

¿Qué sucede si no tenemos el control de los dispositivos? ¿Qué tal si
fueran componentes de software mantenidos por terceros?.

Dejaremos esta pregunta sin contestar por los momentos y la
responderemos en otra clase.

## Orígenes del Principio de Segregación de Interfaces

Alrededor de 1992, Robert trabajó como consultor
C++ experto para Xerox en un proyecto dedicado a desarrollar la
primera copiadora digital a color en red.

![img](/img/xerox-copier.png)

Esta era una copiadora compartida por red, la cual tenía su propio
planificador de tareas (las tareas en este caso serían copiar
documentos).

El sistema fue diseñado tal que había una una clase de la cual muchas
otras dependían. Esta clase era la clase «Tarea».

Un «tarea» describía todos los detalles que necesitaba la copiadora
para realizar su una copia. Tenía información del tamaño de la hora,
si era en blanco y negro o a color, la calidad, etc.

La arquitectura del sistema en algún momento era un conjunto de
módulos, tal que, como ya mencionamos, todos utilizando la misma clase
«Tarea». Algunos de sus módulos eran:

 - Alimentador
 - Cortador
 - Trayectoria del Papel
 - Apilador
 - Receptor de Fotografía
 - Inversor
 - Engrapadora

![img](/img/tarea-v1.svg)

Y cada uno de esos módulos era desarrollado por un equipo diferente,
incluyendo el «Equipo del Planificador de Tareas», que era el
responsable de la clase «Tarea».

Esta arquitectura presentaba un problema: Cada vez que había que hacer
un cambio en la clase «Tarea», todos los otros módulos debían ser
recompilados.

Este era un problema gigante en 1992, ya que el tiempo que se tomaba
un proyecto de esa envergadura para compilar podía tomar muchas horas.

En este contexto, a Robert se le ocurrió una solución basada en
herencia múltiple, una característica nueva de C++ en esa época.

Y la solución tenía esta forma:

![img](/img/tarea-v2.svg)

El razonamiento era que a pesar de que la clase «Tarea» era requerida
por todos los otros módulos, lo que cada módulo necesitaba de «Tarea»
no era necesariamente igual a lo que los otros módulos necesitaban.

Así, si un módulo necesita cambiar algo de «Tarea», ese cambio lo
afecta a él solamente.

Ejemplo, digamos que los programadores del módulo «Alimentador»
descubren que necesitan cambiar una de las funciones de «Tarea» que
ellos usan de manera que deben añadirle un nuevo parámetro. Entonces
los programadores de «Tarea» modifican esa función y los programadores
de «Alimentador» tienen que volver a «compilar y enlazar» su programa
con «Tarea», pero más nadie debe hacerlo. Anteriormente, todos debían
hacerlo.

Lo que logramos con esta reconfiguración es minimizar el número de
cosas de las cuales los módulos dependen a sólo las cosas que
realmente necesitan.

## El Principio

Entonces, ¿Cuál es el principio de segregación de interfaces?.

Dado su origen, su nombre hace referencia a las interfaces. En
realidad, segregar interfaces, como se demostró en el ejemplo, es sólo
una forma de respetar dicho principio. Pero el principio en realidad se
trata, en pocas palabras de que:

**No dependas de cosas que no necesitas**.

Por ejemplo:

 - No dependas de módulos con funciones que no necesites
 - No dependas de componentes con clases que no necesitas
 - No dependas de servicios con «APIs» que no necesitas
 - No dependas de «Frameworks» con artefactos que no necesitas

Pero yo le añadiría un detalle: **Intenta**. Es decir, dejar claro que
la idea es minimizar la cantidad de cosas que no necesitamos pero que
dependemos de ellas como efecto secundario de utilizar cosas que
ofrecen muchas características.
