{:title "Clase magistral de arquitectura y diseño (día 2)"
 :layout :post
 :tags ["es" "arquitectura" "software" "programación" "desarrollo" "diseño" "limpio" "limpia" "organizado" "organizada" "tío bob" "robert c. martin"]}

Desde el pasado 6 de septiembre hasta el 13 de diciembre, todos los
miércoles (excepto por 2) [Robert C. Martin](https://es.wikipedia.org/wiki/Robert_C._Martin) (mejor conocido como «El
tío Bob»), ha impartido y estará impartiendo una clase magistral
dedicada a la Arquitectura de Software.

Cada clase dura aproximadamente 2 horas y es impartida por Zoom.

Por mi parte, dedicaré una entrada al blog por cada clase a la que
asista, con la intención de registrar parte de mis notas y las
reflexiones que me surjan cada vez.


# Día 2: Paradigmas y personajes históricos

La intención de esta clase era presentar lo que a juicio de Robert
C. Martin representan los elementos fundamentales de la arquitectura
de software, o los «bloques de construcción», que son los 3 grandes
paradigmas de programación:

-   La programación estructural
-   La programación orientada a objetos
-   La programación funcional

Pero siendo esta una clase del tío Bob, terminó siendo mucho más que
eso y nos regaló una clase de la historia de la programación.

La forma en que lo hizo fue mediante la presentación de personajes
históricos que determinaron de una forma u otra estos tres paradigmas
de programación.

Los personajes presentados de alguna u otra forma durante la clase
fueron:

-   [Charles Babbage](https://es.wikipedia.org/wiki/Charles_Babbage)
-   [Augusta Ada King](https://es.wikipedia.org/wiki/Ada_Lovelace)
-   [Alan Turing](https://es.wikipedia.org/wiki/Alan_Turing)
-   [David Hilbert](https://es.wikipedia.org/wiki/David_Hilbert)
-   [Edsger Wybe Dijkstra](https://es.wikipedia.org/wiki/Edsger_Dijkstra)
-   [Corrado Böhm](https://es.wikipedia.org/wiki/Corrado_B%C3%B6hm)
-   [Giuseppe Jacoppini](https://it.wikipedia.org/wiki/Giuseppe_Jacopini)
-   [Ole-Johan Dahl](https://es.wikipedia.org/wiki/Ole-Johan_Dahl)
-   [Kristen Nygaard](https://es.wikipedia.org/wiki/Kristen_Nygaard)
-   [Bjarne Stroustrup](https://es.wikipedia.org/wiki/Bjarne_Stroustrup)
-   [Alan Kay](https://es.wikipedia.org/wiki/Alan_Kay)
-   [Alonzo Church](https://es.wikipedia.org/wiki/Alonzo_Church)
-   [John McCarthy](https://es.wikipedia.org/wiki/John_McCarthy_(cient%C3%ADfico))

No pretendo repetir aquí toda la historia. Pero sí dejaré los puntos
necesarios para soportar el argumento de esta clase.

La síntesis de esta clase se reduce a que estos 3 paradigmas de
programación ofrecen cada uno un valor arquitectónico importante. Los
3 valores son restricciones impuestas a los programadores, que
facilitan un orden importante en el código de los programas. Sin
dichas restricciones, se hubiera requerido una disciplina casi
inhumana para conseguir tal orden.

Éstas son restricciones sobre:

-   La transferencia directa del control del flujo de instrucciones
-   La transferencia indirecta del control de flujo de instrucciones
-   La asignación de valores (o mutabilidad)


## Paradigmas

### Programación Primitiva

El término «programación primitiva» lo introduzco yo para ubicar esta
era en la narrativa cronológica utilizada por Robert C. Martin.

Esta era empieza en el siglo XIX con [Babbage](https://es.wikipedia.org/wiki/Charles_Babbage), sus máquinas de
[diferencias](https://es.wikipedia.org/wiki/M%C3%A1quina_diferencial) y [analíticas](https://es.wikipedia.org/wiki/M%C3%A1quina_anal%C3%ADtica), y [Augusta Ada King](https://es.wikipedia.org/wiki/Ada_Lovelace), quien en forma de
anotaciones extra que introdujo en una traducción al inglés que hizo
del diseño de la máquina analítica, escribió el primer programa para
demostrar el uso de dicha máquina.

Esta máquina analítica nunca se construyó, pero llegó a inspirar a los
pioneros de la computación a inicios del siglo XX.

En esta primera era de la programación, los programadores contaban con
la simple idea de que puedes listar una serie de instrucciones para
que un computador ejecute una tras otra.

Y sólo con esa idea, se desarrollaron los primeros programas de cuya
experiencia las personas empezaron a notar problemas y patrones.

Subrutinas, punto flotante, aritmética y lógica, etc., no eran
desconocidos: todo lo necesario para programar existía.

Pero faltaba la disciplina que sólo la experiencia y los años pueden
dar.

[Alan Turing](https://es.wikipedia.org/wiki/Alan_Turing) mismo, dada su experiencia al escribir sus primeros
programas comentó y predijo acerca de la programación que:

«Necesitaremos un gran número de matemáticos hábiles» porque
«probablemente habrá bastante trabajo de este tipo» y «una de nuestras
dificultades será mantener una disciplina apropiada, para no perder el
hilo de lo que vamos haciendo».

Note: El tío Bob recomienda el libro [The annotated Turing](https://www.google.ca/books/edition/The_Annotated_Turing/LFQ7DwAAQBAJ?hl=en&gbpv=0) de Charles
Petzold.


### Programación Estructurada

De la necesidad de tratar de demostrar formalmente la «correctitud» de
un programa, [Dijkstra](https://es.wikipedia.org/wiki/Edsger_Dijkstra) notó que la existencia de la transferencia de
control indiscriminada (por ejemplo, con la instrucción [GOTO](https://es.wikipedia.org/wiki/GOTO)) no hacía
posible determinar si un programa era correcto o no.

Entonces, junto con [Böhm](https://es.wikipedia.org/wiki/Corrado_B%C3%B6hm) y [Jacopini](https://it.wikipedia.org/wiki/Giuseppe_Jacopini), quienes establecieron que todo
programa se puede reducir en secuencias, selecciones y repeticiones
([Teorema del programa estructurado](https://es.wikipedia.org/wiki/Teorema_del_programa_estructurado)), describieron la programación
estructurada basada en estos 3 elementos.

Y esta fue la solución al problema que señaló [Dijkstra](https://es.wikipedia.org/wiki/Edsger_Dijkstra) del `GOTO`: Un
modelo de programación que no lo necesita.

Entonces, obtuvimos la primera restricción:

<span class="underline">Disciplina en la transferencia directa de control</span>; o evitar la
transferencia directa del control.

1.  «Demostrabilidad» vs el Método Científico

    Al día de hoy, la práctica más normal es escribir pruebas que
    descarten errores. Todavía no podemos escribir pruebas que demuestren
    que un programa es correcto, para todos los posibles programas que
    podamos escribir.
    
    En este sentido, nuestra disciplina se parece más a la Ciencia que a
    las Matemáticas.


### Programación Orientada a Objetos

Luego [Ole-Johan Dahl](https://es.wikipedia.org/wiki/Ole-Johan_Dahl) junto con [Kristen Nygaard](https://es.wikipedia.org/wiki/Kristen_Nygaard), inventaron la
[Programación Orientada a Objetos](https://es.wikipedia.org/wiki/Programaci%C3%B3n_orientada_a_objetos): casi sin darse cuenta. Lo hicieron
cuando crearon el lenguaje [Simula](https://es.wikipedia.org/wiki/Simula), modificando el compilador del
lenguaje [Algol](https://es.wikipedia.org/wiki/ALGOL), moviendo el marco de las llamadas a las funciones de
la Pila al Montículo.

Sobre esta innovación [Bjarne Stroustrup](https://es.wikipedia.org/wiki/Bjarne_Stroustrup) creo [C++](https://es.wikipedia.org/wiki/C%2B%2B) y [Alan Kay](https://es.wikipedia.org/wiki/Alan_Kay) creo
[Smalltalk](https://es.wikipedia.org/wiki/Smalltalk).

Pero de todas las nuevas innovaciones que la Programación Orientada a
Objetos nos trajo, la más importante desde la perspectiva de la
arquitectura del software es la siguiente restricción:

<span class="underline">Disciplina en la transferencia indirecta de control</span>.

El punto es que antes de la Programación Orientada a Objetos, el
[polimorfismo](https://es.wikipedia.org/wiki/Polimorfismo_(inform%C3%A1tica)) se lograba con apuntadores a funciones, pero esta
práctica fue considera peligrosa y escasamente usada, excepto en
programación de sistemas (por ejemplo, el desarrollo de sistemas
operativos).

La programación orientada a objetos rescató y popularizó esta técnica
haciéndola una práctica segura.

Esta práctica es especialmente importante en la arquitectura de
software porque permite la [Inversión de Dependencia](https://es.wikipedia.org/wiki/Principio_de_inversi%C3%B3n_de_la_dependencia).

Estae es una característica presente en la relación que hay entre dos
«módulos» donde la dirección del flujo de control va en dirección
contraria a la dirección de la relación de dependencia, permitiendo
una independencia entre módulos tal que se puede modificar o cambiar
completamente un módulo sin tener que notificar al otro.


### Programación Funcional

Finalmente la [Programación Funcional](https://es.wikipedia.org/wiki/Programaci%C3%B3n_funcional) es presentada como un antiguo
paradigma que resurgió en popularidad debido a que las computadoras
dejaron de seguir la ley de Moore, causando la proliferación de
computadoras de múltiples núcleos y poniendo en la palestra la
programación concurrente.

La principal dificultad de la programación concurrente es la
coordinación del acceso y uso de los recursos compartidos.

En este contexto, la programación funcional resalta.

La programación funcional favorece la proliferación de funciones
puras. Estas funciones, entre otras cosas, garantizan la inmutabilidad
de los datos: porque es condición necesaria para que una función sea
pura.

Como consecuencia, un programa escrito siguiendo el paradigma de
programación funcional minimiza el código que sí modifica el estado
de los datos.

Así queda confinado en lugares predecibles y pequeños los mecanismos
que tienen que lidiar con los problemas de la concurrencia.

Entonces podemos decir que la programación funcional nos regaló a
nivel arquitectónico:

<span class="underline">Disciplina en la mutabilidad</span>.


### Conclusión

En estos 70 años de la computación hemos aprendido sobre todas las
cosas, qué no hacer:

-   La programación estructurada nos impuso una disciplina sobre la
    transferencia directa de control
-   La programación orientada a objetos nos impuso una disciplina sobre
    la transferencia indirecta de control
-   Y la programación funcional nos impuso una disciplina sobre las
    asignaciones (o mutabilidad)

Entonces, una definición de arquitectura que se relaciona con estos
paradigmas, es:

-   Una **conducta** concreta,
-   **Organizada** en una **estructura**
    -   **Flexible**
    -   y **mantenible**
-   que de manera **Segura**
    
    -   **Transporta**
    -   y **Transforma**
    
    -   los **datos** y **eventos** que **recibe**
    -   en aquello que **produce**

