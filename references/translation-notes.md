# Notas de traducción — Castlevania: Harmony of Dissonance

## Propósito

Usar este documento como referencia específica para traducir *Castlevania: Harmony of Dissonance* al español. Aplicar estas notas para evitar reproducir errores o cambios discutibles de la localización inglesa de Game Boy Advance.

No tratar este archivo como un glosario completo. Cuando una entrada no esté cubierta aquí, traducir a partir del texto fuente y del contexto disponible.

## Jerarquía de autoridad

Cuando dos fuentes entren en conflicto, aplicar este orden:

1. Texto japonés original presente en el proyecto.
2. Contexto interno del propio juego: escena, objeto, efecto, personaje y continuidad narrativa.
3. Terminología de Castlevania establecida de forma consistente en materiales de apoyo del proyecto.
4. Estas notas de traducción.
5. Localización inglesa oficial de *Harmony of Dissonance*, únicamente como referencia secundaria.

No asumir que la localización inglesa conserva siempre el significado o las referencias del original japonés.

## Niveles de confianza

- **Confirmado**: el japonés y varias fuentes de comparación coinciden en que la localización inglesa cambió o interpretó erróneamente el nombre.
- **Cambio de localización**: el nombre inglés occidental difiere deliberadamente del usado en la versión japonesa, pero no hay base suficiente para llamarlo error.
- **No aplicar automáticamente**: existe información comunitaria o una posible diferencia, pero requiere comprobar el texto japonés concreto antes de cambiar nada.

## Errores o pérdidas de referencia confirmados

### Sypha's Crystal / Cipher's Charm

**Estado:** Confirmado.

- Japonés: `サイファのすいしょう`
- Romanización orientativa: `Saifa no suishou`
- Sentido: `Sypha's Crystal`
- Localización inglesa de GBA: `Cipher's Charm`
- Español recomendado: **Cristal de Sypha**

Regla: si el texto fuente inglés contiene `Cipher's Charm` y el contexto corresponde a este objeto, traducirlo como **Cristal de Sypha**, no como «Amuleto de Cipher» ni equivalentes.

Motivo: `サイファ` representa el nombre Sypha. La localización inglesa perdió la referencia a Sypha, personaje de *Castlevania III*. Esta identificación está respaldada por comparaciones de inventario japonés-inglés y por estudios posteriores de la localización de nombres de la saga.

### Christopher's Soul / Bullet Tip

**Estado:** Confirmado.

- Japonés: `クリストファーソウル`
- Romanización orientativa: `Kurisutofaa Souru` / `Christopher Soul`
- Sentido: `Christopher's Soul`
- Localización inglesa de GBA: `Bullet Tip`
- Español recomendado: **Alma de Christopher**

Regla: si el texto fuente inglés contiene `Bullet Tip` y el contexto corresponde al accesorio del látigo que permite lanzar proyectiles, traducirlo como **Alma de Christopher**.

Motivo: el nombre japonés referencia directamente a Christopher Belmont y a su ataque de proyectiles en los Castlevania de Game Boy. La versión inglesa sustituyó esa referencia por un nombre descriptivo.

> Nota técnica: conservar **Christopher** como nombre propio; no traducirlo a «Cristóbal».

## Nombres de zonas cambiados en la localización occidental

**Estado general:** Cambio de localización, no error demostrado.

La versión japonesa mostraba varios nombres de zonas en inglés. Para el lanzamiento occidental se sustituyeron varios de esos nombres, y fuentes contemporáneas señalan que algunos coinciden con títulos de pistas musicales.

Si el objetivo del proyecto es representar con fidelidad la versión japonesa, tomar como referencia la columna «Versión japonesa» y no reconstruir el significado a partir del nombre occidental.

| Versión japonesa | Localización inglesa occidental | Criterio para español |
|---|---|---|
| `The Approach of Deplore` | `The Wailing Way` | Traducir desde el nombre japonés mostrado; no asumir que «Wailing» forma parte del original. |
| `Castle Tower` | `Castle Top Floor` | Preferir el sentido de **torre del castillo**. |
| `Heretic's Grave` | `Shrine of Apostates` | Preferir el sentido de **tumba del hereje**. |
| `Chapel of a Heretic` | `Chapel of Dissonance` | Preferir el sentido de **capilla de un/del hereje** según el estilo global. |
| `Corridor in the Air` / `Corridor in the Sky` | `Sky Walkway` | Verificar la grafía exacta en el recurso japonés disponible; traducir el sentido de corredor aéreo/celeste, no el nombre occidental por defecto. |
| `Moss-Grown Cave` | `Luminous Cavern` | Preferir el sentido de **cueva cubierta de musgo** o equivalente natural. |
| `Waterway of Aquatic` | `Aqueduct of Dragons` | Traducir desde el nombre japonés mostrado; no introducir «dragones» si no aparece en el original. |

### Regla importante para las zonas

No sustituir automáticamente todos los nombres occidentales por traducciones literales de la tabla. Primero determinar qué versión actúa como fuente del archivo que se está traduciendo.

- Si el archivo procede del japonés, mantener el significado de los nombres japoneses.
- Si el archivo reproduce deliberadamente la nomenclatura oficial occidental, conservar esa intención salvo que el proyecto indique una retraducción fiel al japonés.
- Si hay mezcla de fuentes, marcar la discrepancia y escoger una convención única para todo el proyecto.

## Otros cambios de nombres documentados

Los siguientes cambios están documentados entre versiones, pero no deben tratarse automáticamente como errores:

- `Midday Constellation` → `Noon Star`
- nombres del tipo `Dracula's <parte>` → `<parte> of Vlad`
- varios nombres de enemigos y equipamiento fueron adaptados o acortados en inglés occidental.

Regla: no restaurar estos nombres sin comprobar la entrada japonesa concreta y el criterio terminológico general del proyecto.

## Diálogos

Existe una comparación comunitaria del guion japonés con la localización inglesa que cubre escenas y finales. Usarla, si está disponible dentro de `references/`, como material auxiliar para detectar matices perdidos.

No asumir que cada diferencia entre japonés e inglés es un error. Distinguir entre:

- error semántico;
- omisión de información;
- cambio de tono;
- adaptación natural;
- limitación de espacio;
- reescritura estilística.

Para cada línea, conservar primero el significado, la relación entre personajes y la intención dramática. Evitar calcar construcciones rígidas del inglés si el japonés permite una formulación española más natural.

## Nombres propios y continuidad

Aplicar estas formas por defecto:

- `Juste Belmont` → **Juste Belmont**
- `Maxim Kischine` → **Maxim Kischine**
- `Lydie Erlanger` → **Lydie Erlanger**
- `Simon Belmont` → **Simon Belmont**
- `Christopher Belmont` → **Christopher Belmont**
- `Sypha` → **Sypha**
- `Dracula` → **Drácula** en prosa española; conservar `Dracula` cuando forme parte de una cadena técnica, identificador o nombre que el proyecto haya decidido mantener sin adaptar.

No convertir nombres propios ingleses a equivalentes españoles de pila: por ejemplo, no usar «Cristóbal Belmont» para Christopher Belmont.

## Belmont / Belmondo

Usar **Belmont** en la traducción española salvo que el proyecto indique explícitamente una restauración filológica de los nombres japoneses. Aunque ciertas romanizaciones japonesas históricas se aproximan a «Belmondo», **Belmont** es la forma establecida internacionalmente para la familia en la saga y evita introducir una inconsistencia innecesaria.

## Título del juego

Usar **Castlevania: Harmony of Dissonance** como título oficial del juego cuando se mencione la obra.

No sustituir automáticamente el título por traducciones de `白夜の協奏曲` o `Byakuya no Concerto`. Esas formas pueden mencionarse al hablar específicamente del título japonés, pero no deben reemplazar el título oficial occidental por defecto.

## Restricciones de formato

Al aplicar estas notas:

- No alterar IDs, offsets, punteros, etiquetas, claves, variables, placeholders ni códigos de control.
- No traducir texto que funcione únicamente como identificador interno.
- Mantener saltos de línea y límites de longitud cuando el formato de origen los haga significativos.
- No expandir una cadena de interfaz sin comprobar que el formato admite la longitud resultante.
- Conservar mayúsculas especiales cuando sean parte funcional de la interfaz; normalizarlas solo si son puramente estilísticas.

## Qué hacer ante una duda

Si aparece una discrepancia no documentada aquí:

1. Buscar la misma entrada en los demás archivos de `references/`.
2. Comprobar si existe texto japonés equivalente.
3. Comparar el efecto del objeto, la escena o el contexto de juego.
4. Evitar «corregir» por intuición una referencia que no pueda verificarse.
5. Mantener una decisión coherente en todas las apariciones de la misma cadena.
6. Si sigue habiendo ambigüedad, conservar la interpretación más respaldada por el original y dejar constancia de la duda en el informe final.

## Fuentes de contraste utilizadas para estas notas

Estas notas se han construido contrastando, entre otras, las siguientes fuentes públicas:

- Guía de *Harmony of Dissonance* de Zach Keene en GameFAQs, sección de cambios de nombres entre las versiones japonesa e inglesa.
- *Inventory Translation Guide* de AstroBlue en GameFAQs, que transcribe nombres japoneses de objetos como `クリストファーソウル` y `サイファのすいしょう`.
- Página de información de versiones extranjeras de *Harmony of Dissonance* en Castlevania Dungeon.
- Estudio de Lost in Localization sobre el nombre Belnades/Sypha, que identifica `Cipher's Charm` como una mala interpretación de `Sypha's Crystal`.
- Proyecto comunitario de comparación del guion japonés y la localización inglesa compartido en Castlevania Dungeon en 2019.

Estas fuentes son material de contraste, no autoridad absoluta. Cuando el proyecto contenga el texto japonés original, este debe prevalecer para determinar el significado.
