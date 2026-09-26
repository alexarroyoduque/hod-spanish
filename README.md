# Castlevania: Harmony of Dissonance - spanish (patch)

# * * * EN DESARROLLO * * *

Parche de traducción del videojuego Castlevania: Harmony of Dissonance al español. Ha sido realizada con IA y posterior revisión humana.

El parche solo altera los textos, no cambia gráficos por lo que textos que haya en forma de imágenes se mantienen. **Se ha hecho así para que la traducción pueda combinarse con otros parches de mejora visual.**

## ¿Cómo aplicar el parche?
- Disponer de una (ROM) USA de Castlevania: Harmony of Dissonance. (DSVania solo funciona la ROM USA por eso el parche solo es compatible con esta región).
- [Descargar el parche hod-spanish.ips](./hod-spanish.ips).
- [Aplicar el parche](https://www.romhacking.net/patch/).

```
Database match: Castlevania - Harmony of Dissonance (USA)
Database: No-Intro: Game Boy Advance (v. 20210227-023848)
File/ROM SHA-1: B90DA0D9BE0B3A0893CD9E2C399056BCF9579E21
File/ROM CRC32: 88C1B562
```

### Compatibilidad con Visual Improvement (Pemburu Vampir)
Se ha intentado que exista un único parche de traducción pero al combinarlo con Visual Improvement aparecián errores que eran dificiles de corregir. Esto es debido a que para agregar tildes y caracteres del español ha sido necesario alterar la fuente gráfica del juego chocando con el parche visual.
Para poder disfrutar de la traducción se ha creado el parche de compatibilidad.
- Primero debe aplicarse el parche Visual Improvement
- Segundo aplicar el [parche hod-spanish-compatibility-visual-improvement1.2.9.ips](./hod-spanish-compatibility-visual-improvement1.2.9.ips) al resultado anterior

Si se desea combinar con REharmonized el orden de aplicación de parches sería:
- REharmonized
- Visual Improvement
- hod-spanish-compatibility-visual-improvement1.2.9

## Estructura del proyecto

- `references/hod-texts-original/`: textos originales en inglés (extraídos de la ROM USA con el editor [DSVania](https://www.romhacking.net/community/4318)), en formato CSV (`0xHEX,"texto"`). Es la fuente de la traducción, no se modifica.
- `hod-texts-spanish/`: textos traducidos al español, listos para reimportar a la ROM con DSVania. Misma estructura y códigos hex que los originales.
- `references/` (resto de archivos): material de apoyo consultado durante la traducción (terminología, nombres correctos según el japonés original, guías de objetos/enemigos, walkthrough en español, parche de corrección de textos en inglés). No se traducen ni se modifican.
- `SKILL.md`: definición del flujo de trabajo y las reglas de traducción seguidas.
- `dev`: información para desarrolladores.
 -  Explicación del proceso de desarrollo
 - "hackeo" de DSVania para incorporar tildes
 - Incluye el .ips para agregar tildes a la ROM original
 - script `rom-patcher.ps1`para generar ayudar en la generación del parche con múltiples combinaciones
  - Para generar el parche de compatibilidad con Visual Improvement es necesario generar una `ROM USA + Visual Improvement + spanish chars`, después inyectar los textos traducidos con DSVania y posteriormente generar el parche.

## Decisiones creativas
- Se ha intentado mantener una traducción cercana al original basada en las referencias obtenidas
- Se mantienen los nombres originales de las canciones
- Las descripciones de algunas pistas y llaves se han adaptado para facilitar la exploración al jugador:
  - Llave Cráneo: Abre puertas con diseño de calavera verdes. (Originalmente no se indica el color verde)
  - Llave Portal
    - Lure Key: en versión original. Lure viene a significar "señuelo" o "atraer", esa atracción evoca como el portal te traspasa de un castillo a otro. En español "Llave Señuelo" no encaja demasiado.
    - Abre las puertas con brillo arcoiris. (Originalmente se indica un brillo dorado).
  - JB's Bracelet: traducido como Brazalete JB.
  - MK's Bracelet: traducido como Brazalete MK. En la conversación donde se obtiene el brazalete, Maxim indica que el objeto permite abrir una puerta, en la descripción se detalla que es la puerta con brillo ámbar.
  - Llave compuerta: Úsala en la cabeza de león de las cuevas. (Más específica que la pista original.)
  - Pista 1: Drena las cuevas en la cabeza de león con la llave. (Es más específico que la pista original que habla simplemente de un posible mecanismo de drenaje.)
  - Pista 2: Los ojos de la diosa señalan un pasadizo secreto en el acueducto. (Se agrega la pisa de la zona del acueducto.)
  - Bullet Tip: traducido como "Alma Christopher".
  - Cipher's Charm: traducido como Cristal de Sypha.
  - Crushing Stone: Traducido como Punta Demoledora. Es la modificación del látigo que rompe muros.
  - Red Stone: Las modificaciones del látigo con esta estructura se traducen como Gema Roja.
  - Walk Armor: tradudcido como Armadura Errante.
  - Crush Boots: Botas de Choque. Son las botas que rompen techos.
  - Floating Boots: Botas aladas, te permiten flotar.

## Limitaciones técnicas

- Cada campo tiene un límite de longitud teórico según el lo que se puede intepretar del juego original:
  - 16 caracteres: nombres de objeto, personajes y enemigos. Hay algunos nombres que con 16 letras no se ven bien porque ocupan demasiado y se salen de su caja por lo que hay que recortar.
  - ~37-40 caracteres: en diálogos, descripciones
  - 23 caracteres: en títulos de pista
- La fuente del juego parcheada agrega tildes (á,é,í,ó,ú,ñ,ü,Á,É,Í,Ó,Ú,Ñ), eñe  y los signos `¿`/`¡` para diálogos y descripciones de objetos.
- En nombres de objetos y enemigos los caracteres ÁÉÍÚÑü¿¡ no están soportados porque no se ha encontrado ningún elemento con esas letras. Estos términos se muestran en el juego con otra fuente.

## Credits
- -SuXei999- testing
- leomontenegro6 y las personas que participaron en [chod-traducao-ptbr](https://github.com/leomontenegro6/chod-traducao-ptbr), cuyo trabajo previo sobre la traducción brasileña, las fuentes y la codificación fue una referencia fundamental para orientar esta implementación española.
- [LagoLunatic, DSVania Edit creator](https://www.romhacking.net/community/4318)
- [Efrem Orizzonte, item list](https://gamefaqs.gamespot.com/gba/554981-castlevania-harmony-of-dissonance/faqs/19328)
- [Uriel Laurito, spanish translation](https://gamefaqs.gamespot.com/gba/554981-castlevania-harmony-of-dissonance/faqs/24513)
- [BFrayne, translation guide](https://gamefaqs.gamespot.com/gba/554981-castlevania-harmony-of-dissonance/faqs/17572)
- [Efrem Orizzonte, monster list](https://gamefaqs.gamespot.com/gba/554981-castlevania-harmony-of-dissonance/faqs/19329)
- [spiffy, location fixes patch](http://www.romhacking.net/community/3923)

