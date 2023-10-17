{:title "Clase magistral de arquitectura y diseño (día 4)"
 :layout :post
 :tags ["es" "arquitectura" "software" "programación" "desarrollo" "diseño" "limpio" "limpia" "organizado" "organizada" "tío bob" "robert c. martin" "principios" "ocp" "open close principle" "principio abierto/cerrado" "solid"]}
 
Desde el pasado 6 de septiembre hasta el 13 de diciembre, todos los
miércoles (excepto por 2) [Robert
C. Martin](https://es.wikipedia.org/wiki/Robert_C._Martin) (mejor
conocido como «El tío Bob»), ha impartido y estará impartiendo una
clase magistral dedicada a la Arquitectura de Software.

Cada clase dura aproximadamente 2 horas y es impartida por Zoom.

Por mi parte, dedicaré una entrada al blog por cada clase a la que
asista, con la intención de registrar parte de mis notas y las
reflexiones que me surjan cada vez.

# Día 4: El Principio Abierto/Cerrado (OCP)

Diseña Sistemas «Abiertos» o permisivos a extenderse, pero «Cerrados»
o prohibitivos a modificarse. Otra forma de decirlo: Diseña Sistemas
de manera que cuando vayas a cambiarlo, el cambio sea por medio de
añadir extensiones, y no haciendo modificaciones internas.

¿Cómo? Aquí un método: segrega la conducta extensible detrás de una
interfaz abstracta. Y luego invierte las dependencias.

Para poder esclarecer esto, usamos el mismo ejemplo de la clase pasada
del programa que debe copiar lo que se escribe en un dispositivo en
otro.

La solución final tenía esta forma:

![img](/img/copy-uml-final.svg)

En este sistema, la interfaz «File» es la mencionada interfaz
abstracta que oculta detrás de ella esa «conducta extensible». La
oculta al componente «Copy».

Este ejemplo ilustra la extensibilidad con el simple hecho de
que hay más de un componente que se «comporta» como un «archivo»
(«File»), a saber «KeyboardIODriver» y «PrinterIODriver». Esta
multiplicidad sugiere que pueden haber más componentes «extendiendo»
esta conducta definida por «File».

Finalmente, «Copy» no depende de componentes concretos si no
abstractos: en este caso depende de la interfaz «File».

Sin la interfaz de por medio, «Copy» tendría que depender
directamente de los componentes «KeyboardIODriver» y
«PrinterIODriver». En ese caso, esos componentes no dependerían de
nadie. Pero en la solución planteada, causa que dependan de la
interfaz abstracta «File». Aquí es donde se ilustra la «inversión de
dependencias» sugerida al principio.

Claro, después de solucionado un problema, siempre parece fácil. Pero
el problema original no es tan sencillo: determinar cuál es esa
conducta extensible.

Bueno, ese es nuestro trabajo como diseñadores. Pero una vez detectada
esa conducta extensible, y si queremos seguir el Principio
Abierto/Cerrado, debemos asegurarnos de que la conducta extensible
esté protegida con una Interfaz abstracta.

**Nota:**

El término *Interfaz* no es exclusivo de la programación orientada a
objetos. Es simplemente la idea de un componente de un sistema que
permite a otro componente conectarse con otros, sin que estos se
«conozcan» entre si. Piensa en la toma de corriente de una pared. Esta
«interfaz» le permite al Sistema Eléctrico conectarse con cualquier
aparato eléctrico que tenga un enchufe compatible.

## Implicaciones

Si tratas de respetar este principio, entonces **idealmente** pasará
que:

- Cada vez que añadas una nueva característica o funcionalidad:
  - Lo harás añadiendo nuevo código.
  - No modificando el código existente.
- Dado que el código no se modifica:
  - Pudieras escribir tus módulos una sola vez (bien y bellos).
  - Y no te deberías preocupar porque en el futuro se estropeen.

Nota la palabra **idealmente**. Es una situación extrema. Obviamente
el código de cualquier proyecto cambiará internamente: el cambió no se
hará exclusivamente con agregados.

Pero la implicación lógica de la aplicación absoluta de este principio
muestra las ventajas de esforzarse en seguirlo.

## Observación acerca del punto de vista del Cliente

Una coincidencia interesante es que desde el punto de vista de los
clientes, cuando ellos piden una nueva característica en el sistema,
normalmente los clientes están pensando en añadir algo nuevo, y no
están imaginando cambios internos a lo que ya existe.

Esto coincide con el Principio Abierto/Cerrado. Muchas veces los
Clientes piensan de esta manera, y no comprenden porqué puede ser tan
difícil la «añadidura» de una nueva funcionalidad. Cuando este dilema
pasa, por más que el cliché dice que los clientes no entienden nada y
subestiman a los programadores, en realidad casi siempre es una señal
de que el sistema tiene una falla de diseño relacionada con no haber
seguido este principio.

Y es que **idealmente**, añadir nuevas funcionalidades y
características debería ser "fácil".

Y para lograr esta facilidad hay que esforzarse muchísimo a nivel
arquitectónico. Este esfuerzo implica una gran disciplina, buen gusto
y experiencia, conocimiento y profesionalismo. Es el trabajo de
mantener un buen diseño del sistema. Es un trabajo MUY DIFÍCIL
(«simple is hard»).

Pero como se explicó en las primeras clases: El Software en esencia
debe ser Fácil de cambiar.
