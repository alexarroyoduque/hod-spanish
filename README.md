# Castlevania: Harmony of Dissonance - spanish (patch)

# * * * EN DESARROLLO * * *

Parche de traducción del videojuego Castlevania: Harmony of Dissonance al español. Ha sido realizada con IA y posterior revisión humana.

El parche solo altera los textos, no cambia gráficos por lo que textos que haya en forma de imágenes se mantienen. **Se ha hecho así para que la traducción pueda combinarse con otros parches de mejora visual.**

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

- `references/hod-texts-original/`: textos originales en inglés (extraídos de la ROM USA con el editor [DSVania](https://www.romhacking.net/community/4318)), en formato CSV (`0xHEX,"texto"`). Es la fuente de la traducción, no se modifica.
- `hod-texts-spanish/`: textos traducidos al español, listos para reimportar a la ROM con DSVania. Misma estructura y códigos hex que los originales.
- `references/` (resto de archivos): material de apoyo consultado durante la traducción (terminología, nombres correctos según el japonés original, guías de objetos/enemigos, walkthrough en español, parche de corrección de textos en inglés). No se traducen ni se modifican.
- `SKILL.md`: definición del flujo de trabajo y las reglas de traducción seguidas.
- `dev`: información para desarrolladores. Explicación del proceso de desarrollo y "hackeo" de DSVania para incorporar tildes.

## Decisiones creativas
- Se ha intentado mantener una traducción cercana al original basada en las referencias obtenidas
- Se mantienen los nombres originales de las canciones
- Las descripciones de algunas pistas y llaves se han adaptado para facilitar la exploración al jugador:
  - Llave Cráneo: Abre puertas con diseño de calavera verdes. (En la descripción original no se indica el color verde)
  - Llave Señuelo: Abre las puertas con brillo arcoiris. (En la versión original se indica un brillo dorado)
  - JB's Bracelet: traducido como Brazalete JB.
  - MK's Bracelet: traducido como Brazalete MK. En la conversación donde se obtiene el brazalete, Maxim indica que el objeto permite abrir una puerta, en la descripción se detalla que es la puerta con brillo ámbar.
  - Llave compuerta: Úsala en la cabeza de león de las cuevas. (Más específica que la pista original.)
  - Pista 1: Drena las cuevas en la cabeza de león con la llave. (Es más específico que la pista original que habla simplemente de un posible mecanismo de drenaje.)
  - Pista 2: Los ojos de la diosa señalan un pasadizo secreto en el acueducto. (Se agrega la pisa de la zona del acueducto.)
  - Bullet Tip: traducido como "Eco Christopher". Sería más correcto "Alma Christopher" pero hay una limitación de caracteres.
  - Cipher's Charm: traducido como Cristal Sypha

## Limitaciones técnicas

- Cada campo tiene un límite de longitud teórico según el lo que se puede intepretar del juego original:

  - 14 caracteres: nombres de objeto, personajes y enemigos
  - ~37-40 caracteres: en diálogos, descripciones
  - 23 caracteres: en títulos de pista
  - Al probar el juego con parches como REharmonized + Visual Improvement se ha detectado que los textos de menú fallan si se sobrepasa la logintud original por lo que se han tenido que ajustar algunos términos. Esto también se ha visto en algunos diálogos. (Por ejemplo el primer "Aaargh!!" de Maxim si se traduce como "¡¡Aaargh!!" ocupando 2 espacios más no se visualiza bien después, por lo que se ha optado por "¡Aaargh!") 

- La fuente del juego parcheada agrega tildes (á,é,í,ó,ú,ñ,ü,Á,É,Í,Ó,Ú,Ñ), eñe  y los signos `¿`/`¡` para diálogos y descripciones de objetos.
- En nombres de objetos y enemigos los caracteres ÁÉÍÚñÑü¿¡ no están soportados porque no se ha encontrado ningún elemento con esas letras. Estos términos se muestran en el juego con otra fuente.

## Credits
- -SuXei999- testing
- leomontenegro6 y las personas que participaron en [chod-traducao-ptbr](https://github.com/leomontenegro6/chod-traducao-ptbr), cuyo trabajo previo sobre la traducción brasileña, las fuentes y la codificación fue una referencia fundamental para orientar esta implementación española.
- [LagoLunatic, DSVania Edit creator](https://www.romhacking.net/community/4318)
- [Efrem Orizzonte, item list](https://gamefaqs.gamespot.com/gba/554981-castlevania-harmony-of-dissonance/faqs/19328)
- [Uriel Laurito, spanish translation](https://gamefaqs.gamespot.com/gba/554981-castlevania-harmony-of-dissonance/faqs/24513)
- [BFrayne, translation guide](https://gamefaqs.gamespot.com/gba/554981-castlevania-harmony-of-dissonance/faqs/17572)
- [Efrem Orizzonte, monster list](https://gamefaqs.gamespot.com/gba/554981-castlevania-harmony-of-dissonance/faqs/19329)
- [spiffy, location fixes patch](http://www.romhacking.net/community/3923)

