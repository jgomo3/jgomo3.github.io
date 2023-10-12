{:title "Clase magistral de arquitectura y diseño"
 :layout :post
 :tags ["es" "arquitectura" "software" "programación" "desarrollo" "diseño" "limpio" "limpia" "organizado" "organizada" "tío bob" "robert c. martin"]}

![img](https://blog.cleancoder.com/uncle-bob/images/2012-08-13-the-clean-architecture/CleanArchitecture.jpg)

Desde el pasado 6 de septiembre hasta el 13 de diciembre, todos los
miércoles (excepto por 2) Robert C. Martin (mejor conocido como «El
tío Bob»), ha impartido y estará impartiendo una clase magistral
dedicada a la Arquitectura de Software.

Cada clase dura aproximadamente 2 horas y es impartida por Zoom.

Por mi parte, dedicaré una entrada al blog por cada clase a la que
asista, con la intención de registrar parte de mis notas y las
reflexiones que me surjan cada vez.


# El Tío Bob

Robert C. Martin es un personaje muy influyente en el mundo de la
Computación, particularmente en el área del desarrollo de Software, y
más precisamente en el mundo del desarrollo de software Empresarial.

Creo que es principalmente conocido por describir y promover un
conjunto de principios de programación que, en conjunto, acuñó como
[SOLID](https://es.wikipedia.org/wiki/SOLID).

También es reconocido por ser uno de los autores de el [Manifiesto por
el Desarrollo Ágil de Software](https://agilemanifesto.org/iso/es/manifesto.html).

De Robert C. Martin he leído su libro de Arquitectura Limpia, su
blog, algunos de sus videos en [cleancoder.com](http://cleancoder.com) y varias entrevistas.

Además de su influencia en la industria que indirectamente nos influye
a todos, creo que el artículo de él que más me ha afectado
personalmente fue [su entrada en el blog donde explica su idea de
Arquitectura Limpia](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html), que resonó mucho con mi experiencia profesional
y desde entonce empecé a ver la arquitectura con otros ojos.


# Día 1: ¿Quién, qué y por qué?

## Las reglas de la arquitectura de software no cambian.

Esencialmente el Software siempre ha sido **secuencia**, **selección** y
**repetición**.

Y las reglas de la arquitectura de software siempre han sido y por
muchos años más serán las mismas.

Esta afirmación se sustenta principalmente en la experiencia.

Robert C. Martin (y seguramente muchos otros), como testigos de buena
parte de la evolución de la industria de la Computación, han observado
este fenómeno de «inmutabilidad» de las reglas de la arquitectura del
software.

Como contraste, considere la magnitud del cambio que sí ha
experimentado la Computación desde sus inicios al día de hoy. Dice el
cliché que con la computadora que tienes en tu movil, en tu bolsillo,
fácilmente pudieras haber «llegado a la luna» en los años 60.

La promesa de este curso es estudiar esas reglas, que se cumplían
desde hace 70 años (más o menos), se siguen cumpliendo hoy, y se
seguirán cumpliendo por muchos años más.

«Esta falta de cambio del código es la razón de que la arquitectura
de software sea tan consistente a través de todos los tipos de
sistemas. Las reglas de la arquitectura de software son las reglas que
regulan cómo ordenar y ensamblar los componentes básicos de los
programas. Y como esos componentes básicos son universales y no han
cambiado, las reglas par ordenarlos son a su vez universales y no
cambian» - Robert C. Martin.


## Reflexiones y Revelaciónes

Tal vez las 2 ideas más reveladoras para mi durante esta primera clase
fueron:

-   Los 2 valores del Software
-   El Código fuente es Diseño

### Los 2 valores del Software

La naturaleza del Software <span class="underline">ES</span> ser adaptable. De hecho, para eso fue
inventado.

El software es la «pieza» que «insertas» en una computadora para
transformarla en una máquina con un propósito para el cual el diseño
original de la computadora no había considerado.

Al momento de «insertar» una «pieza» de software en una computadora,
la conviertes en algo diferente: tal vez un videojuego, tal vez una
calculadora, tal vez un reproductor de películas.

Inspirados en esta idea, y en la «etimología» de la palabra software,
compuesta por «soft» (flexible) y «ware» (producto), implicando un
«producto flexible», se puede justificar la expectativa que se tiene
de que el Software sea adaptable.

En todo caso, la lección es que es un hecho que todo el mundo espera
que el Software sea adaptable. Es una verdad de la vida que la gente
cambie de opinión y que «los requerimientos» de hoy no serán
exactamente los mismo de mañana.

Tal vez el único que espera que el software no cambie sea el mismo
programador, típicamente con poca experiencia, quien se niega
neciamente a esta realidad.

La tensión está entre el punto de vista de los «Interesados» en el
Software, cuando necesitan cambiar el «alcance» de su operación
(soportada por el software), y la «forma» que tiene el sistema y su
capacidad para adaptarse.

A su vez, la tensión se encuentra también entre la «función» o
«comportamiento» del Sistema y su «forma», cuando este sistema deba
adaptarse al nuevo alcance.

Como los «Interesados» sólo ven la «función», es responsabilidad del
arquitecto darle prioridad al equilibrio «función»/«forma» (o la
arquitectura) para garantizar que siga siendo un sistema resiliente, y
pueda adaptarse una vez más en el futuro, no sólo en este instante.

Si la Arquitectura no es prioridad, llegará un momento en el que el
sistema perderá su capacidad de adaptación, y se estancará. Esto es
INACEPTABLE porque atenta contra le escencia misma del Software.


### El Código fuente <span class="underline">ES</span> Diseño

El arquitecto de una edificación produce, entre otras cosas, un plano
final lleno de muchos detalles técnicos que sirven para que los
constructores e ingenieros puedan materializar el concepto ahí
descrito (el edificio).

Es posible entonces decir que dichos planos detallados son en efecto
una forma de Software, escrito en un lenguaje declarativo, cuya
máquina son los constructores e ingenieros.

Robert señaló que esta «revelación» la conoció gracias a un «paper»
escrito por [Jack Reeves](http://wiki.c2.com/?JackReeves) en 1992 intitualdo [¿Qué es Diseño de Software?](http://www.bleading-edge.com/Publications/C++Journal/Cpjour2.htm)
donde en otras palabras se afirma que [El Código Fuente <span class="underline">ES</span> Diseño](http://wiki.c2.com/?TheSourceCodeIsTheProduct).


## Otras lecciones

### Hacer que funcione es la parte fácil

Hacer que un programa funcione por primera vez es la parte fácil. Lo
más dificil es poder diseñar un sistema que se mantenga útil por mucho
tiempo. Se dice entonces que para lograr esta meta, hay que hacer
«lo correcto» al crear el sistema.

Hacer «lo correct» es la parte difícil.

Sin embargo, la experience ha demostrado que cuando haces «lo
correcto», se facilita la flexibilidad de los sistemas (lo que
les da una mayor pertinencia en el tiempo).

Aquí es donde la productividad de los desarrolladores de Software se
ve directamente impactada por la decisión de entre «hacer lo correcto»
o «hacer que simplemente funcione».

Hacer desorden es siempre más lento que mantenerse ordenado
(limpio). Aunque la intuición diga lo contrario, que desrodenar un
poco sin limpiar ahora, para hacerlo después, pueda parecer más
rápido: Siempre termina siendo más lento.

«Pare ir rápido, hay que ir bien» - Rober C. Martin.


## Acerca de Arquitectura

La arquitectura y el código fuente están relacionados entre si en un
contínuo, donde jerárquicamente la «arquitectura» está en el extremo
«alto», favoreciendo los conceptos de alto nivel de un sistema, y en
el otro extremo «bajo» está el código fuente dedicado a los detalles
de implementación.

Pero como «El código fuente <span class="underline">ES</span> diseño», no existe una división
discreta. En el código fuente <span class="underline">HAY</span> arquitectura, y la arquitectura se
expresa también con código fuente.


### La meta del buen arquitecto

Una buena arquitectura, o un buen diseño, minimiza el esfuerzo
necesario para realizar el producto.


## Adicionalmente

### No le digas a nadie que estás haciendo «Refactoring»

Hacer «refactoring» es una actividad tan necesaria como la de lavarse
las manos antes de operar a alguien, o cocinar.

Ni los doctores, ni los cocineros le piden permiso a nadie para
lavarse las manos. De esa misma manera, un programador no debe pedir
permiso para «refactorizar».


### Métricas para la productividad del desarrollo de Software

Las líneas de código de un programa pueden y han sido utilizadas como
métrica para medir el desempeño del proceso de desarrollo.

Sin embargo, [Tom deMarco](https://en.wikipedia.org/wiki/Tom_DeMarco), en su Libro «Controlar Proyectos de
Software», rechaza esta métrica y sugiere transformar el código fuente
con una técnica que en efecto es parecida a los algoritmos de
compresión de datos, y medir el tamaño de esos resultados.

La idea es que al transformar los datos de esa manera, se obtiene algo
muy cercano al mínimo número de «tokens» necesario para representar la
información original. Entonces, la comparación entre dos versiones de
código, transformadas de dicha manera, sería más justa que simplemente
compararlas en términos de las líneas de código.


# Finalmente

Aparte de lo mencionado, Una cosa más aprendí en este día: Una clase
del «Tío Bob» está complementada con una basta cantidad de gemas de
sabiduría y cultura general del área de la Computación. Sólo por esto
justificaría el curso.

