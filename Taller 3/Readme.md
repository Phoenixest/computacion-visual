# Taller de Rasterización

La rasterización es una técnica utilizada para definir el espacio de una imagen en 2 o 3 dimensiones. Cuando traemos un objeto de un espacio tridimencional a un espacio 2D,
muchas veces queremos saber que parte del objeto debemos representar en el plano y como se observa esta imagen. También hay problemas cuando no es
uno el objeto que traemos a un plano de proyección sino que son varios, y más cuando estos se superponen. Aquí es clave la técnica de rasterización.

## Tareas

Emplee coordenadas baricéntricas para:

1. Rasterizar un triángulo.
2. Sombrear su superficie a partir de los colores de sus vértices.
3. Implementar un algoritmo de anti-aliasing para sus aristas.

* ## Rasterización:

Para el desarrollo del primer punto tomamos el programa de referencia en el que ya se generan triángulos al azar ubicando 3 puntos en el plano deseado.
Tenemos también una escena donde vamos a trabajar y un nodo para ubicarnos. Luego tenemos una grilla que funcionará a modo de pixeles en donde ubicaremos
nuestro triángulo y definiremos el proceso de rasterización.

Empezamos ubicando los vertices y conociendo también como se ubican dentro del plano y sus coordenadas dentro de la grilla. Luego utilizamos las funciones de
bordes para saber si un punto esta dentro o fuera de cada una de las aristas del triángulo. Si se encuentra dentro de las 3 aristas, decimos que
el punto está dentro del triángulo. Como los puntos son generados al azar, el triángulo puede estar definido de forma horaria o anti-horaria, lo cual implica
que no solo deben estar todos adentro, sino también debemos contemplar que si el punto está fuera de todos los lados, el triángulo está definido de forma
anti-horaria y su área es negativa. 

Para cada punto tomamos el centro de cada pixel, este lo pasamos a la función y si se encuentra, pedimos que se pinte de un color blanco.

* ## Sombreado:

Con lo anterior, tenemos el triángulo rasterizado, pero queremos sacarle más provecho a este proceso, y a las coordenadas baricéntricas que aún no se han utilizado.
Al poner un punto en el triángulo, se pueden conseguir otros 3 triángulos trazando lineas desde el punto a los vértices. La función de de bordes
nos da el valor del área de este triángulo nuevo que se genera, por 2. A su vez esta área está relacionada con el área pequeña de estos triángulos generados
y nos dice que proporción de cada vertice posee el punto, en función del cociente de las áreas de los triángulos. Con esto tenemos la coordenada 
baricéntrica de cada punto con respecto a sus vertices. Con ella podemos mapearla a algún color y esto nos sombrea la superficie del triángulo.

* ## Anti-Aliasing:

Cuando utilizamos pixeles, y más cuando son pocos, se genera algo que denominamos "dientes de sierra". Estos pixeles sobrantes o faltantes que hacen que nuestras
representaciones sean imperfectas no se pueden evitar, pero se pueden mitigar. En el link de anti-aliasing se hace mención de una técnia que nos permite
hacer que no sea tan notorio. En los anteriores pasos estabamos tomando el punto central del pixel para hacer nuestros cálculos. Si este punto no estaba dentro del
triángulo, no era tenido en cuenta. Lo que hicimos fue tomar 4 puntos en el pixel, como si este estuviera dividido en 4 pixeles más pequeños, y determinar
desde ahí si el pixel en su totalidad estaba dentro o fuera del triángulo. Si los 4 puntos estaban dentro, el pixel se pintaba con su color normal. Si
sólo 1, 2 o 3 puntos estaban dentro, se pintaba una fracción de ese color, como si estuviera promediado con negro, el color del fondo. Esto permitió mitigar
algunos pixeles que estaban en el borde pero se salían un poco, y también incluir algunos que parecía que estaban dentros pero como era el punto central
del pixel el del cálculo, no era tenido en cuenta.

## Referencias:

* [Rasterization stage](https://www.scratchapixel.com/lessons/3d-basic-rendering/rasterization-practical-implementation/rasterization-stage)
* [algoritmo de anti-aliasing](https://www.scratchapixel.com/lessons/3d-basic-rendering/rasterization-practical-implementation/rasterization-practical-implementation)
