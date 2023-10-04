
# Tabla de Contenidos

1.  [Día 3: El Principio de sólo una Responsabilidad (SRP)](#org79ae119)
    1.  [Breve historia de los principios SOLID](#orgdcff3b1)
    2.  [Una Exhortación a la Profesionalización de la Industria del Software](#org7c625eb)
    3.  [El Software es Diferente](#org2df7dda)
        1.  [Detalles sospechosos](#orgd309386)
        2.  [Cómo lograr flexibilidad y robustez](#org75ab141)
    4.  [Principio de sólo una Responsabilidad (SRP)](#orgcee7e4f)
        1.  [Ejemplo](#org3e25224)

Desde el pasado 6 de septiembre hasta el 13 de diciembre, todos los
miércoles (excepto por 2) [Robert C. Martin](https://es.wikipedia.org/wiki/Robert_C._Martin) (mejor conocido como «El
tío Bob»), ha impartido y estará impartiendo una clase magistral
dedicada a la Arquitectura de Software.

Cada clase dura aproximadamente 2 horas y es impartida por Zoom.

Por mi parte, dedicaré una entrada al blog por cada clase a la que
asista, con la intención de registrar parte de mis notas y las
reflexiones que me surjan cada vez.


<a id="org79ae119"></a>

# Día 3: El Principio de sólo una Responsabilidad (SRP)

Esta es la primera clase donde se trató directamente uno de los
principios «SOLID»: El Principio de sólo una Responsabilidad, SRP de
sus siglas en inglés (*Single Responsability Principle*).

Pero antes de tratar ese tema en particular, fue necesario presentar
una breve historia de los principios SOLID.


<a id="orgdcff3b1"></a>

## Breve historia de los principios SOLID

El 15 de marzo de 1995, en el [grupo de noticias USENET](https://es.wikipedia.org/wiki/Usenet#ISPs_y_servidores_de_noticias) `comp.object`,
Jim Fleming publicó una lista preliminar de «Los 10 mandamientos de la
Programación Orientada a Objetos».

Robert C. Martin respondió con su lista de lo que consideraba eran
[unos principios más importantes](https://groups.google.com/g/comp.object/c/WICPDcXAMG8/m/EbGa2Vt-7q0J). Esta lista fue la semilla que luego
se convirtió en los principios SOLID.

La principal influencia de esta lista vino de un proyecto de software
memorable para Robert C. Martin.

Este fue un proyecto de Software de gran envergadura para el «Consejo
Nacional de Arquitectos», donde el plan A fracasó. Ellos iniciaron el
proyecto creando un «Framework» que luego utilizarían para crear 36
aplicaciones. Cuando estaban ya realizando la 3ra aplicación, el
«Framework» se volvió más un problema que una solución. Fue tan grave
el asunto que decidieron  empezar de cero (0).

Para el segundo intento, empezaron creando las aplicaciones
independientemente, con la disciplina de ir coleccionando componentes
reusables en su nuevo «Framework» (que empezó vacío), pero con la
restricción de que todo lo que era aceptado en el Framework debía
funcionar con todas las aplicaciones construidas hasta el momento.

Luego que unas 3 aplicaciones siguiendo esta regla, ya contaban con un
«Framework» bastante estable, y que no requirió muchos más cambios al
final del proyecto, para cuando lograron desarrollar las 36
aplicaciones.

Esta fue una historia bien interesante. Tal vez nos enseña que la
dirección de un proyecto de software debe ser siempre darle prioridad
a la aplicación (al uso).

Pero en lo que compete a este artículo, fue la base «moral» con la que
Robert C. Martin definió esos proto-principios como respuesta a «Los
10 mandamientos» que luego se transformarían en los principios SOLID.

El libro de referencia de los principios SOLID, según Robert
C. Martin, es «Desarrollo de Software Ágil: Principios, Patrones y
Prácticas», a pesar de que para entonces, ese acrónimo no lo usaba
(fue un amigo de él que le sugirió reordenar la presentación
de los principios para que formaran la palabra SOLID (sólido en
inglés)).


<a id="org7c625eb"></a>

## Una Exhortación a la Profesionalización de la Industria del Software


<a id="org2df7dda"></a>

## El Software es Diferente

No puedes equiparar la construcción de software con la construcción de
edificios, porque los costos de sus etapas difieren en demasía.

El plano de un edificio cuesta poco en comparación con el costo de la
edificación.

Pero en software, el programa en ejecución o el ejecutable, lo
equivalente al edificio es relativamente gratis pero los planos, que
serían el código fuente, cuestan relativamente todo.

Además, hacer cambios en una edificación real cuesta mucho, pero en
software los cambios se hacen directamente en los «planos» y el costo
es relativamente bajo.

<table border="2" cellspacing="0" cellpadding="6" rules="groups" frame="hsides">


<colgroup>
<col  class="org-left" />

<col  class="org-left" />

<col  class="org-left" />
</colgroup>
<thead>
<tr>
<th scope="col" class="org-left">Costos</th>
<th scope="col" class="org-left">Arquitectura Material</th>
<th scope="col" class="org-left">Arquitectura de Software</th>
</tr>
</thead>

<tbody>
<tr>
<td class="org-left">«Planos»</td>
<td class="org-left">Bajo</td>
<td class="org-left">Mucho</td>
</tr>


<tr>
<td class="org-left">«Edificación»</td>
<td class="org-left">Mucho</td>
<td class="org-left">Casi nulo</td>
</tr>


<tr>
<td class="org-left">Cambio</td>
<td class="org-left">Alto</td>
<td class="org-left">Poco</td>
</tr>
</tbody>
</table>

Por estos motivos, el desarrollo de software tiende naturalmente a ser
«evolutivo».


<a id="orgd309386"></a>

### Detalles sospechosos

El desarrollo evolutivo tiene sus propias ventajas y desventajas.

Si no se diseñan con cuidado las soluciones, o como otros lo
presentan, si no se cría y cuida durante su crecimiento, el producto
puede resultar en algo desastroso.

Durante su desarrollo, debemos estar atentos a las señales que nos
indican que el producto está por deteriorarse.

En inglés le dicen a estas señales «Design Smells». Aquí les diremos,
«Detalles sospechosos».

1.  Rigidez

    Es la tendencia del Sistema a dificultar su cambio.
    
    Si alguna vez estás frente a un sistema que tiene un «bug», sabes
    dónde está, qué lo causa, pero no puedes eliminarlo sin invertir
    muchos días de trabajo, están frente a un sistema rígido.

2.  Fragilidad

    Es la tendencia del Sistema a estropearse si cambia.
    
    Parecido al caso anterior, pero no cuesta mucho supuestamente corregir
    el «bug», pero en cambio, el sistema se estropea en algún lugar que no
    estaba evidentemente relacionado con el cambio que aplicaste. En este
    caso, estás frente a un sistema frágil.
    
    Una de las causas más comunes de la fragilidad es un conjunto de
    interdependencias escondidas entre módulos.
    
    Una consecuencia típica de un sistema Frágil es que después de muchas
    «fracturas», una rigidez «formal» es declarada por alguna autoridad.

3.  Inmovilidad

    Es la tendencia de un sistema a evitar que sus componentes se muevan a
    otros sistemas.
    
    Ejemplo, un módulo que quisieras reutilizar de un proyecto, pero que
    no puedes utilizar sin llevar junto con él todo el proyecto, sufre de
    inmovilidad.

4.  Viscosidad

    Es la tendencia de un Sistema de facilitar cambios malos y hacer
    difícil cambios buenos.
    
    Algunas causas comunes son:
    
    -   Tiempos de compilación alto
    -   Tiempos de pruebas alto
    
    Estas son causas porque los altos tiempos hacen que las personas
    realices esas actividades. Entonces, si no «compilas» frecuentemente,
    no obtienes «feedback» del sistema con suficiente
    frecuencia. Igualmente pasa con las pruebas.
    
    Y no obtener feedback frecuentemente causa la proliferación de errores.

5.  Ejemplo de un programa «pudriéndose»

    Supón que te piden un programa que simplemente imprima los caracteres
    que recibe por el teclado directamente en la impresora.
    
    1.  Versión 1
    
        De forma trivial, en pseudo C:
        
            void copy(void)
              {
                int ch;
                while( (ch=ReadKeyboard()) != EOF)
                  WritePrinter(ch);
              }
    
    2.  Versión 2
    
        Pero luego te piden que también leas del «paper tape». Ok&#x2026;
        
        Tal vez es muy tarde para cambiar la firma de la función, porque ya
        habrán personas usándola. Hubiera sido útil usar un parámetro pero no
        se puede.
        
        Solución: una variable global (sarcasmo).
        
            bool GtapeReader = false;
            // remember to clear
            
              void copy(void)
              {
                int ch;
                while( (ch=GTapeReader ?
                           ReadTape() :
                           ReadKeyboard()) != EOF)
                  WritePrinter(ch);
              }
    
    3.  Versión 3
    
        Nuevamente, te piden un cambio. Esta vez, quieren que puedas imprimir
        en el «tape punch».
        
        Ok, ya te imaginas que va a pasar. Una nueva variable global, una
        nueva expresión ternaria (a?b:c).
        
        En pocas palabras, le código se está pudriendo.
    
    4.  Versión CORRECTA
    
        Pero si al principio, el programa hubiera sido escrito de esta manera:
        
            void copy(void)
              {
                int c;
                while( (ch=getchar()) != EOF)
                  putchar(ch);
              }
        
        La diferencia es que las funciones `getchar` y `putchar` no saben a
        ciencia cierta con qué dispositivos estarán trabajando, sólo sabed de
        un dispositivo de entrada estándar y un dispositivo de salida
        estándar. De esta manera, esta versión del programa habría satisfecho
        todos los requerimientos presentados sin necesidad de cambiar nada.
        
        Y este es el objetivo de este curso. Poder desarrollar sistemas que
        pueda adaptarse fácilmente a cambios de requerimientos (flexibles) y
        que puedan soportar cambios en las condiciones del entorno (robustos).


<a id="org75ab141"></a>

### Cómo lograr flexibilidad y robustez

Lograremos flexibilidad y robustez principalmente ordenando los
componentes de un sistema pertinentemente alrededor de sus
responsabilidades, buscando una independencia tal que los cambios no
se propaguen entre ellos (es decir, que si hacemos un cambio en un
módulo, no tengamos que hacer cambios en muchos otros, idealmente 0).

Puede decirse que buscamos establecer «contra-fuegos» para contener los
efectos colaterales de los cambios.

Los principios SOLID están pensados para eso.


<a id="orgcee7e4f"></a>

## Principio de sólo una Responsabilidad (SRP)

Este es el principio más malinterpretado. La razón es su nombre. Las
personas los confunden mucho con la filosofía Unix: «Haz una sola
cosa, y hazla bien».

Originalmente descrito por [Bertrand Meyer](https://es.wikipedia.org/wiki/Bertrand_Meyer), este principio no se trata
de lo que un sistema puede hacer, sino de a quién le rinde cuentas. La
idea es que un sistema, módulo o componente le debería rendir cuentas
idealmente a un solo Usuario.

Una revelación muy importante dada expuesta por este principio es que
son los Usuarios quienes causan los cambios.

Otro asunto que hay que aclarar es que este concepto de Usuario es
sinónimo de Rol. Entonces, un sistemas con muchos Usuarios, en este
contexto, no se trata de un sistema que tiene muchas cuentas, o es
multijugador, etc. Se trata de un sistema que puede ser UTILIZADO de
diferentes maneras, tantas como roles haya establecido.

Entonces, la idea es que al momento de diseñar un Sistema, componente
o módulo, lo primero que debe quedar claro es cuales Roles pueden
causar cambios en él, y si ese número es más de 1, entonces rediseñar,
tal vez descomponiendo en elementos más pequeños y segregando por
roles.


<a id="org3e25224"></a>

### Ejemplo

Me queda pendiente mostrarles el ejemplo. En una próxima actualización
de esta entrada lo agregaré.

