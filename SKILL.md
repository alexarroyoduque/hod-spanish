---
name: hod-spanish
description: Traducir al español los textos originales ubicados en references/hod-texts-original utilizando el resto de archivos de references (incluyendo translation-notes.md como fuente de máxima autoridad) como material de apoyo para contexto, terminología, estilo y referencias. Usar cuando un espacio de trabajo contenga una carpeta references con la subcarpeta hod-texts-original y se quiera generar una versión en español en la carpeta hermana ./hod-texts-spanish, preservando la estructura y el formato originales.
---

# Traductor HOD al español

## Objetivo

Traducir al español todo el contenido traducible de `references/hod-texts-original/` y guardar los archivos traducidos en `./hod-texts-spanish/`.

Excepción: `Music Names.csv` NO se traduce. Contiene los títulos de las pistas del sound test ("Theme of MAXIM KISCHINE", "Vampire Killer", nombres de zona + "(Area BGM)"), que funcionan como títulos propios/artísticos. Copiarlo sin cambios a `./hod-texts-spanish/Music Names.csv`.

Usar el resto de `references/` como material de apoyo para mantener la terminología, el tono, los nombres, los conceptos y la coherencia. No modificar los archivos de apoyo.

### Materiales de apoyo conocidos y su uso específico

- `translation-notes.md`: **fuente de máxima autoridad** entre los materiales de apoyo. Define la jerarquía de autoridad a aplicar ante conflictos (japonés original > contexto interno del juego > terminología de Castlevania establecida > estas notas > localización inglesa como referencia secundaria), niveles de confianza (Confirmado / Cambio de localización / No aplicar automáticamente), correcciones confirmadas de nombres (p.ej. `Cipher's Charm` → **Cristal de Sypha**, `Bullet Tip` → **Alma de Christopher**), nombres de zonas cambiados en la localización occidental, convenciones de nombres propios y el procedimiento a seguir ante cualquier duda no documentada. Consultarlo siempre antes de decidir un nombre propio o terminología dudosa. La fuente del juego ya soporta tildes y grafías españolas establecidas (p.ej. «Drácula»): escribirlas con su ortografía correcta.
- `HOD Localization Fix Readme.txt` (readme en UTF-16LE): nombres de enemigos/objetos/reliquias más fieles al japonés original que el texto USA; confirma que el límite de nombres en HUD es de 16 caracteres, con ejemplos reales de abreviación.
- `translation guide.txt`: mismos diálogos de la historia que `Events.csv` pero en formato limpio "Personaje: línea", sin marcadores de control; útil para no perder el contexto narrativo de una escena.
- `inventory translation guide.txt`: kana japonés + traducción inglesa + estadísticas (DEF/STR/INT/LCK/resistencias) de armas, armaduras, accesorios, libros de hechizos y reliquias; útil para `Item Names.csv`/`Item Descriptions.csv`.
- `item list.txt`: lista completa de objetos por categoría, en el orden real del menú del juego, con dónde se encuentra/consigue cada uno; útil para desambiguar objetos con nombres parecidos.
- `monster list.txt`: "Monster Encyclopedia" completa (100 enemigos) con nivel, HP, resistencias/debilidades, objetos que suelta y zonas; útil para `Enemy Names.csv`.
- `translation spanish.txt`: guía walkthrough YA TRADUCIDA AL ESPAÑOL (registro rioplatense/informal, con tildes/ñ y nombres de enemigos/ítems dejados en inglés a propósito). Es la fuente más directamente aprovechable para `Events.csv`: usarla como base y adaptarla (neutralizar registro, quitar tildes/ñ, reinsertar marcadores de control, alinear con los IDs `0xNNN`) en vez de traducir el inglés desde cero. No sirve para nombres de enemigos/ítems.

### Convención de nombres de zona ya resuelta

`references/hod-texts-original/Music Names.csv` confirma que el texto fuente usa la nomenclatura OCCIDENTAL/oficial en inglés para las zonas (`Shrine of the Apostates`, `Luminous Cavern`, `Aqueduct of Dragons`, `Chapel of Dissonance`, etc.), no los nombres japoneses de la tabla de `translation-notes.md`. Por tanto, traducir los nombres de zona a partir de su significado en inglés occidental (p.ej. `Aqueduct of Dragons` → «Acueducto de los Dragones»), sin reconstruir el nombre japonés original (`Waterway of Aquatic`, etc.).

## Flujo de trabajo

1. Localizar la carpeta `references/` en el espacio de trabajo actual.
2. Comprobar que existe `references/hod-texts-original/`.
3. Revisar el resto de `references/` para obtener contexto útil para la traducción (empezando por `translation-notes.md`), excluyendo `hod-texts-spanish/` si ya existe.
4. Enumerar de forma recursiva los archivos contenidos en `references/hod-texts-original/`.
5. Crear `./hod-texts-spanish/` si no existe, que al inicio es una copia de `references/hod-texts-original/`.
6. Para cada archivo de texto traducible:
   - Leer el contenido original.
   - Traducir al español natural todo el texto destinado a personas.
   - Usar los archivos de apoyo de `references/` para mantener una terminología y un estilo coherentes.
   - Conservar la ruta relativa, el nombre del archivo y su extensión.
   - Guardar el resultado en la ruta equivalente dentro de `./hod-texts-spanish/`.
7. Recrear las subcarpetas necesarias para que la estructura de salida refleje la estructura de la carpeta de origen.
8. Verificar que cada archivo traducible de origen tenga su correspondiente archivo traducido.

## Reglas de traducción

- Traducir fielmente el significado, evitando una traducción palabra por palabra cuando el español natural requiera adaptación.
- Nada de localismos ni jerga coloquial, buscar un español neutro.
- Conservar encabezados, estructura de párrafos, listas, tablas, Markdown, estructura HTML, frontmatter YAML y cualquier otro formato del documento.
- Conservar placeholders, variables de plantilla, IDs, claves, URLs, rutas de archivos, código, comandos y tokens legibles por máquinas, salvo que sean claramente texto visible para el usuario que deba traducirse.
- Conservar nombres propios y nombres de productos o proyectos, salvo que los materiales de apoyo indiquen una forma establecida en español.
- Mantener una terminología coherente entre todos los archivos traducidos.
- No inventar terminología cuando los materiales de apoyo proporcionen un término aprobado o preferente.
- Ante cualquier nombre o término dudoso, aplicar primero la jerarquía de autoridad y las correcciones/niveles de confianza de `translation-notes.md` antes que la localización inglesa original; no "corregir" nombres por intuición sin respaldo documentado.
- No resumir, acortar, ampliar ni reescribir el contenido más allá de lo necesario para obtener una traducción precisa y natural.
- A excepción de "Item Names" y "Enemy Names", la fuente del juego ya soporta á,é,í,ó,ú,ñ,ü y sus versiones en mayúscula (Á,É,Í,Ó,Ú,Ñ), así como los signos ¿ y ¡: usar la ortografía española correcta y natural, con tildes y eñes.
- Revisar la correcta incorporación de ¿ y del ¡ en los diálogos de eventos.
- "Items Descriptions" no puede tener más de dos líneas de texto.
- En el caso de "Item Names" y "Enemy Names" está permitido el uso de á,é,í,ó,ú,Ó,ñ. Estos textos aparecen en el menú con otra fuente.
- Los archivos de `hod-texts-spanish/` traducidos antes de esta confirmación pueden contener palabras escritas sin tildes/eñe o sin signos de apertura por la restricción previa; revisarlos y corregirlos para aplicar la ortografía correcta.
- Respetar los límites de longitud por línea/campo observados en el material original (aprox. 37-40 caracteres por línea en Events.csv/Menus.csv/Item Descriptions.csv, 23 en Music Names.csv, 14 en Enemy Names.csv, 14 en Item Names.csv/Character Names.csv). Si una línea traducida los supera, reformular de forma más breve en vez de truncar.
- JB's Bracelet: traducir como Brazalete JB
- MK's Bracelet: traducir como Brazalete MK
- Las descripciones de objeto de "Item Descriptions" al traducirse deben respetar las mismas líneas que su homólogo original. Es decir, si una descripción tiene 2 líneas no debe pasar a 1, el resultado traducido debe ser de dos líneas. Por otro lado si una descripción tiene 1 línea no debe dividirse en 2, el resultado traducido debe mantenerse en una sola línea.
- Los archivos finales traducidos deben tener las mismas líneas que los originales.
- Cuando una línea de diálogo inserte una variable `{NAMEINSERT 0xNNNN}`/`{NAME 0xNNNN}` en medio del texto, tener en cuenta que esa variable ocupará espacio adicional en tiempo de ejecución (según su longitud en `Character Names.csv`) dentro del límite de caracteres de esa misma línea.
- No modificar los archivos originales de `references/hod-texts-original/`.
- No modificar ningún otro archivo dentro de `references/`.

## Archivos no textuales

Si `references/hod-texts-original/` contiene archivos binarios o de otro tipo que no puedan traducirse, conservar la estructura de directorios pero no intentar traducir su contenido. Copiar esos archivos únicamente cuando sean necesarios para que el conjunto traducido siga siendo utilizable; en caso contrario, dejarlos sin cambios en su ubicación original e informar de que se han omitido.

`Music Names.csv` entra en esta misma categoría por decisión explícita (títulos de pista, no se traducen): copiar sin cambios a `./hod-texts-spanish/`.

## Salida existente

Si `./hod-texts-spanish/` ya existe, actualizar o sobrescribir los archivos traducidos correspondientes con la traducción actual, dejando intactos los archivos no relacionados.

## Comprobación final

Antes de finalizar:

- Confirmar que existe `./hod-texts-spanish/`.
- Confirmar que la estructura de archivos traducidos refleja la de `references/hod-texts-original/` para todos los archivos traducibles.
- Comprobar que no falten archivos de salida.
- Comprobar que no queden fragmentos claramente sin traducir del idioma de origen, excluyendo nombres, código, placeholders, identificadores y otros contenidos que deban conservarse intencionadamente.
- Informar de forma breve sobre lo traducido y sobre cualquier archivo omitido.
