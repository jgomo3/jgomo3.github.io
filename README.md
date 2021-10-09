# jgomo3.info

Contenido fuente del sitio [jgomo3.info](http://jgomo3.info/), que
contiene básicamente información pública de mi persona y artículos que
escribiría en forma de «blog».

Está página:

 - Está hospedada en [Github Pages](https://pages.github.com/) (GHP)
 - No usa [Jekyll](https://jekyllrb.com/) (y por ende no goza de su
   integración con GHP)
 - Usa el generador de páginas estáticas
   [Cryogen](http://cryogenweb.org/)
 
Por esto, el contenido de la rama «master» contiene sólo el producto
generado por Cryogen. La «fuente» la desarrollo en la rama «dev».

# Crear nuevo contenido

El contenido lo creas escribiendo o «entradas» del blog o «páginas».

La diferencia es que la «entrada» tiene una fecha de publicación que
es relevante, y la «página» no.

En cualquier caso, se crea el contenido en un archivmo Markdown, en
`content/md/posts` para las entradas y en `content/md/pages` para las
páginas.

El nombre de los archivos para las entradas sigue un formato especial:

`<fecha>-<nombre>.md`

Donde la fecha normalmente es `MM-dd-YYYY`, pero puedes verificarlo en
la variable de configuración `:post-date-format` en
`content/config.edn`.

Para ver cómo va quedando el contenido, puedes ejecutar el servidor
web de desarrollo de Cryogen con:

```
lein ring server # OR
lein ring server-headless
```

# Desplegar

Para publicar nuevo contenido en la página, crea la carpeta `public`.

Esta carpeta se crea cada vez que ejecutas el servidor de desarrollo,
o explícitamente con:

```shell
lein run
```

Luego, esa carpeta en su totalidad debe copiarse en la rama master, y
publicar el cambio en GitHub.

Una manera:

Tengo el repositorio `jgomo3.github.io` junto con un «worktree» con la
rama `master`.

Lo creé desde el repositorio con:

```shell
git worktree add ../jgomo3.github.io-master master
```

Luego de crear el contenido en la rama `dev`, reconstruyo la carpeta `public`:

```shell
lein run
```

Y copio su contenido completo en el «worktree» de `master`:

```shell
rsync -av public/ ../jgomo3.github.io-master/`
```

Finalmente publico el cambio en Github:

```shell
cd ../jgomo3.github.io-master/
git add .
git commit -m "Explicación del nuevo contenido"
git push
```

# Migración

Debido a que había contenido publicado y en borrador en el sitio, he
establecido un proceso sencillo de migración de dichos artículos al
nuevo sitio basado en Cryogen.

Los archivos originales están ahora en la carpeta «pending». Tiene la
misma estructura original: `año/mes/día` de publicación.

Habrá un ticket por cada artículo a migrar.

Lo más importante es que el contenido vuelva.

Luego, si se puede, rescatar el enlace original.
