# Soporte de caracteres españoles en Harmony of Dissonance / DSVania Editor

Este directorio documenta la solución utilizada para introducir caracteres españoles en **Castlevania: Harmony of Dissonance (USA)** mediante **DSVania Editor / DSVEdit**.

La implementación actual funciona correctamente en las pruebas realizadas. Este documento está pensado como referencia futura: explica el mecanismo y las decisiones importantes sin conservar el historial de versiones experimentales.

## Archivos

```text
dev.md
text.rb
hod_spanish_chars.ips
hod_spanish_chars_mapping.txt
```

- `text.rb`: modifica `DSVEdit/dsvlib/text.rb` para codificar y decodificar los caracteres españoles.
- `hod_spanish_chars.ips`: modifica las fuentes de HoD y el mínimo necesario de la ruta de renderizado de menús.
- `hod_spanish_chars_mapping.txt`: referencia exacta de códigos y offsets. Debe considerarse la fuente de verdad del mapeo.

Los tres archivos técnicos deben mantenerse sincronizados.

## ROM base

```text
Castlevania: Harmony of Dissonance (USA)
Game code: ACHE
Tamaño:    8 MiB
CRC32:     88C1B562
```

Conservar siempre una copia limpia.

## Instalación

1. Hacer copia de seguridad de `DSVEdit/dsvlib/text.rb` y sustituirlo por el `text.rb` de esta carpeta.
2. Aplicar `hod_spanish_chars.ips` a la ROM compatible.
3. Abrir la ROM con DSVEdit y comprobar los caracteres dentro del juego.

DSVEdit debe permitir escribir directamente, sin `{RAW ...}`:

```text
¿Qué ocurrió aquí? ¡Ánimo!
El niño tomó una Poción.
```

## Caracteres soportados

La **fuente grande**, utilizada por diálogos y otros textos, contiene:

```text
á é í ó ú ü ñ
Á É Í Ó Ú Ñ
¿ ¡
```

La **fuente pequeña de menús** se modifica deliberadamente lo mínimo posible:

```text
á é í ó ú Ó ñ
```

`Á É Í Ú ü Ñ ¿ ¡` no se añaden a la fuente pequeña porque no son necesarios en los nombres de objetos previstos. Evitar esos cambios reduce el riesgo de afectar símbolos o comportamientos originales.

Las asignaciones concretas están en `hod_spanish_chars_mapping.txt`. Ese archivo debe considerarse la referencia autoritativa para códigos y offsets.

## Cómo funciona

La solución tiene dos capas.

### Codificación en DSVEdit

HoD sigue una ruta de codificación distinta de las tablas latinas usadas por DSVEdit para otros juegos. Por eso inicialmente rechazaba caracteres como `á`.

El `text.rb` modificado añade un mapeo específico:

```text
carácter español
      ↓
código usado por HoD
```

y también realiza la conversión inversa al volver a leer el texto.

### Glifos en la ROM

Guardar el código no basta: HoD necesita un dibujo asociado.

El IPS reutiliza posiciones prescindibles de las fuentes originales y coloca allí los bitmaps españoles:

```text
"ó" en DSVEdit
      ↓
text.rb escribe el código acordado
      ↓
HoD selecciona el glifo
      ↓
la fuente parcheada dibuja "ó"
```

Modificar solo `text.rb` dejaría glifos incorrectos. Modificar solo la fuente dejaría a DSVEdit sin saber cómo introducir esos caracteres. Ambas partes forman una única solución.

## Las dos fuentes de HoD

### Fuente grande

El bloque principal comienza alrededor de:

```text
0x496314
```

Las entradas relevantes tienen esta estructura:

```text
2 bytes  código del carácter
12 bytes bitmap
```

Cada entrada ocupa 14 bytes. Para modificar un carácter se localiza primero su código real y se cambia únicamente el bitmap asociado; no se debe asumir un offset calculado mediante un índice lineal.

### Fuente pequeña / menús

Los nombres de objetos y ciertas partes de la interfaz usan una fuente pequeña diferente.

Además, la rutina de menú transforma los códigos de texto en índices de esa fuente. Un código no reconocido puede acabar en el glifo de fallback. Por eso un carácter que funciona en un diálogo no funciona necesariamente en `Poción`, `Corazón`, etc.

La solución actual:

- reserva índices distintos para los caracteres realmente necesarios en menús;
- mantiene intacto el glifo vacío/fallback;
- amplía únicamente los rangos necesarios de la rutina;
- no añade a la fuente pequeña caracteres que solo se necesitan en diálogos.

## Proceso de desarrollo

El proceso que llevó a la solución puede resumirse en cuatro pasos.

### 1. Separar codificación y gráficos

Primero se comprobó que DSVEdit rechazaba los caracteres españoles. La revisión de `text.rb` mostró que HoD necesitaba un mapeo propio.

Cuando DSVEdit empezó a guardar los caracteres pero el juego todavía mostraba símbolos incorrectos quedó claro que también había que modificar las fuentes gráficas.

### 2. Analizar la fuente real

Se localizó la fuente grande y se identificó la relación:

```text
código → entrada real → bitmap
```

Esto permitió crear los glifos españoles respetando el estilo de las letras latinas originales.

### 3. Identificar la ruta de los menús

Las pruebas con nombres de objetos demostraron que el menú usa una segunda fuente y una rutina de selección propia. Analizar esa rutina explicó por qué un mismo carácter podía verse bien en diálogo y fallar en inventario.

### 4. Reducir la modificación

Una vez entendido el mecanismo, se decidió añadir a la fuente pequeña únicamente:

```text
á é í ó ú Ó ñ
```

El conjunto completo permanece en la fuente grande. Esta separación mantiene el parche pequeño y evita reutilizar símbolos innecesariamente.

## Criterios para elegir códigos y posiciones

Los códigos no son direcciones libres escogidas al azar. Se reutilizan posiciones que HoD puede manejar y que son prescindibles para la traducción.

Criterios:

1. El código debe ser procesable por HoD.
2. Debe poder asociarse de forma segura a un glifo.
3. No debe eliminar un carácter necesario.
4. En menú debe producir un índice válido y distinto.
5. El índice vacío/fallback debe permanecer intacto.
6. `text.rb`, la fuente grande y, cuando aplique, la fuente pequeña deben compartir exactamente el mismo mapeo.

Consultar siempre `hod_spanish_chars_mapping.txt` para las asignaciones finales.

## Añadir un carácter en el futuro

### Solo diálogo

1. Elegir un código adecuado.
2. Localizar su entrada real en la fuente grande.
3. Sustituir únicamente el bitmap.
4. Añadir el mismo mapeo a `text.rb`.
5. Actualizar el archivo de mapeo.
6. Probar escritura, renderizado y lectura posterior.

### También en menú

Además:

1. comprobar cómo la rutina convierte el código a índice;
2. verificar que no cae en el fallback;
3. reservar un índice de la fuente pequeña sin destruir un símbolo necesario;
4. crear el glifo pequeño;
5. probarlo específicamente en inventario/interfaz.

No ampliar la fuente pequeña salvo que un texto real lo necesite. En especial, cualquier cambio de `ñ` debe comprobarse visualmente para confirmar que el glifo es minúsculo.

## Compatibilidad y builds

Existe **una única fuente de traducción española**, pero pueden existir varios builds binarios dependiendo de la ROM base sobre la que DSVania Editor inserte los textos.

Esto es importante porque se han observado problemas en nombres y descripciones de objetos cuando un parche de traducción generado sobre la ROM limpia se aplica después de REharmonized + Visual Improvement. Insertar los mismos textos directamente con DSVania sobre la ROM ya modificada sí puede producir un resultado correcto.

Por tanto, no se deben mantener traducciones distintas: se mantienen **los mismos textos** y se generan builds distintos.

### Build standalone

```text
ROM USA limpia
→ spanish chars
→ insertar textos españoles con DSVania Editor
→ generar parche standalone
```

Al generar el parche:

```text
ORIGINAL:
ROM USA limpia

MODIFICADA:
ROM USA limpia + spanish chars + textos españoles
```

### Build Visual Improvement

```text
ROM USA limpia
→ Visual Improvement
→ spanish chars
→ insertar los mismos textos españoles con DSVania Editor
→ generar parche compatible
```

Al generar el parche:

```text
ORIGINAL:
ROM USA limpia + Visual Improvement

MODIFICADA:
esa misma base + spanish chars + textos españoles
```

### Build REharmonized + Visual Improvement

```text
ROM USA limpia
→ REharmonized
→ Visual Improvement
→ spanish chars
→ insertar los mismos textos españoles con DSVania Editor
→ generar parche compatible
```

Al generar el parche:

```text
ORIGINAL:
ROM USA limpia + REharmonized + Visual Improvement

MODIFICADA:
esa misma base + spanish chars + textos españoles
```

El usuario final aplicará:

```text
ROM USA limpia
→ REharmonized
→ Visual Improvement
→ traducción española compatible
```

El parche español compatible **no debe incluir** REharmonized ni Visual Improvement: esos hacks forman parte del archivo base/original utilizado para generar el diff.

### Regla fundamental al generar parches

Comparar siempre:

```text
BASE X
vs.
BASE X + Spanish
```

Nunca:

```text
ROM limpia
vs.
REharmonized + Visual + Spanish
```

porque eso incluiría accidentalmente cambios de los hacks externos dentro del parche español.

Herramientas como Flips/Floating IPS pueden utilizarse para crear el parche. Siempre que sea posible, verificar después que:

```text
BASE + parche generado == ROM modificada esperada
```

byte por byte.

### Cambios de versión de hacks externos

Si cambia REharmonized o Visual Improvement, el build correspondiente debe considerarse **no verificado** hasta regenerarlo y probarlo.

Proceso:

1. construir la nueva ROM base;
2. aplicar `spanish chars`;
3. insertar los mismos textos con DSVania;
4. generar de nuevo el parche contra esa misma base;
5. probar diálogos, objetos, descripciones y fuentes.

No asumir que dos versiones distintas de un hack son binariamente compatibles.

## Pruebas recomendadas

Después de cualquier cambio en fuentes o mapeo probar al menos:

```text
áéíóú ñ
ÁÉÍÓÚ Ñ
¿Qué ocurrió aquí? ¡Bien!
Poción
Corazón
```

Comprobar:

1. que DSVEdit guarda sin errores;
2. que los diálogos muestran los caracteres correctos;
3. que los acentos necesarios aparecen en inventario/menús;
4. que los espacios y zonas vacías del menú siguen vacíos;
5. que DSVEdit decodifica correctamente los caracteres al reabrir el texto.

## Reglas para futuras modificaciones

Si otra persona o una IA continúa este trabajo:

1. No cambiar un código en `text.rb` sin comprobar el glifo que lo representa.
2. No modificar un glifo sin comprobar qué código y qué ruta de renderizado lo utilizan.
3. No asumir que la fuente grande y la fuente pequeña funcionan igual.
4. Mantener intacto el índice vacío/fallback del menú.
5. No añadir caracteres a la fuente pequeña salvo que un texto real los necesite.
6. Consultar `hod_spanish_chars_mapping.txt` antes de modificar códigos u offsets.
7. Probar nombres y descripciones de objetos además de diálogos.
8. Mantener una única fuente de textos españoles para todos los builds.
9. Generar cada parche contra exactamente la misma base para la que está destinado.
10. Si cambia REharmonized o Visual Improvement, regenerar y volver a validar el build.

### Checklist mínimo de validación

Probar al menos:

```text
áéíóú ñ
ÁÉÍÓÚ Ñ
¿Qué ocurrió aquí? ¡Bien!
Poción
Corazón
```

Comprobar que:

- DSVEdit guarda y vuelve a leer los caracteres correctamente;
- los diálogos muestran los glifos correctos;
- los caracteres necesarios aparecen correctamente en objetos/menús;
- la `ñ` de menú se ve como minúscula;
- los espacios y zonas vacías siguen vacíos;
- nombres y descripciones de objetos no presentan corrupción.

## Trabajo previo y créditos

Esta solución se benefició del proyecto brasileño:

```text
chod-traducao-ptbr
https://github.com/leomontenegro6/chod-traducao-ptbr
```

El trabajo de **leomontenegro6 y colaboradores** sirvió como referencia para confirmar la viabilidad de los caracteres acentuados, localizar y comprender las fuentes y conocer técnicas ya utilizadas en una traducción real.

La implementación española no es una copia de su parche gráfico. A partir de esas referencias se analizó directamente la ROM USA y se adaptó la solución a las necesidades concretas del español y de los menús.

También se utiliza y modifica **DSVania Editor / DSVEdit**, desarrollado por **LagoLunatic y colaboradores**:

```text
https://github.com/LagoLunatic/DSVEdit
```

El `text.rb` incluido es una modificación específica del archivo original de DSVEdit.

Se recomienda conservar estos créditos y referencias en cualquier redistribución o trabajo derivado.

## Resumen de mantenimiento

```text
1. text.rb controla la codificación y decodificación.

2. El IPS contiene los glifos y el pequeño ajuste del renderizador
   necesario para los caracteres de menú.

3. hod_spanish_chars_mapping.txt mantiene ambas partes sincronizadas.
```

Mantener intacto el fallback del menú, no ampliar la fuente pequeña sin necesidad y validar cada build contra la base exacta para la que se genera.
