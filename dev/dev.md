# Soporte de caracteres españoles en Harmony of Dissonance / DSVania Editor

Este directorio contiene los cambios necesarios para poder utilizar caracteres españoles en los textos de **Castlevania: Harmony of Dissonance (USA)** al trabajar con **DSVania Editor / DSVEdit**.

## Objetivo

La ROM original y la ruta de texto de HoD en DSVEdit no permiten introducir directamente varios caracteres necesarios para una traducción española. Este conjunto añade soporte para:

```text
á é í ó ú ü ñ ¿ ¡
Á É Í Ó Ú Ñ
```

La solución tiene **dos partes independientes y ambas son necesarias**:

1. `text.rb` modifica DSVEdit para que pueda codificar y decodificar estos caracteres.
2. El parche `.ips` modifica los glifos correspondientes en la fuente de la ROM para que el juego los dibuje correctamente.

El archivo `.txt` documenta la correspondencia entre cada carácter, su código interno y los offsets utilizados.

---

## Archivos del directorio

Este documento asume que los siguientes archivos se encuentran en la misma carpeta que `dev.md`:

```text
dev.md
text.rb
hod_spanish_chars_v3.ips
hod_spanish_chars_mapping_v3.txt
```

### `text.rb`

Versión modificada del archivo `dsvlib/text.rb` de DSVEdit.

Añade una tabla específica para Harmony of Dissonance que permite convertir los caracteres españoles a los códigos de 16 bits que utilizaremos en la ROM y realizar también la conversión inversa al leer los textos.

Esto permite escribir directamente en DSVania Editor, por ejemplo:

```text
¿Qué pasó aquí? ¡Ánimo!
El niño está allí.
```

sin tener que introducir manualmente códigos RAW.

### `hod_spanish_chars_v3.ips`

Parche para la ROM USA limpia de **Castlevania: Harmony of Dissonance**.

Modifica físicamente los glifos de la fuente del juego. Se reutilizan determinadas posiciones de caracteres japoneses y se sustituyen sus bitmaps por los caracteres españoles.

El parche no es suficiente por sí solo para que DSVEdit acepte `á`, `ñ`, etc. Del mismo modo, modificar únicamente `text.rb` tampoco es suficiente: el editor aceptaría los caracteres, pero el juego seguiría mostrando los glifos japoneses originales.

Por tanto:

```text
text.rb modificado
        +
parche IPS de fuente
        =
soporte de español
```

### `hod_spanish_chars_mapping_v3.txt`

Documento de referencia con el mapeo utilizado por el parche y por `text.rb`.

Debe conservarse junto a ambos para que las asignaciones puedan consultarse y mantenerse en el futuro.

---

## ROM compatible

El parche se desarrolló y verificó sobre la ROM USA limpia de Harmony of Dissonance utilizada durante el desarrollo:

```text
Game code: ACHE
Tamaño:    8 MiB
CRC32:     88C1B562
```

Se recomienda aplicar el parche únicamente sobre una copia limpia que coincida con esta versión.

**No aplicar primero las versiones v1 o v2 del parche.** `hod_spanish_chars_v3.ips` debe aplicarse directamente sobre la ROM limpia original.

Conservar siempre una copia sin modificar de la ROM.

---

## Instalación

### 1. Aplicar el parche de fuente

Partiendo de la ROM USA limpia:

```text
Harmony of Dissonance USA limpia
              |
              v
   hod_spanish_chars_v3.ips
              |
              v
       ROM con fuente ES
```

Aplicar `hod_spanish_chars_v3.ips` con cualquier herramienta compatible con el formato IPS.

Después se puede utilizar la ROM resultante normalmente con DSVania Editor.

### 2. Instalar el `text.rb` modificado

Localizar la instalación o copia de desarrollo de DSVEdit.

Dentro de ella debe existir:

```text
dsvlib/
  text.rb
```

Hacer primero una copia de seguridad del archivo original.

Después sustituir:

```text
DSVEdit/dsvlib/text.rb
```

por el `text.rb` incluido en este directorio.

Es importante que el archivo conserve exactamente el nombre:

```text
text.rb
```

Si DSVEdit se distribuye como un ejecutable empaquetado que no contiene `dsvlib/text.rb` accesible, será necesario incorporar el cambio al código fuente y generar de nuevo la aplicación.

### 3. Abrir la ROM parcheada

Iniciar DSVania Editor utilizando el `text.rb` modificado y abrir la ROM a la que se haya aplicado `hod_spanish_chars_v3.ips`.

A partir de ese momento los textos de HoD deberían aceptar directamente caracteres como:

```text
á é í ó ú ü ñ ¿ ¡
Á É Í Ó Ú Ñ
```

Ejemplo:

```text
¿Qué ocurrió aquí?
¡Ánimo!
El niño volvió allí.
```

---

## Mapeo de caracteres

Las posiciones utilizadas son:

| Carácter | Código |
|---|---|
| Á | `0x82A4` |
| É | `0x82A5` |
| Í | `0x82A6` |
| Ó | `0x82A7` |
| Ú | `0x82A8` |
| Ñ | `0x82A9` |
| á | `0x82AD` |
| ¡ | `0x82AE` |
| ñ | `0x82AF` |
| ¿ | `0x82B0` |
| í | `0x82B1` |
| é | `0x82B2` |
| ó | `0x82B4` |
| ú | `0x82B7` |
| ü | `0x82B8` |

`hod_spanish_chars_mapping_v3.txt` es la referencia completa del mapeo y de los offsets asociados al parche.

---

## Cómo funciona

### Codificación en DSVEdit

El problema original no era únicamente gráfico.

La ruta de Harmony of Dissonance en DSVEdit intenta codificar los caracteres del texto utilizando la codificación esperada por el juego. Caracteres españoles como `á` o `ñ` no podían introducirse directamente mediante esa ruta y el editor mostraba un error.

El `text.rb` modificado añade excepciones específicas para HoD.

Conceptualmente:

```text
"á"
 |
 v
DSVEdit
 |
 v
0x82AD
```

La modificación se aplica también en sentido inverso. De este modo, cuando DSVEdit encuentra `0x82AD` al leer un texto, presenta:

```text
á
```

en vez del carácter japonés que originalmente correspondía a esa posición.

### Glifos de la ROM

Aceptar el carácter en DSVEdit no cambia automáticamente la fuente del juego.

HoD sigue buscando el glifo correspondiente al código almacenado. Por eso el IPS sustituye los dibujos de determinadas posiciones japonesas por nuevos glifos españoles.

La fuente utilizada por estos caracteres contiene entradas formadas por:

```text
2 bytes  código del carácter
12 bytes bitmap del glifo
```

Es decir, cada entrada relevante ocupa 14 bytes.

Durante el análisis se comprobó, por ejemplo, que la entrada de `0x82AD`, reutilizada para `á`, se encuentra en:

```text
entrada: 0x497344
bitmap:  0x497346
```

Las demás posiciones utilizadas están documentadas en `hod_spanish_chars_mapping_v3.txt`.

El flujo completo queda así:

```text
Usuario escribe "á"
        |
        v
text.rb reconoce "á"
        |
        v
DSVEdit guarda 0x82AD
        |
        v
HoD busca el glifo 0x82AD
        |
        v
IPS ha sustituido ese bitmap
        |
        v
el juego muestra "á"
```

---

## Por qué no basta con modificar la tabla de DSVEdit

Si solo se instala `text.rb`:

```text
á -> 0x82AD -> glifo japonés
```

DSVEdit acepta el texto, pero dentro del juego aparece un carácter extraño/japonés.

Si solo se aplica el IPS:

```text
DSVEdit -> intenta introducir á -> error
```

La ROM contiene el nuevo dibujo, pero DSVEdit no sabe convertir `á` al código reservado.

Por eso deben instalarse **ambos cambios**.

---

## Prueba recomendada

Después de instalar ambos componentes, crear o modificar temporalmente un texto y utilizar una cadena que pruebe todos los caracteres:

```text
áéíóú ü ñ ¿¡
ÁÉÍÓÚ Ñ
```

También conviene probar una frase real:

```text
¿Qué pasó aquí? ¡Ánimo!
El niño está allí.
```

Comprobar dos cosas:

1. DSVania Editor permite guardar el texto sin mostrar errores de codificación.
2. En el juego/emulador aparecen los caracteres españoles correctos y no los caracteres japoneses originales.

Después, cerrar y volver a abrir el proyecto/texto en DSVEdit y comprobar que los caracteres siguen apareciendo como `á`, `ñ`, `¿`, etc. Esto verifica también la decodificación.

---

## Desarrollo y mantenimiento

El mapeo de `text.rb` y el mapeo gráfico del IPS deben mantenerse sincronizados.

Por ejemplo:

```text
text.rb:
"á" <-> 0x82AD

ROM:
0x82AD -> bitmap de "á"
```

Cambiar solamente uno de los dos provocará que DSVEdit muestre una cosa y el juego dibuje otra.

Si se añaden nuevos caracteres en el futuro, el procedimiento general es:

1. Elegir una posición/código de la fuente que pueda reutilizarse con seguridad.
2. Crear el nuevo glifo en la fuente de la ROM.
3. Actualizar el parche IPS.
4. Añadir el mismo código y carácter a la tabla HoD de `text.rb`.
5. Actualizar `hod_spanish_chars_mapping_v3.txt`.
6. Verificar escritura, visualización en juego y lectura posterior en DSVEdit.

No se recomienda elegir códigos arbitrariamente sin comprobar primero su entrada real en la fuente.

---

---

## Cómo se desarrolló esta modificación

Esta solución no se obtuvo simplemente eligiendo bytes libres al azar. El desarrollo se hizo en varias etapas, comprobando por separado cómo trabaja DSVEdit y cómo almacena HoD su fuente.

### 1. Se identificó el primer problema: DSVEdit rechazaba los caracteres españoles

Al intentar escribir directamente caracteres como:

```text
á é í ó ú ñ ¿ ¡
```

DSVEdit mostraba un error antes de guardar el texto.

Esto indicaba que el problema inicial no estaba todavía en la ROM, sino en la propia lógica de codificación del editor.

Al revisar `dsvlib/text.rb` se comprobó que Harmony of Dissonance sigue una ruta de codificación distinta a la tabla especial utilizada por otros juegos.

Por ejemplo, en el archivo original pueden existir tablas con entradas del tipo:

```ruby
0xC1 => "Á"
```

pero esas entradas pertenecen a otros juegos, como Aria of Sorrow, y no son utilizadas por HoD.

Para HoD fue necesario añadir un mapeo específico que interceptase los caracteres españoles antes de la conversión normal.

Así se consiguió que, por ejemplo:

```text
á
```

se guardase como:

```text
0x82AD
```

y que al volver a leer ese valor DSVEdit mostrase otra vez:

```text
á
```

en lugar del carácter japonés asociado originalmente al código.

### 2. Se comprobó que modificar DSVEdit no era suficiente

Después de permitir que DSVEdit escribiese esos códigos, el juego seguía mostrando caracteres extraños.

Esto confirmó que había dos capas independientes:

```text
codificación del texto
+
representación gráfica del carácter
```

DSVEdit ya estaba escribiendo el valor correcto, pero la ROM seguía conservando el bitmap japonés original correspondiente a ese código.

Por tanto, también era necesario modificar físicamente la fuente.

### 3. Se localizó la fuente de HoD dentro de la ROM

El análisis de la ROM USA limpia permitió localizar la fuente usada por estos caracteres.

La fuente grande comienza en:

```text
0x496314
```

y sus entradas contienen:

```text
2 bytes  identificador/código del carácter
12 bytes bitmap del glifo
```

Por tanto, cada entrada relevante ocupa:

```text
14 bytes
```

Esta estructura es importante porque las primeras pruebas trataron incorrectamente el bloque como una simple secuencia lineal de bitmaps. Eso producía un parche válido desde el punto de vista IPS, pero escribía los nuevos dibujos en posiciones que no correspondían a los caracteres deseados.

Ese fue el motivo por el que las versiones iniciales podían seguir mostrando kana aunque DSVEdit hubiese guardado correctamente el código.

### 4. Se verificó la correspondencia real código -> entrada de fuente

La v3 no calcula la posición de un glifo suponiendo un índice arbitrario.

Se recorrió la tabla real buscando los dos bytes que identifican cada código utilizado.

Por ejemplo, para:

```text
0x82AD
```

la entrada real encontrada en la ROM comienza en:

```text
0x497344
```

y el bitmap comienza dos bytes después:

```text
0x497346
```

Es decir:

```text
0x497344  AD 82     código 0x82AD
0x497346  ........  primeras filas del bitmap
...
```

El parche v3 escribe únicamente sobre la zona del bitmap y mantiene el identificador original.

El mismo procedimiento se utiliza para el resto de códigos documentados en `hod_spanish_chars_mapping_v3.txt`.

### 5. Se crearon los nuevos glifos

Una vez localizadas las entradas correctas, los caracteres japoneses originales de esas posiciones se sustituyeron por dibujos correspondientes a:

```text
á é í ó ú ü ñ ¿ ¡
Á É Í Ó Ú Ñ
```

La intención es conservar el estilo visual de la fuente original de HoD, reutilizando como referencia las formas de las letras latinas ya existentes y añadiendo los signos diacríticos necesarios.

No se añade una nueva fuente ni se amplía el bloque de datos.

Se reutilizan entradas ya existentes.

Eso tiene varias ventajas:

- no hay que mover la fuente;
- no hay que modificar punteros;
- no se altera el tamaño de la ROM;
- no hay que cambiar el código del motor gráfico;
- el parche se mantiene pequeño;
- DSVEdit puede seguir trabajando con códigos de 16 bits que el motor ya conoce.

---

## Por qué se utilizan esos códigos y no otros

Los códigos elegidos no son direcciones de memoria libres ni nuevos identificadores inventados.

Son códigos de caracteres **ya válidos para el motor de texto de Harmony of Dissonance** que originalmente apuntan a glifos japoneses.

La estrategia consiste en reutilizarlos para español.

Por ejemplo:

```text
0x82AD -> á
0x82B2 -> é
0x82B4 -> ó
0x82B7 -> ú
0x82B8 -> ü
```

Varias de estas posiciones también aparecen utilizadas para caracteres acentuados en trabajos previos de traducción de HoD, lo que sirvió como referencia inicial para comprobar que el motor acepta esos códigos correctamente.

Sin embargo, para esta modificación no basta con asumir que un código funcionará por aparecer en otra tabla: se verificó que cada código seleccionado existe realmente dentro de la fuente de la ROM USA utilizada.

### Criterios utilizados para escoger las posiciones

Se buscaban posiciones que cumpliesen estas condiciones:

1. **El código ya debe ser aceptado por el motor de HoD.**

   Esto evita modificar el motor de renderizado o añadir soporte para una codificación completamente nueva.

2. **Debe existir una entrada correspondiente en la fuente.**

   De esta manera basta con sustituir el bitmap.

3. **La entrada original debe ser prescindible para una traducción española.**

   Los códigos seleccionados pertenecen a caracteres japoneses que no son necesarios en los textos españoles previstos.

4. **Se prefieren códigos próximos entre sí.**

   Esto facilita mantener y documentar el mapeo.

5. **Se evita reutilizar puntuación o caracteres ASCII que sí puedan aparecer normalmente.**

   No tiene sentido reemplazar una letra latina, un número o un signo común si existen posiciones japonesas disponibles.

6. **El mapeo de DSVEdit y el del parche deben ser exactamente iguales.**

   Si `text.rb` escribe `0x82AD` para `á`, la entrada `0x82AD` de la fuente debe dibujar `á`.

### Por qué no se utilizaron simplemente 0xC1, 0xE1, etc.

Al revisar `text.rb` se observaron valores que parecen coincidir con códigos habituales de caracteres latinos, por ejemplo:

```ruby
0xC1 => "Á"
```

Pero esas tablas pertenecen a rutas específicas de otros juegos.

Harmony of Dissonance no utiliza automáticamente ese mapeo.

Usar esos valores únicamente porque parecen representar caracteres latinos habría sido incorrecto: el motor de HoD necesita códigos que correspondan a entradas válidas de su propia tabla/fuente.

Por eso se mantuvo la estrategia basada en códigos `0x82xx` ya presentes en HoD.

---

## Por qué se reutilizan glifos japoneses en vez de ampliar la fuente

Añadir nuevas entradas al final de la fuente sería técnicamente posible, pero implicaría un trabajo mucho mayor.

Habría que estudiar y posiblemente modificar:

- tamaño del bloque;
- límites de la tabla;
- punteros;
- rutinas que recorren la fuente;
- tablas VWF;
- posibles referencias absolutas;
- espacio libre disponible en ROM.

La solución utilizada evita todo eso.

El juego ya sabe:

```text
"si recibo 0x82AD, busca esta entrada y dibuja su bitmap"
```

No necesitamos cambiar esa lógica.

Únicamente hacemos:

```text
bitmap japonés de 0x82AD
            |
            v
        bitmap "á"
```

y enseñamos a DSVEdit que:

```text
"á" <-> 0x82AD
```

Es una modificación mucho más localizada y de menor riesgo.

---

## Historia de las versiones del parche

### v1 / v2

Las primeras versiones establecieron correctamente la idea general de reutilizar códigos japoneses para español, pero el cálculo de los offsets gráficos no representaba correctamente la estructura real de las entradas de fuente.

El resultado era:

```text
DSVEdit guardaba el código deseado
pero
la ROM seguía mostrando el glifo japonés
```

Esto fue útil para aislar el problema: confirmó que la modificación de `text.rb` funcionaba y que el error restante estaba únicamente en la correspondencia código -> bitmap.

### v3

La v3 se rehizo buscando directamente cada código en la tabla real de la fuente y modificando exactamente los 12 bytes del bitmap correspondiente.

Por ello:

```text
hod_spanish_chars_v3.ips
```

es la versión que debe utilizarse.

Las versiones anteriores se consideran obsoletas.

---

## Cómo verificar un nuevo carácter en el futuro

Para añadir otro carácter no se debe escoger un offset manualmente.

El procedimiento correcto es:

```text
1. elegir un código candidato válido de HoD
2. localizar sus dos bytes dentro de la tabla de fuente
3. confirmar que corresponde a una entrada de 14 bytes
4. conservar los 2 bytes del código
5. reemplazar únicamente los 12 bytes del bitmap
6. añadir carácter <-> código a text.rb
7. actualizar el archivo de mapeo
8. probar escritura, juego y lectura posterior
```

Conceptualmente:

```text
entrada:

+0x00  código byte 1
+0x01  código byte 2
+0x02  bitmap fila 0
+0x03  bitmap fila 1
...
+0x0D  bitmap fila 11
```

No se debe asumir que:

```text
índice del carácter * tamaño
```

proporcionará necesariamente el offset correcto sin haber confirmado primero la estructura y el orden real de la tabla.


## Caracteres actualmente soportados

```text
Minúsculas:
á é í ó ú ü ñ

Puntuación:
¿ ¡

Mayúsculas:
Á É Í Ó Ú Ñ
```

Las letras ASCII normales (`a-z`, `A-Z`) y la puntuación estándar continúan utilizando el comportamiento normal de HoD/DSVEdit.

---

---

## Créditos y trabajo previo

Esta modificación española no se desarrolló completamente desde cero. Durante la investigación se utilizó como referencia importante el proyecto de traducción brasileña de **Castlevania: Harmony of Dissonance** mantenido/publicado por **leomontenegro6**:

```text
chod-traducao-ptbr
https://github.com/leomontenegro6/chod-traducao-ptbr
```

### Qué aportó el proyecto brasileño

El proyecto brasileño fue especialmente útil para comprender la estrategia general necesaria para añadir caracteres que no están disponibles de forma directa en la codificación original utilizada por HoD.

En particular, sirvió como referencia para:

- confirmar que era viable reutilizar posiciones de caracteres japoneses para representar caracteres latinos acentuados;
- identificar la zona de la ROM donde se encuentran las fuentes utilizadas por el juego;
- conocer la existencia y tratamiento de la fuente VWF;
- disponer de ejemplos de códigos ya reutilizados satisfactoriamente para caracteres portugueses;
- orientar el análisis posterior de la ROM USA.

Su tabla `chod.tbl` proporcionó, entre otras, referencias como:

```text
0x82AD -> á
0x82B2 -> é
0x82B4 -> ó
0x82B7 -> ú
0x82B8 -> ü
0x82A5 -> É
```

Estas asignaciones sirvieron como punto de partida para parte del mapeo utilizado por esta modificación.

### Qué se desarrolló específicamente para esta modificación española

El parche incluido en este directorio **no es una copia del parche gráfico brasileño**.

A partir de las pistas anteriores se analizó directamente la ROM USA de Harmony of Dissonance utilizada por este proyecto y se verificó la estructura real de las entradas de fuente.

Ese análisis permitió determinar que las entradas relevantes contienen:

```text
2 bytes  código del carácter
12 bytes bitmap
```

y localizar directamente las entradas correspondientes a los códigos seleccionados.

También se añadieron las necesidades específicas del español, entre ellas:

```text
ñ Ñ
¿ ¡
í Í
Á Ó Ú
```

además de integrar el mapeo con la ruta de codificación y decodificación de Harmony of Dissonance en `dsvlib/text.rb`.

Los offsets efectivos utilizados por `hod_spanish_chars_v3.ips` fueron comprobados sobre la ROM USA indicada en este documento.

Por tanto, la relación entre ambos trabajos puede resumirse así:

```text
Proyecto brasileño
        |
        |  estrategia, investigación previa,
        |  localización de fuentes y códigos de referencia
        v
Análisis directo de la ROM USA
        |
        |  estructura código/bitmap,
        |  offsets reales y caracteres españoles
        v
hod_spanish_chars_v3.ips + text.rb
```

### DSVania Editor / DSVEdit

Esta modificación depende de **DSVania Editor (DSVEdit)** y modifica su archivo `dsvlib/text.rb` para añadir el mapeo específico de Harmony of Dissonance.

DSVEdit es obra de **LagoLunatic** y colaboradores:

```text
DSVEdit
https://github.com/LagoLunatic/DSVEdit
```

El `text.rb` incluido aquí debe entenderse como una modificación específica para este proyecto sobre el código de DSVEdit, no como un componente original independiente.

### Agradecimientos

Agradecimientos a:

- **LagoLunatic y los colaboradores de DSVEdit**, por desarrollar y mantener DSVania Editor y hacer posible la edición de Harmony of Dissonance.
- **leomontenegro6 y las personas que participaron en `chod-traducao-ptbr`**, cuyo trabajo previo sobre la traducción brasileña, las fuentes y la codificación de HoD fue una referencia fundamental para orientar esta implementación española.

Se recomienda conservar estos créditos y las referencias a los proyectos originales en cualquier redistribución o derivado de estos archivos.


## Resumen rápido

Para utilizar el soporte español:

1. Partir de Harmony of Dissonance USA limpia (`ACHE`, CRC32 `88C1B562`).
2. Aplicar `hod_spanish_chars_v3.ips` directamente sobre esa ROM.
3. Hacer copia de seguridad de `DSVEdit/dsvlib/text.rb`.
4. Sustituirlo por el `text.rb` de este directorio.
5. Abrir la ROM parcheada con DSVania Editor.
6. Escribir normalmente `áéíóúüñ¿¡ÁÉÍÓÚÑ`.
7. Probar los textos dentro del juego.

Los tres archivos (`text.rb`, `.ips` y `.txt`) forman una única modificación y deben mantenerse sincronizados.
