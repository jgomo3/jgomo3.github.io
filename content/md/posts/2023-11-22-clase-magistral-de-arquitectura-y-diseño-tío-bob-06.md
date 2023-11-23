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

¿Cómo diseñarías un programa con el que pudieras encender (sólamente
encender) un bombillo?

¿Cómo modelarías el sistema?

### Modelo sencillo

Un primer modelo muy sencillo pudiera ser el siguiente:

![img](/img/bombillo-simple.svg)

Pero...

### Principio Abierto/Cerrado

Pero los interruptores pueden usarse para encender otros dispositivos
además de los bombillos.

¿Qué tal si definimos una interface entre el interruptor y el
bombillo, que el bombillo pueda implementar y el interruptor utilizar
para *encender* el bombillo?

![img](/img/bombillo-interface.svg)

Y gracias a este cambio, el programa puede adaptarse fácilmente para
que el interruptor pueda *encender* otros dispositivos (televisores,
licuadores, ventiladores, etc.)

![img](/img/interruptor-extendido.svg)

Aquí vemos en práctica el Principio «Abierto/Cerrado». Hemos extendido
el programa anterior sin modificar los componentes existentes.

### Nomenclatura

Parece un buen plan. Entonces, ¿Qué nombre le ponemos a esa interface?

Una tendencia popular hace muchos años era darle prioridad a los
componentes que implementan las interfaces sobre los componentes que
los usa.

Si siguiéramos esa tendencia, el nombre sería «Bombillo Abstracto».

Pero ese nombre no colabora con la idea «Abierto/Cerrado»; no es útil
para significar la extensión del programa para los otros dispositivos.

Por eso la otra tendencia ha sido la dominante: darle prioridad a los
usuarios de las interfaces.

Seguiremos esta dirección y por ende el nombre sería «Encendible».

Pero tenemos otro problema ...

### Propiedad de los componentes

¿Qué sucede si no tenemos el control de los dispositivos?¿Qué tal si
fueran componentes de software mantenidos por terceros?.
