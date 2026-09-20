# Harmony of Dissonance (USA): soporte técnico de caracteres españoles

> Documento técnico de referencia para mantener, verificar y ampliar el soporte de caracteres españoles en **Castlevania: Harmony of Dissonance (USA)** con **DSVania Editor / DSVEdit**.
>
> Este documento no contiene historial de versiones. Su objetivo es permitir que un desarrollador o una IA pueda reproducir y extender la implementación sin repetir el trabajo de ingeniería inversa.

## Archivos que deben mantenerse sincronizados

```text
hod_spanish_chars.ips
text_spanish_chars_DSVania.rb
hod_spanish_chars_mapping.md
```

El `.rb` controla la **codificación/decodificación** en DSVEdit. El `.ips` contiene los **glifos** y los ajustes mínimos del renderer. Este documento describe el contrato entre ambos.

---

## ROM de referencia

| Campo | Valor |
|---|---|
| Juego | Castlevania: Harmony of Dissonance (USA) |
| Game code | `ACHE` |
| Tamaño | 8 MiB |
| CRC32 | `88C1B562` |

Todos los offsets de este documento corresponden a esta ROM limpia.

---

## Arquitectura

HoD utiliza dos rutas relevantes para representar texto:

1. **Fuente grande**: diálogos y texto general.
2. **Fuente pequeña**: menús y nombres de objetos.

Que un carácter funcione en diálogos **no implica** que funcione en nombres de objetos.

```text
Carácter Unicode escrito en DSVEdit
                │
                ▼
 text_spanish_chars_DSVania.rb
                │
                ▼
       código de 16 bits HoD
                │
        ┌───────┴────────┐
        ▼                ▼
   Fuente grande    Renderer menú
        │                │
        ▼                ▼
     diálogo       índice small-font
                         │
                         ▼
                    glifo de menú
```

---

## Caracteres soportados

### Fuente grande / diálogos

```text
á é í ó ú ü ñ
Á É Í Ó Ú Ñ
¿ ¡
```

### Fuente pequeña / menús y objetos

```text
á é í ó ú Ó ñ
```

### Deliberadamente solo en diálogos

```text
Á É Í Ú ü Ñ ¿ ¡
```

`Ü` no está mapeada.

No se debe añadir un carácter a la fuente pequeña únicamente porque exista en la grande. Solo debe hacerse cuando un texto real de menú/objeto lo necesite.

---

## Tabla autoritativa de caracteres

| Carácter | Código HoD | Entrada fuente grande | Bitmap fuente grande | Índice small | Registro small | Bitmap small |
|---|---:|---:|---:|---:|---:|---:|
| `Ó` | `0x827A` | `0x497088` | `0x49708A–0x497095` | `0x1A` | `0x4960AF` | `0x4960B2–0x4960B8` |
| `á` | `0x829C` | `0x497256` | `0x497258–0x497263` | `0x3B` | `0x4961F9` | `0x4961FC–0x496202` |
| `é` | `0x829D` | `0x497264` | `0x497266–0x497271` | `0x3C` | `0x496203` | `0x496206–0x49620C` |
| `í` | `0x829E` | `0x497272` | `0x497274–0x49727F` | `0x3D` | `0x49620D` | `0x496210–0x496216` |
| `ó` | `0x829F` | `0x497280` | `0x497282–0x49728D` | `0x3E` | `0x496217` | `0x49621A–0x496220` |
| `ú` | `0x82A0` | `0x49728E` | `0x497290–0x49729B` | `0x3F` | `0x496221` | `0x496224–0x49622A` |
| `ñ` | `0x819A` | `0x4967F2` | `0x4967F4–0x4967FF` | `0x52` | `0x4962DF` | `0x4962E2–0x4962E8` |
| `Á` | `0x82A4` | `0x4972C6` | `0x4972C8–0x4972D3` | — | — | — |
| `É` | `0x82A5` | `0x4972D4` | `0x4972D6–0x4972E1` | — | — | — |
| `Í` | `0x82A6` | `0x4972E2` | `0x4972E4–0x4972EF` | — | — | — |
| `Ú` | `0x82A8` | `0x4972FE` | `0x497300–0x49730B` | — | — | — |
| `Ñ` | `0x82A9` | `0x49730C` | `0x49730E–0x497319` | — | — | — |
| `¡` | `0x82AE` | `0x497352` | `0x497354–0x49735F` | — | — | — |
| `¿` | `0x82B0` | `0x49736E` | `0x497370–0x49737B` | — | — | — |
| `ü` | `0x82B8` | `0x4973DE` | `0x4973E0–0x4973EB` | — | — | — |

### Particularidad de `ñ`

`ñ` utiliza `0x819A`, posición originalmente asociada al símbolo `★`.

Por tanto:

- `★` deja de estar disponible en esa posición.
- El glifo de `ñ` debe ser **minúsculo**.
- El bitmap se basa en la `n` minúscula original de HoD y añade la virgulilla.

---

## Mapeo de DSVEdit

`text_spanish_chars_DSVania.rb` debe utilizar exactamente estos códigos:

```text
Ó -> 0x827A

á -> 0x829C
é -> 0x829D
í -> 0x829E
ó -> 0x829F
ú -> 0x82A0
ñ -> 0x819A

Á -> 0x82A4
É -> 0x82A5
Í -> 0x82A6
Ú -> 0x82A8
Ñ -> 0x82A9
¡ -> 0x82AE
¿ -> 0x82B0
ü -> 0x82B8
```

El encoder y el decoder deben usar la misma tabla.

> **Regla crítica:** si `text.rb` asigna un carácter a un código y el IPS dibuja ese carácter en otro, DSVEdit podrá guardar el texto sin error pero el juego mostrará un glifo incorrecto.

---

## Fuente grande

### Localización

El bloque principal comienza aproximadamente en:

```text
0x496314
```

### Estructura de una entrada

```text
+0x00  byte 1 del código
+0x01  byte 2 del código
+0x02  fila 0 del bitmap
...
+0x0D  fila 11 del bitmap
```

Total:

```text
14 bytes
= 2 bytes de código
+ 12 bytes de bitmap
```

### Regla de mantenimiento

**No calcular un glifo mediante `índice × 14` sin verificarlo.**

El procedimiento correcto es:

1. buscar los dos bytes del código real en la tabla;
2. confirmar la entrada;
3. conservar los dos bytes del código;
4. modificar únicamente los 12 bytes del bitmap.

Ejemplo:

```text
ñ
código:  0x819A
entrada: 0x4967F2
bitmap:  0x4967F4–0x4967FF
```

---

## Fuente pequeña / menús

### Inicio del bloque

```text
0x495FAB
```

### Tamaño de registro

```text
10 bytes
```

### Estructura observada

```text
+0x00..+0x02  metadatos / índice
+0x03..+0x09  bitmap de 7 bytes
```

Por tanto:

```text
registro = 0x495FAB + (small_index × 10)
bitmap   = registro + 3
```

Esta fórmula coincide con todos los glifos de menú actualmente verificados.

### Índice reservado

> **`small-font index 0x3A` es EMPTY/FALLBACK y NO debe modificarse.**

No reutilizar `0x3A` para ningún carácter.

---

## Renderer de menús

El renderer original reconoce los rangos latinos normales y los convierte en índices de la fuente pequeña.

El parche modifica dos comparaciones:

```text
ROM 0x143DC
CMP #0x19  ->  CMP #0x1A
```

```text
ROM 0x14404
CMP #0x19  ->  CMP #0x1F
```

Esto habilita:

| Código | Índice small | Resultado |
|---:|---:|---|
| `0x827A` | `0x1A` | `Ó` |
| `0x829B` | `0x3A` | vacío / fallback |
| `0x829C` | `0x3B` | `á` |
| `0x829D` | `0x3C` | `é` |
| `0x829E` | `0x3D` | `í` |
| `0x829F` | `0x3E` | `ó` |
| `0x82A0` | `0x3F` | `ú` |

`ñ = 0x819A` no depende de esta ampliación. Reutiliza la ruta preexistente del símbolo `★` y sustituye su glifo por `ñ`.

---

## Offsets de la fuente pequeña

| Carácter | Índice | Registro | Bitmap |
|---|---:|---:|---:|
| `Ó` | `0x1A` | `0x4960AF` | `0x4960B2–0x4960B8` |
| `á` | `0x3B` | `0x4961F9` | `0x4961FC–0x496202` |
| `é` | `0x3C` | `0x496203` | `0x496206–0x49620C` |
| `í` | `0x3D` | `0x49620D` | `0x496210–0x496216` |
| `ó` | `0x3E` | `0x496217` | `0x49621A–0x496220` |
| `ú` | `0x3F` | `0x496221` | `0x496224–0x49622A` |
| `ñ` | `0x52` | `0x4962DF` | `0x4962E2–0x4962E8` |

---

## Cómo añadir un carácter especial nuevo

Primero determinar si será:

- **A. Solo diálogo**
- **B. Diálogo + menú**

No elegir código ni offset antes de tomar esta decisión.

### A. Solo diálogo

1. Elegir un código HoD candidato cuyo glifo original sea prescindible.
2. Buscar el código exacto en la fuente grande.
3. Confirmar que corresponde a una entrada válida de 14 bytes.
4. Mantener los dos bytes del código.
5. Sustituir únicamente los 12 bytes del bitmap.
6. Añadir `carácter <-> código` a la tabla HoD de `text.rb`.
7. Comprobar codificación y decodificación en DSVEdit.
8. Probar el glifo dentro del juego.
9. Actualizar este documento.

### B. Diálogo + menú

Realizar primero todos los pasos anteriores y después:

1. Analizar cómo el renderer del menú trata el código candidato.
2. Determinar el índice small exacto resultante.
3. **Descartar el candidato si resuelve a `0x3A`.**
4. Comprobar que el slot small puede reutilizarse sin eliminar un símbolo necesario.
5. Calcular el registro:

```text
0x495FAB + (índice × 10)
```

6. Confirmar que el bitmap comienza en `registro + 3`.
7. Dibujar el glifo pequeño de 7 bytes.
8. Si el código está fuera de los rangos admitidos, analizar el renderer antes de ampliar comparaciones.
9. No ampliar rangos a ciegas: verificar cada nuevo código que quedaría admitido.
10. Probar el carácter en un nombre real de objeto/menú.
11. Comprobar espacios, celdas vacías y fallback.
12. Actualizar `text.rb` y este documento conjuntamente.

Si no existe un slot pequeño seguro, es preferible mantener el carácter **solo en diálogos**.

---

## Diseño de nuevos glifos

Siempre que sea posible, partir de la letra latina original del propio juego:

```text
á = a original + tilde aguda
ñ = n original + virgulilla
Ó = O original + tilde aguda
```

Esto conserva:

- grosor;
- anchura;
- baseline;
- estilo visual.

En la fuente pequeña solo hay **7 bytes de bitmap**, por lo que el signo diacrítico debe diseñarse dentro de ese espacio.

---

## Checklist de validación

### DSVEdit

- [ ] El carácter puede escribirse normalmente.
- [ ] Guardar no produce errores.
- [ ] Al volver a abrir el texto se decodifica al mismo carácter Unicode.

### Diálogos

- [ ] El glifo tiene la forma correcta.
- [ ] Mayúscula/minúscula correcta.
- [ ] Tilde, diéresis o virgulilla legible.
- [ ] Los caracteres adyacentes no se ven afectados.

### Menús / objetos

Cuando aplique:

- [ ] Aparece correctamente en el nombre del objeto.
- [ ] Aparece correctamente en mensajes que utilicen la fuente pequeña.
- [ ] Los demás caracteres españoles siguen funcionando.
- [ ] Los espacios siguen vacíos.
- [ ] `small index 0x3A` permanece intacto.
- [ ] Cualquier símbolo original sacrificado está documentado.

### Cadenas de regresión

Diálogos:

```text
áéíóú ü ñ
ÁÉÍÓÚ Ñ
¿Qué ocurrió aquí? ¡Bien!
```

Menús:

```text
Poción
Corazón
```

y un objeto real que contenga `ñ`, cuando exista.

---

## Huella del parche

El IPS suministrado se verificó contra la ROM base indicada anteriormente.

### Bytes efectivos modificados

```text
278 bytes
```

### Renderer

```text
0x0143DC
0x014404
```

### Fuente pequeña

```text
0x4960B2–0x4960B9
0x4961FC–0x496202
0x496206–0x49620C
0x496210–0x496216
0x49621A–0x496220
0x496224–0x49622A
0x4962E2–0x4962E8
```

Las modificaciones de la fuente grande están limitadas a las entradas documentadas en la tabla autoritativa.

Para estudiar compatibilidad con otro hack, comparar sus offsets modificados con esta huella. Un solapamiento binario no implica automáticamente incompatibilidad, pero cualquier escritura diferente sobre estas zonas de fuentes/renderer debe investigarse.

---

## Compatibilidad y política de builds

El soporte de caracteres debe mantenerse conceptualmente separado de los textos traducidos durante el desarrollo.

Se ha analizado de forma independiente respecto a:

- **REharmonized (USA)**
- **CV HOD Visual Improvement V1.2.8**

Esto **no garantiza por sí solo** la compatibilidad de un parche completo de traducción. DSVEdit puede reconstruir datos de texto de forma distinta dependiendo de la ROM base sobre la que se trabaje.

Por tanto:

- este documento describe el soporte de caracteres/fuentes;
- no inferir compatibilidad completa de la traducción únicamente a partir de la compatibilidad de fuentes;
- volver a probar builds combinadas cuando cambien los textos, punteros o los hacks externos.

---

## Archivos que debe recibir un futuro mantenedor o IA

Para extender este sistema de forma fiable proporcionar juntos:

1. ROM USA limpia, CRC32 `88C1B562`.
2. `hod_spanish_chars.ips`.
3. `text_spanish_chars_DSVania.rb`.
4. Este documento.

Si está disponible, añadir también una ROM con el parche de caracteres aplicado para facilitar comparaciones binarias.

Con estos archivos debe ser posible añadir un nuevo carácter especial sin repetir la ingeniería inversa original.
