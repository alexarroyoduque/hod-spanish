# Castlevania: Harmony of Dissonance - spanish (patch)

# * * * EN DESARROLLO * * *

Parche de traducción del videojuego Castlevania: Harmony of Dissonance al español. Ha sido realizada con IA y posterior revisión humana.

El parche solo altera los textos, no cambia gráficos por lo que textos que haya en forma de imágenes se mantienen. Esto se ha hecho así para que la traducción pueda combinarse con otros parches de mejora visual.

- Se han agregado algunas descripciones que ayudan más al jugador en llaves y pistas.

## ¿Cómo aplicar el parche?

- Disponer de una (ROM) USA de Castlevania: Harmony of Dissonance. 

- [Descargar el parche hod-spanish.ips](./hod-spanish.ips).

- [Aplicar el parche](https://www.romhacking.net/patch/).

```
Database match: Castlevania - Harmony of Dissonance (USA)
Database: No-Intro: Game Boy Advance (v. 20210227-023848)
File/ROM SHA-1: B90DA0D9BE0B3A0893CD9E2C399056BCF9579E21
File/ROM CRC32: 88C1B562
```

DSVania solo funciona con la región de USA por eso es el parche solo funciona con esta región.

## Estructura del proyecto

- `references/hod-texts-original/`: textos originales en inglés (extraídos de la ROM USA con el editor [DSVania](https://www.romhacking.net/community/4318)), en formato CSV (`0xHEX,"texto"`). Es la fuente de la traducción, no se modifica. Obtenidos con DSVania.
- `hod-texts-spanish/`: textos traducidos al español, listos para reimportar a la ROM con DSVania. Misma estructura y códigos hex que los originales.
- `references/` (resto de archivos): material de apoyo consultado durante la traducción (terminología, nombres correctos según el japonés original, guías de objetos/enemigos, walkthrough en español, parche de corrección de textos en inglés). No se traducen ni se modifican.
- `SKILL.md`: definición del flujo de trabajo y las reglas de traducción seguidas (terminología, estilo, restricciones de caracteres, límites de longitud por campo).

## Estado de la traducción

Todos los archivos traducibles de `references/hod-texts-original/` están traducidos y validados en `hod-texts-spanish/`:

| Archivo | Contenido | Estado |
|---|---|---|
| Character Names.csv | Nombres de personajes | Traducido |
| Enemy Names.csv | Nombres de enemigos | Traducido |
| Item Names.csv | Nombres de objetos | Traducido |
| Item Descriptions.csv | Descripciones de objetos | Traducido |
| Menus.csv | Menús, guardado rápido, diálogo del Mercader | Traducido |
| Events.csv | Diálogos de la historia principal | Traducido |
| Music Names.csv | Títulos de pistas (sound test) | Sin traducir (títulos propios/artísticos) |

Validado: número de entradas idéntico al original en los 7 archivos, control markers (`{WAITINPUT}`, `{NAMEINSERT}`, etc.) preservados y sin restos de texto en inglés. Pendiente: revisión ortográfica para añadir tildes, eñe y signos de apertura ahora que la fuente del juego los soporta (ver Limitaciones conocidas).

## Limitaciones conocidas

- Cada campo tiene un límite de longitud teórico según el lo que se puede intepretar del juego original:

  - 14 caracteres: nombres de objeto, personajes y enemigos
  - ~37-40 caracteres: en diálogos, descripciones
  - 23 caracteres: en títulos de pista

- La fuente del juego soporta tildes, eñe (á,é,í,ó,ú,ñ,ü,Á,É,Í,Ó,Ú,Ñ) y los signos `¿`/`¡`.
  - Pero en nombres de objetos y enemigos ÁÉÍÚñÑü¿¡ no está soportados porque no se ha encontrado ningún nombre con esos caracteres.
- Los signos `¿`/`¡` todavía no se han incluido en los diálogos por limitaciones técnicas. Queda pendiente para más adelante.

## Credits
- -SuXei999- testing
- **leomontenegro6 y las personas que participaron en `chod-traducao-ptbr`**, cuyo trabajo previo sobre la traducción brasileña, las fuentes y la codificación de HoD fue una referencia fundamental para orientar esta implementación española.
- [LagoLunatic, DSVania Edit creator](https://www.romhacking.net/community/4318)
- [Efrem Orizzonte, item list](https://gamefaqs.gamespot.com/gba/554981-castlevania-harmony-of-dissonance/faqs/19328)
- [Uriel Laurito, spanish translation](https://gamefaqs.gamespot.com/gba/554981-castlevania-harmony-of-dissonance/faqs/24513)
- [BFrayne, translation guide](https://gamefaqs.gamespot.com/gba/554981-castlevania-harmony-of-dissonance/faqs/17572)
- [Efrem Orizzonte, monster list](https://gamefaqs.gamespot.com/gba/554981-castlevania-harmony-of-dissonance/faqs/19329)
- [spiffy, location fixes patch](http://www.romhacking.net/community/3923)

