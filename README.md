<!---
title: 'Kurso de genomika fungoj: Phylogenomika'
author: "Fernando Fernandez Mendoza"
date: "18/5/2019"
output:
  html_document: default
  csl: pnas.csl
  bibliography: bibliography.bib
  word_document: default
--->

# Kurso de genomika fungoj: Phylogenomika

*Fernando Fernandez Mendoza*

17-05-2019

---

## 1. Introducción

El término filogenómica fue acuñado de manera casi contemporánea para referirse a dos disciplinas científicas diferentes pero que comparten un trasfondo metodológico común: el uso de técnicas de reconstrucción filogenética para analizar datos genómicos. Eisen en el año 1998 fue el primero en utilizar el término para referirse al uso de modelos filogenéticos en la anotación funcional de secuencias proteicas. Por otro lado O'Brien (1999) introdujo el término para referirse al uso de datos genómicos en la reconstrucción de la historia evolutiva de un grupo taxonómico. Ambas disciplinas difieren en cuanto a métodos, objetivos e incluso en el nivel de organización biológica que estudian, pero juntas proporcionan la base conceptual para la genómica comparativa y evolutiva.

El propósito común a todos los estudios filogenéticos es la inferencia de las relaciones evolutivas entre especies. Hay muchos estudios cuyo único objetivo es la obtención de una hipótesis evolutiva, aunque a menudo también se usa la reconstrucción filogenética como base  para modelar procesos más complejos como patrones de diversificación, dinámicas poblacionales, evolución de caracteres, filogeografía, etc. Bajo una visión restringida, la filogenómica se podría entender cómo una extensión de la filogenética tradicional  para usar ya no muchos loci, sino todos los posibles. Sus premisas y objetivos serían comunes, y sus métodos se habrían reajustado para poder afrontar el nuevo tipo y volumen de datos. Sin embargo, los métodos modernos de secuenciación masiva no sólo proporcionan un enorme número de caracteres genéticos, sino que permiten realizar una descripción detallada de la estructura de los genomas, así como de la función de cada uno de los genes que los conforman. La filogenómica pues, permite estudiar tanto la evolución de las especies como la de sus genomas, y proporciona un marco histórico para la interpretación de los mecanismos ecológicos y moleculares asociados con el proceso evolutivo.

En definitiva, la filogenómica no es sólo calcular filogenias, sino que proporciona una puerta de acceso al estudio comparativo de los genomas y su evolución molecular. Aunque ello requiere una importante inversión mucho mayor en recursos económicos y humanos.

## 2. Objetivos del curso

El objetivo del curso es proporcionar una visión general sobre las necesidades metodológicas que tienen los estudios filogenómicos. El curso se compone de tres ejercicios prácticos e incluye varias pausas de lectura, que sirven para optimizar el uso de los tiempos de computación, que son relativamente elevados. Entender lo que estamos haciendo es sin duda tan importante como entender por qué lo estamos haciendo (-Paulo Coelho)

La primera actividad es la principal y tiene como objeto desarrollar un ejemplo de *pipeline* filogenómico basado en BUSCO (<https://busco.ezlab.org>), sencillo y poco automatizado. El objetivo es (1) familiarizarse con el uso del terminal de UNIX, (2) desarrollar todos los pasos necesarios para obtener un dataset filogenómico a partir de secuencias genómicas (de nucleótidos) y (3) desarrollar todos los pasos conducentes a la obtención de un árbol filogenómico.

La segunda actividad se centra en utilizar un pipeline filogenómico partiendo de secuencias de proteínas y en aprender a usar contenedores de docker.

La tercera actividad se centra en las posibilidades abiertas por el módulo de genómica comparativa del pipeline de anotación funcional funannotate (<https://funannotate.readthedocs.io/en/latest/>).

## 3. Partes de un pipeline: Propuestas metodológicas

Mientras que los protocolos utilizados en estudios filogenéticos están extremadamente estandarizados, en filogenómica no existe un enfoque único, una receta para todo que pueda considerarse como consenso. La filosofía y los métodos utilizados para cada estudio dependen en gran medida del tipo de datos adquiridos, su calidad y cobertura genómica y la extensión filogenética o el propósito del estudio.

En general un estudio filogenómico va a contener todos o la mayoría de los siguientes pasos:
1. Secuenciación
2. Ensamblado de los genomas (*de novo* o alineando a una referencia)
3. Predicción de genes (o loci)
4. Anotación (Comparación con bases de datos, anotación funcional)
5. Agrupamiento (*clustering*) de secuencias génicas
6. Selección de loci (cuando se hace *a priori*)
7. Alineamiento de secuencias (de nucleótidos o aminoácidos)
8. Refinamiento del Alineamiento
9. Reconstrucción filogenética (*Supermatrix* o loci individuales)
10. Selección de loci (*a posteriori*)
11. Filtrado de topologías
12. Construcción de un consenso (*Supertree*)

Aunque es cierto 


## 4. Cómo generar una matriz de datos filogenómicos?

El primer paso es la obtención de un set de datos que puedan ser analizados. La obtención de una matriz filogenética es sencilla, pues los loci a estudiar están preseleccionados y sólo hace falta secuenciarlos, alinear sus secuencias, y usarlas para estimar uno (o más) árboles filogenéticos usando un conjunto de loci neutrales. Sin embargo, generar matrices filogenómicas puede resultar extremadamente complejo, más cuanto más alejados estén los organismos estudiados entre sí.

Una de las primeras preguntas intuitivas que un científico proveniente de la sistemática filogenética se se plantea es "Ya tengo mis genomas. Y ahora cómo se alinean?". Y el siguiente paso intuitivo es abrir el navegador y buscar “phylogenomics” y “genome alignment”. Esto causa una confusión importante,pues pasa uno varios dias intentando sacar algo en claro de la multitud de pipelines desarrolladas para procariotas que hay online, y si tiene suerte encontrará un pipeline aparentemente funcional, desarrollado hace menos de diez años que misteriosamente h penas ha sido citado, o se encuentra inmerso en un universo críptico en el que las palabras ortólogo y philoma se suceden sin conseguir saber si es eso lo que queremos hacer o no. Ahora no es tan terrible, pero hace unos pocos años lo más habitual era encontrarse intentando sacar algún tipo de sentido a los métodos de alineación de genomas como MAUVE (Darling, Mau, and Perna 2010), antes de asumir que tener los *contigs* sistemáticamente ordenados  (Rissman et al. 2009) está muy bien, pero que no es para nada lo que queremos hacer.

Aun cuando los métodos han evolucionado mucho, y es relativamente fácil encontrar un pipeline que hace algo parecido a lo que queremos hacer, sigue resultando muy difícil tomar decisiones bien informadas de cómo diseñar un buen estudio filogenómico. Para empezar hay una importante brecha terminológica entre disciplinas, especialmente la sistemática filogenética y la genómica molecular, estando presente el término filogenómica más presente en la literatura refiriéndose a los métodos filogenéticos de anotación funcional. Para seguir, la multiplicidad de enfoques utilizados a la hora de  generar matrices de datos filogenómicas, y la vehemencia con que en muchos casos se defienden unas sobre otras en las publicaciones, pueden hacer dudar hasta al más rudo bioinformático.

Uno de los conceptos más importantes, cuyo uso puede crear bastante confusión es el concepto de ortólogo. Uno de los axiomas básicos de la reconstrucción filogenética, que emana de la cladística más tradicional es que para establecer relaciones de parentesco evolutivo sólo sirven caracteres (genéticos o no) homólogos, es decir caracteres cuya semejanza (funcional) se deba a que tienen un mismo origen evolutivo (es decir estaban presentes en un ancestro común). Mientras que los caracteres análogos, aquellos cuya semejanza se debe a una adquisición secundaria e independiente (las alas de aves y murciélagos son el ejemplo más obvio), no pueden ser usados para establecer relaciones de parentesco.

Esta idea de homología y analogía es obvia también a nivel genético. Aun cuando dos genes produzcan un enzima que degrade el mismo sustrato, si no derivan de una proteína presente en un ancestro común no pueden ser usados para establecer relaciones de parentesco. Bien. Dentro de los genes (caracteres) homólogos, encontramos dos tipos: Ortólogos y parálogos. Los genes ortólogos son aquellos cuyo origen es causado por el proceso de especiación, es decir aquellos que permiten trazar una línea de herencia unívoca desde un ancestro común. Los genes parálogos son aquellos cuyo origen no es estrictamente el proceso de especiación. Siendo homólogos, porque derivan de un ancestro común (en global) se han originado por duplicación de un gen existente o por captura horizontal. Mientras que la inclusión de parálogos en un árbol filogenético puede ser usado para reflejar la historia evolutiva de ese gen en concreto (útil en anotación funcional por ejemplo), cuando el objetivo es calcular una filogenia a nivel de especie introduce en el modelo una fuente de variación que no es causada por el proceso que queremos modelar (especiación) y por eso no deben ser utilizados. La identificación de genes ortólogos es un campo cetral en genómica comparativa, y quizás la referencia española más importante sea el grupo de Toni Gabaldón <https://www.crg.eu/en/programmes-groups/gabaldon-lab> cuyo proyecto phylome <http://phylomedb.org> es un recurso filogenómico internacionalmente muy relevante.

En ocasiones estos parálogos están presentes en un mismo genoma, facilitando su filtrado. Sin embargo lo más habitual es que los genes presentes en múltiples copias sean limpiados del genoma a lo largo del devenir evolutivo, a menudo después de haber sufrido un proceso de neofuncionalización o de silenciación que a menudo altera importantemente su secuencia de aminoácidos. En este caso, alineamientos de genes que parecen ser ortólogos pueden estar trufados de genes parálogos que son muy difíciles de detectar, de ahí que iniciativas con el *quest for orthologs* <https://questfororthologs.org> (Kuzniar et al. 2008) sean tan importantes.

Para complicar más esta cuestión de los ortólogos, el concepto de ortólogo está ampliamente integrado en el discurso de la genética molecular donde se utiliza a menudo referirse a grupos de proteínas cuya función ha sido asignada basándose en criterios de ortología, como por ejemplo en la identificación de grupos ortólogos como los ***C**lusters of **O**rtologous **G**roups* (<http://clovr.org/docs/clusters-of-orthologous-groups-cogs/>, o en en la base de  datos OrthoMCL <https://orthomcl.org/orthomcl/> de la que deriva el programa BUSCO.

Y para complicarlo todo aún mucho más, el concepto de ortólogo y parálogo es relativo, así que teniendo una duplicación mantenida en el tiempo, estos dos grupos de genes son parálogos entre ellos, pero los genes dentro de cada grupo son ortólogos. De este modo cuando uno usa un método para identificar genes ortólogos usando varios genomas se puede encontrar con reconstrucciones filogenéticas sorprendentes que espero que veamos en el transcurso de este curso.

Bueno, entonces ¿Cómo obtenemos una matriz de caracteres genéticos ortólogos a partir de nuestros datos genómicos? Pues hay varias opciones cada una con ventajas y desventajas dependiendo de la proximidad filogenética de los organismos estudiados.

### 4.1. Métodos basados en resecuenciación genómica (poblaciones o especies muy cercanas, subgéneros)

Cuando el objeto de estudio son organismos filogenéticamente muy cercanos, se puede considerar que los genomas guardan una gran similitud estructural y por lo tanto una casi total ortología posicional (si esa es otra manera de verlo: Dewey 2011). En este caso bastaría alinear los reads directamente a un genoma de referencia usando herramientas como BWA (Li and Durbin 2009) o Bowtie2 (Langmead and Salzberg 2012), filtrar las regiones con una heterocigosidad fuera de la distribución esperada para evitar parálogos e inferir SNVs usando programas como Freebayes (Garrison & Marth 2012), Stacks (Catchen 2013) o Pyrad (Eaton 2014) dependiendo del tipo de librerías que hayamos secuenciado, o incluso métodos generales de *variant calling* como los implementados en GATK (McKenna et al. 2010) –CombineGVCFs, GenotypeGVCFs– o samtools (Li et al. 2009). Este tipo de implementaciones también se usan para analizar datos obtenidos mediante RNASeq (De Wit et al. 2012) y poolseq (Schlötterer et al. 2014). Un ejemplo de *pipeline* que usa este tipo de aproximación es RealPhy <https://realphy.unibas.ch/realphy/> que se ha usado por ejemplo para estudiar el hongo liquenizado *Rhizoplaca melanophthalma* (Leavitt et al. 2016). Este tipo de metodologías no las vamos a usar en este curso. Cabe mencionar que están bastante limitadas a la hora de incorporar outgroups que sean suficientemente distantes.

### 4.2. Métodos basados en la comparación con bases de datos

La mayoría de estudios filogenómicos no suelen estar basados en la resecuenciación de genomas de especies muy cercanas entre sí, sino que más bien intentan comparar genomas completamente ensamblados, bien completamente terminados o bien *drafts* genómicos parcialmente incompletos. Para compararlos, lo habitual es que no podamos asumir una homología –o mejor ortología– posicional, aunque es cierto que en el caso de los genomas de hongos se suelen encontrar  bloques sinténicos conservados entre genomas relativamente distantes.

En este caso se suelen procesar los genomas para predecir genes, o más bien sus exones, que se usarán como punto de partida. Identificar qué gen es cada uno es una tarea difícil para un sólo genoma, de modo que si hablamos de decenas o cientos de genomas esta tarea se puede tornar hercúlea muy rápidamente. Por eso en general lo que se hace es identificar genes cuya secuencia –normalmente de aminoácidos– es suficientemente semejante como para ser considerados si no ya ortólogos, al menos homólogos. Esto se hace usando bases de datos de referencia sobre las que alinear nuestros genomas –ya traducidos a secuencias proteicas– usando algoritmos como Blast <https://blast.ncbi.nlm.nih.gov/Blast.cgi>, en concreto blastp. Este procedimiento es habitual en la mayoría de trabajos de genética molecular, donde *blastear* secuencias a mano con ncbi para saber si hemos secuenciado lo que debíamos es parte del día a día, y usar blast de manera masiva es la base para interpretar trabajos ecológicos basados en metabarcoding (Secuenciación masiva de amplicones). Aunque hay muchas reprogramaciones del algoritmo de Blast, que está bastante mayor, hoy por hoy la mas rapida y efectiva es la implementada en el programa *diamond* <https://github.com/bbuchfink/diamond>, creado por el grupo de Bioinformatica de Tübingen con Daniel Huson –que es un mostruo que no se puede aguantar– a la cabeza.

Con esta filosofía de base se pueden clasificar la mayoría de pipelines filogenómicas según que tipo de base de datos de referencia usan:

#### 4.2.1. Usando un genoma externo como referencia (Outgroup)

El método más sencillo es convertir un genoma conocido en una colección de secuencias proteicas a usar como referencia. Para identificar el gen ortólogo que queremos solo debemos alinear los genes del genoma que queremos procesar con la base de datos y seleccionar para la reconstrucción filogenética el mejor *hit* unidireccional para cada locus –Es decir el gen que mejor se alinea con la referencia, el resultado positivo del alineamiento local *blast* que tenga un valor de e –*e-value– menor–. Este paso es obvio y en realidad es una parte fundamental de la mayoría de *pipelines* que automatizan la anotación de genomas, donde se usa como evidencia externa. Esté método para identificar ortólogos, puede funcionar a nivel de género o incluso de familia. Tiene grandes inconvenientes, no es particularmente sólido y no permite identificar genes ortólogos de un modo objetivo, y a medida que se incluyen genomas los riesgos de incluir parálogos en el análisis se tornan mayores. Es una opción, pero es un método poco maduro, y no se me ocurre ningún caso en el que sea razonable su uso. Un ejemplo varios algo más refinado de este grupo de métodos es el pipeline RealPhy <https://realphy.unibas.ch/realphy/>

#### 4.2.2. Usando todos los genomas como referencia (Best reciprocal blast hit)

Un segundo método, que es un refinamiento del anterior sería utilizar para la selección de loci, no ya el mejor *hit* unidireccional con el genoma de referencia sino usar como criterio el mejor *hit* recíproco (*best reciprocal blast hit*). Es decir, crearíamos una base de datos del genoma A (*reference*) sobre la que buscaríamos las proteínas de B (*query*) alineándolas. Seguidamente crearíamos una base de datos con el genoma B sobre el que buscaríamos el mejor *hit* de A. Estos resultados se tabulan para cada genoma y se seleccionan sólo los genes cuya comparación es recíproca e unívoca. Este método es mejor que el blas unidireccional, y es en realidad el punto de partida para la identificación de ortólogos.

El segundo paso conceptual es sencillo. En lugar de usar solo comparaciones entre los genomas que quiero analizar y el genoma de referencia, se usan comparaciones de todos los genomas contra todos. Son más complejas de tabular pero sí permiten identificar parálogos y ortólogos con un contexto mucho más amplio. Este método es sin duda el más completo a cualquier escala filogenética. Si se usan secuencias de nucleótidos, el uso está restringido hasta nivel de familia –asi a ojimetro–, sin embargo usando secuencias de aminoácidos podemos llegar hasta nivel de Clase. A nivel de División, empieza a ser problemático..

A partir de aquí los métodos difieren en cuanto a los algoritmos que usan para tabular los resultados e inferir ortólogos. En general se utiliza un algoritmo de clustering para organizar los genes de todos los genomas en grupos de ortólogos (*Clustering of orthologous groups, sensu stricto*). Acto seguido se suelen realizar reconstrucciones filogenéticas de cada cluster para refinar la identificación de  parálogos. Para entendernos, se puede decir que hacen una identificación de ortólogos *a posteriori*. Este tipo de método la vamos a utilizar en el ejercicio práctico número dos. Funcionan Bien a todas las escalas filogenéticas. Tiende a fallar cuando los genomas no son perfectos y contienen secuencias contaminantes, o cuando tenemos un cierto grado de poliploidia en el genoma, porque por ejemplo partimos de apotecios y el ensamblaje genómico está fragmentado.

#### 4.2.4. Usando comparación con bases de datos externas (Busco)

Una tercera opción sería usar una base de datos como referencia, genbank, swissprot, etc... Esto es rutinario en anotación funcional y podría ser reutilizado en un contexto filogenómico. A priori no es útil, y aun en casos donde no haya referencias posibles, usar el método anterior sería más razonable. Sin embargo, las bases de datos dedicadas a la identificación de ortólogos que hemos comentado en el epígrafe anterior si proveen una información global contextualizable que puede ser utilizada para identificar ortólogos *a priori*. Si en lugar de comparar los genomas objeto de estudio entre sí los comparo a una base de ortólogos conocidos, en principio tengo el trabajo hecho.

Sin embargo las bases de datos de clusters ortólogos, son demasiado complejas y difíciles de interpretar. Lo normal es que los genes de nuestros genomas se disgregen entre grupos de ortólogos de organismos poco relacionados entre sí. En especial, si el genoma no está perfectamente limpio, la labor de eliminar ortólogos contaminantes puede ser terrible.

Entonces se redescubre CEGMA <http://korflab.ucdavis.edu/datasets/cegma/>. CEGMA (*Core Eukaryotic gene mapping approach*) era un dataset que contenía genes eucarióticos básicos para la función celular que aparecen en todos los genomas, que son ortólogos y que suelen ser de copia única. Su autor se adelantó demasiado a su tiempo y su enfoque no suscitó interés hasta diez años más tarde.En el epitafio de cegma <http://www.acgt.me/blog/2015/5/18/goodbye-cegma-hello-busco>, el autor nos refiere a un software alternativo y mejorado llamado BUSCO (Benchmarking Universal Single-Copy Orthologs, <https://busco.ezlab.org>).

BUSCO sirve para identificar una serie de genes ortólogos en genomas que aún no han sido anotados (sus genes no han sido identificados), y para ello utiliza unos pocos genes ortólogos identificados y sistematizados para grupos de organismos específicos, entre ellos distintas categorías taxonómicas de hongos –cortesia de Jason Stajich <http://lab.stajich.org/home/people/jason-stajich/>, otro crack–. Esto es de gran ayuda para anotar genomas de especies alejadas de los modelos más habituales, así como para analizar la cobertura genómica de *drafts* genómicos. Pero sobre todo, permite identificar miles de genes, que son ortologos, que suelen ser de copia única, y que pertenecen a una categoría taxonómica concreta, bacterias, algas, el jamón del bocadillo... que pueden estar entremezclados en un mal genoma no alinean lo suficientemente bien y son descartados. En sí mismo CEGMA primero y BUSCO despues inauguran la posibilidad de definir ortólogos *a priori*.

Busco no es todo ventajas, tiene limitaciones importantes, a muchos niveles. La capacidad de identificar ortólogos en un genoma es proporcional al grado de similitud con la base de datos utilizada (y hay grupos de hongos extremadamente divergentes), habitualmente hay BUSCOs duplicados y a medida que ampliamos la cobertura filogenética el numero de ortólogos comunes a todos los genomas empieza a decrecer de manera alarmante. En un dataset incluyendo los más o menos 1700 genomas de hongos que hay en genbank, no hay ni un solo ortólogo presente en todas las muestras, y solo 300 de los mil y pico genes incluidos en el dataset de hongos están presentes en mas de la mitad de los genomas. Busco funciona bien a nivel de género hasta Clase. A nivel de División los alineamientos comienzan a ser muy pobres y podemos encontrarnos con muy pocos loci utilizables y una proporción de loci incompletos demasiado alta.

El cuerpo principal de este curso es implementar un *pipeline* basado en BUSCO.

### 4.3. ¡Esto no funciona! ¿qué hacemos? (División, Reino, *Tree of life*)

A partir de la categoría de División, generar una reconstrucción filogenómica como tenemos en mente no es factible. Los métodos basados en alinear secuencias de aminoácidos o nucleótidos no son utilizables, pues habitualmente el ruido supera de largo cualquier tipo de información contenida en las matrices de datos. En este caso se prefiere utilizar métodos *alignment free* como alternativa.Básicamente se trata de obtener una medida de similitud entre genomas y hacer árboles de distancias, anotando el soporte estadístico de la topología usando bootstrapping ya nos daría un método espectacular.

*Distancia basada en estructura del proteoma*
En bacteriología es bastante habitual encontrar árboles filogenéticos basados en distancias genómicas. Las bacterias tienen genomas muy pequeños que se deshacen rápido de aquellas enzimas implicadas en vías metabólicas que no les interesan, y tienden a obtener genes por transferencia horizontal. El contenido genómico tiene una importancia funcional, pero también filogenética. Así, tabulando los genes presentes en cada genoma (presencia/ausencia o 0,1,+1 copia) se puede hacer una reconstrucción filogenómica de las Eubacterias bastante sólida. Esta metodología no es habitual –ni recomendable– en hongos pero la vamos a probar en el último ejercicio práctico.

*Distancia basada en oligómeros*
Un grupo de métodos emergentes se basan en la descomposición del genoma en pequeños fragmentos de tamaño fijo. En general yo los llamo k-meros que es el término que se usa para secuencias de nucleótidos. Para secuencias de aminoácidos se suele hablar de *features* pero yo quiero enfatizar que es la misma idea. Simplificando, lo que se hace es partir de un proteoma, segmentarlo en todos los grupos de k aminoácidos consecutivos posibles, con solapamiento, claro está. A partir de esta descomposición se mide la frecuencia con que aparece cada K-mero en el proteoma. A partir de aquí hay dios posibilidades. Si usamos un valor de k pequeno (k=5) el número de secuencias posibles relativamente pequeño. De este modo podemos obtener una matriz de frecuencias bastante compacta que usar para calcular una matriz de distancias. Es una primera opcion metodologica. Si usamos un valor de k mas alto (k=20) el número de secuencias 20-mericas posibles es inmensa, pero podemos eliminar aquellos que estén poco representados en cada genoma y elaborar una base de datos más compacta, para cada genoma. Cruzar las bases de datos de composición de 20-meros nos da una idea importante de la similitud composicional del proteoma en global y nos permite generar una matriz de datos filogenómicos. Este tipo de métodos se ha usado en hongos recientemente (Choi & Kim 2017) <https://www.pnas.org/content/114/35/9391> utilizando un método llamado FFP <https://github.com/jaejinchoi/FFP>. En esta misma línea cabe también mencionar el software ProtSpaM <https://github.com/jschellh/ProtSpaM>.

Como he dicho este tipo de medidas también se puede usar con secuencias de nucleótidos, y tienen muchas aplicaciones potenciales que se salen, en parte al menos del propósito de este curso. Os añado este review por puro vicio <https://academic.oup.com/gigascience/article/7/12/giy125/5140149>, esto será sin duda el futuro del DNA-barcoding.

## 5. Reconstrucción filogenética con miles de loci

Como punto de partida hay que recordar una serie de conceptos relevantes para entender qué son y cómo funcionan los métodos de reconstrucción filogenética. Más o menos refinados, adornados con terminologías más o menos complejas (superpublicables y megaflipantes), todos los métodos de reconstrucción filogenética se pueden encuadrar entre los métodos matemáticos de clustering jerárquico. En último término tienen como objetivo organizar nuestros datos en un grafo dicótomo (árbol) que nosotros interpretamos como hipótesis de relación evolutiva entre las especies/alelos/genes que introducimos en la matriz de datos.

El punto de partida para todos los métodos es obtener una medida de distancia entre cada observación para poder elaborar el grafo. Esta distancia en el caso de caracteres genéticos se obtiene a partir de una matriz en las que las secuencias de nucleótidos o aminoácidos están alineadas, maximizando la identificación de homologías en las secuencias. Esto se hace habitualmete mediante el alineamiento múltiple de secuencias, y su descripción detallada requeriría un libro propio. Si tenéis dudas hay multitud de recursos disponibles para profundizar en los algoritmos para realizar este tipo de *multiple sequence alignment* tanto en internet como en la literatura.

Los métodos más sencillos de inferencia filogenética realizan la inferencia de la topología en dos pasos. Primero calculan la distancia en base a un modelo estadístico de sustitución –otro tema que requiere un libro propio–, y basado en esa matriz de distancias utilizan distintos algoritmos para calcular una topología (Neighbour joining, UPGMA, etc...). Estos algoritmos obtienen el árbol más probable basado en los datos fijando un modelo de sustitución. Un caso especial son los métodos basados en parsimonia, que interpretan las sustituciones desde un perspectiva eventual, máxima parsimonia genera una estructura estadística (grafo) que minimiza el número de diferencias entre secuencias, pero no usa modelos estadísticos de sustitución.

El siguiente nivel de complejidad en los algoritmos de inferencia filogenética hace uso del concepto de Verosimilitud o *Likelihood* desarollado por Felsenstein en los años 80 y 90 del siglo pasado y evalúa la probabilidad de obtener los datos a la luz de una topología y un modelo de sustitución impuesto. Primero usa una matriz de distancias para optimizar la parametrización del modelo y obtener una topología de partida, y la optimiza de modo iterativo hasta obtener el árbol más verosímil, que maximiza la probabilidad de los datos dado un modelo y una topología. Este tipo de aproximación se denomina *Maximum likelihood*.

Dado que estamos optimizando la probabilidad de los datos, evaluar la solidez de la topología requiere modificar los datos de partida. Para obtener el soporte estadístico de cada topología se recurre al bootstrapping. Se generan  matrices de datos randomizadas en las que las posiciones genéticas se introducen con repetición en un alineamiento igual de largo que el original y se optimiza la probabilidad de cada dataset simulado. Al final se recurre a un método de consenso para evaluar en cuántos de los árboles simulados se encuentra cada partición y esto genera unos valores de soporte estadístico.

El último nivel de complejidad pasa por utilizar métodos de optimización bayesiana, en concreto cadenas de Markov (*Metropolis coupled markov chain montecarlo* para ser más pedante). En estos se lleva a cabo un proceso parecido al de ML, pero topología y parametrización del modelo se optimizan conjuntamente. La optimización Bayesiana tiene grandes ventajas sobre los métodos de ML. Primero no es tan dependiente del punto de partida (el árbol UPGMA por ejemplo), segundo al asumir en la cadena cambios a peor y no solo a seleccionar la mayor verosimilitud, es capaz de evitar óptimos locales mejor y es capaz de explorar el espacio paramétrico de manera más exhaustiva. Además la evaluación del soporte estadístico parte de árboles basados en obtener una distribución de árboles en principio equiprobables basados en los datos reales y no en un constructo artificial con pseudodatos como se hace con el bootstrapping.

4. Reloj Molecular

5. Árboles multigénicos y árboles de especies
Supermatrix
Consensos y supertrees
Métodos  de reconciliación (multispecies coalescent)
Métodos de reconciliación (summary)
Redes

6. Cálculo del soporte topológico

7. Limitaciones computacionales 

De hecho, debido a las limitaciones humanas y computacionales, el análisis de un gran número de loci requiere una serie de simplificaciones y compromisos que dependen en gran medida del tipo de plataforma de secuenciación, de la cobertura genómica y del propósito de la encuesta. Por ejemplo, no se dispone de métodos bayesianos altamente refinados para la prueba de modelos, la coestimación de la filogenia y los parámetros poblacionales, o incluso para hacer inferencias filogenéticas sencillas para todos los tipos de datos y, a menudo, no se adaptan bien a los conjuntos de datos genómicos que limitan su uso.

Additional task: Try to program two similar steps but using IQtree (Minh, Anh Thi Nguyen, and von Haeseler 2013) instead of RaxML, it can be slightly faster (Zhou et al. 2017) and it incorporates automated model-testing, which is a very interesting addition.
Additional task: Now try to wrap up all the latter steps into a single sequential script, pack it into a .sh file and try runnin it as a pipeline.

4.2.4 Single gene trees and consensus
It has become obvious that having a multiplicity of genes does not only provide information as a consensus for the whole genome. Different regions of the genome may have different histories and a consensus may not conform to a simplified ditichotomous structure as provided by a phylogenetic tree. A great tool to explore the phylogenetic signal contained at a whole genome level is the software dendroscope CITE, which provides a wide ranges of methods to estimate rooted networks for the further exploration of the phylogenetic signal encountered across loci.
Additional Task_3: Contains an additional set of 964 gene trees calculated from the same Caloplaca dataset. a) Use RaxMl to summarize them, b) Download and install Dendroscope and try to obtain further consensus representations.
No hay una sola aproximación a realizar un estudio filogenómico. Es altamente dependiente del tipod de datos que tengamos

## 6. Tutorial I. Pipeline filogenómico basado en BUSCO y un poquito a pedal.

En este tutorial implementaremos un *pipeline* filogenómico basado en la aplicación BUSCO v 3.0 (Simão et al. 2015)  <https://busco.ezlab.org> para automatizar la identificación de génes ortólogos. El *pipeline* en sí es algo naïve y bastante manual. Aunque su automatización sería fácil de implementar, está pensado para entender la sucesión de métodos paso a paso, de manera que pueda servir como base para modificar otros *pipelines* e implementar un métodos más personalizados.

Todos los archivos necesarios se encuentran en mi repositorio de Github. Por eso lo primero que debemos hacer es elegir una carpeta donde trabajar y clonar el repositorio:

```{bash}
git clone https://github.com/ferninfm/Fungal_phylogenomics
```

Como hemos comentado con anterioridad, BUSCO es un programa desarrollado con dos objetivos principales, posibilitar la anotación *de novo* de genomas de organismos no modelo previamente y para evaluar la calidad de un genoma ensamblado usando su cobertura genómica, es decir que porcentaje de los genes esperados son identificables. Para ello, BUSCO utiliza un set de genes ortologos de copia única que son los que busca en el genóma a analizar. Estos genes ortólogos se encuentran definidos como perfiles HMM, obtenidos a través del uso de Modelos ocultos de Markov (HMM, Eddy 1998) para distintos niveles taxonomicos. Debido a su versatilidad BUSCO fue rápidamente reutilizado para fines más allá de su proposito inicial. En nuestro caso, BUSco automatiza varios de los pasos necesarios para obtener un dataset filogenómico desde cero: primero utiliza *augustus* (Stanke et al. 2006) como algoritmo de predicción de genes, que al fin y al cabo es la base de métodos de predicción de genes más complejos, y segundo *HMMER* (Mistry et al. 2013) para comparar los genes estimados con la base de datos de ortologos de copia única.

Sus virtudes son al mismo tiempo sus mayores desventajas. Cuando se usan secuencias de nucleótidos el sesgo es menor, pero para utilizar pipeline mas maduro se deberia partir de genes estimados usando un procesos iterativo mas complejo (maker3 o funannotate). Por otro lado se podría  optimizar la captura de genes ortologos desarrollando bases de datos mas especificas para el grupo taxonómico que estamos estudiando. Un setup similar se puede encontrar el el estudio filogenomico de Saccharomycotina publicado por Shen et al. (2016) o el de Parmeliaceos de Pizarro et al. (2018).

**Atención propuesta!** Para aquellos que esteis motivados, en el repositorio he dejado un ejemplo de HMM asi como un par de publicaciones explicativas de lo que son Hidden Markov Models (HMMs, Eddy 1998). El archivo de cada HMM proporciona información estadistica sobre la secuencia de aminoacidos de cada grupo ortologo. Están alineados y proporcionan un consenso estadistico flexible que permite capturar mayor variabilidad y más rapido que una busqueda directa como BLAST. Veis las ventajas? Es una herramienta magnifica que tiene aplicación en gran cantidad de campos de la ciencia.

4.2.2 Parsing the BUSCO output for phylogenomics
Task_2: We developed a very simple R script to mine the output of BUSCO in order to produce a phylogenomic data matrix. In a well atomated pipeline it may be more reasonable to work with the fasta files per busco and genome provided by the program. We do however use the full_table_* file for several reasons. First in a preliminary survey, working with the full_table file allows us to a) b) thus to manually exclude one of the duplicated BUSCOS that may be causing problems for preliminary exploration. Also, we are not departing from well-tested nor evidence-based protein predictions, so using scaffold coordinates allows us to c) include intronic regions, and d) modulate possible missinterpreted regions in the alignment step. Finally, it also serves to provide a simple example on how to work with tables and sequences in R.

6.	Then we will trim the alignment using the software trimAl (Capella-Gutiérrez, Silla-Martínez, and Gabaldón 2009). You can find suggestions and a tutorial in http://trimal.cgenomics.org. First explore the alignment report for your files using the –sgt and –sident flags. An example to create a report file could be 


cat RAxML_bipartitionsBranchLabels.* > all_trees.tre
raxmlHPC -L MR -z all_trees.tre -m GTRCAT -n -T1

![Esquema del pipeline basado en BUSCO](https://github.com/ferninfm/Fungal_phylogenomics/blob/master/pipeline_1.png) 

### 6.1. Pasos preliminares
Para reducir el tiempo de compuatción y hacer el curso un poco más dinámico he dicidido realizar varios pasos preliminares de antemano.
#### 6.1.1 Ensamblar los genomas
Para este ejercicio contamos con nueve genomas pertenecientes al género *Caloplaca* (Teloschistaceae) obtenidas en el marco del proyecto Hiperdiversidad en symbiosis fungicas poliextremotolerantes (FWF P26359, <a>http://ferninfm.github.io/Hyperdiversity_project_webpage</a>. Aunque bastante completos son versiones interminadas cuya version final está en proceso de publicación. Por cautela no os he dado las referencias concretas ni el nombre. Los accession numbers serán añadidos en el futuro. Además de esos nueve genómas también he incluido como referencia la version 1.1 del genóma de *Xanthoria Parietina* que se puede encontar aquí  (<a>https://genome.jgi.doe.gov/Xanpa2/Xanpa2.home.html</a>)

Los librerias genímicas originales fueron preparadas usando TrueSeq de Illumina, en su mayoria sin PCR. Las liberiras fueron secuenciados usando dos lineas de un Illumina HiSeq, usando lecturas pareadas (paired reads) de 200 pares de bases. El tamaño del insert medio es de 350 pares de bases. LOs genomas fueron ensamblados usando Spades (CITE).

Los genomas de partida están ya ensamblados. El genoma X1 proviene de un cultivo axénico mientras que los demás provienen de metagenomas y han sido limpiados usando BUSCO, un script propio semejante a blobology (Shen et al. 2016) usando augustus, diamond (Buchfink, Xie, and Huson 2015) y MEGAN (Huson, Mitra, and Ruscheweyh 2011). Los archivos están comprimidos entro de la carpeta 01_data, aunque como he dicho no vamos a usarlos directamente. El primer paso implicaría descomprimirlos para poder ser analizados. Antes de nada ve al directorio raíz en donde hayas instalado este documento, para eso has de hacer uso del comando cd que has aprendido al inicio de este curso. Seguidamente debemos descomprimir los genomas.
```{}
# Cambiar al directorio de datos

cd 01_data

# Descomprimir los datos

tar -xvzf ./genomes.tar.gz

# Despues de observar si los archivos estan correctos usando
# los comandos head, tail o more. Después volver al directorio raíz

cd ..
```
#### 6.1.2. Ejecutar BUSCO
Antes de ejecutar BUSCO hay que elegir un método para hacerlo. Podemos haber instalado BUSCO de modo nativo en nuestro ordenador. Este método es el más habitual y requiere de haber instalado los programas de los que BUSCO depende para su funcionamiento. Mantener la estabilidad de las dependencias constituye un problema en muchos programas bioinformaticos, y no es extraño que programas dejen de funcionar tras actualizar el sistema o tras instalar una consola (shell) diferente. Para evitar estos problemas hay cada vez una mayor tendencia a usar los programas bioinformaticos empaquetados en máquinas virtuales. De ellas, las máquinas virtuales propiamente dichas son las menos versátiles, pero las que más se adecuan al uso de ciertos programas que usan bases de datos externas. BUSCO proporciona una máquina virtual propia basada en ubuntu que se puede utilizar. Otra opción es incluir los programas necesarios en un contenedor de docker. Esta solucion es en muchos casos la mejor, aunque no siempre los contenedores están listos para su uso y requieren invertir una importante cantidad de tiempo...

Una vez descomprimidos los genomas son analizados usando el siguiente script

```{bash}
for FILE in X1 X2 X3 X4 X5 X6 X7 X8 X9 Xanpa
  do
    python /usr/local/src/busco/scripts/run_BUSCO.py \
    -f \
    -i ./${FILE}_masked.fasta \
    -o $FILE \
    -l ./ascomycota_odb9 \
    -m genome \
    -c 12 \
    -sp aspergillus_fumigatus
    gzip ./${FILE}_masked.fasta
  done
```
**Atención *mea culpa***: En realida lo suyo sería haber usado la base de datos disponible para pezizomycotina, que contiene casi el triple de BUSCOs. Sin embargo esta nos daria un volumen de resultados excesivo para este tutorial.
Las carpetas con los resultados del análisis de los BUSCOs han sido comprimidos en archivos gzip. Para poder usarlos debemos descomprimir los directorios de datos.
```{bash}
cd ../02_busco
gunzip *.gz
```
### 6.2. Evaluar busco
Lo primero que debemos hacer es evaluar el resultado de las busquedas de BUSCOs para poder inferir que  genomas incluir o no en el análisis. Para ello usamos el programa multiqc <https://multiqc.info>.
```{bash}
multiqc ./run*
```
**Atención pregunta:**: Hay alguna muestra más incompleta? A priori parece que alguna de ellas sea de peor calidad o más problemáticas? Por qué

### 6.3. Extraer los buscos

***EMPEZAMOS AQUI***

El paso siguiente es extraer las secuencias de los BUSCOs encontrados en los genómas y agregarlos en un archivo fasta por cada BUSCO sobre el que proseguir con el pipeline filogenético.
Hay multitud de ejemplos online para hace esto. Los scripts más antiguos procesan la tabla de resultados de cada run de BUSCO. Tienen ventajas y desventajas.Un ejemplo es el script *extract_buscos_pylo.py* distribuido en <a>https://gitlab.com/ezlab/busco_usecases/blob/master/phylogenomics/readme.md</a.

En nuestro caso, no nos interesa tener loci en los que el outgroup no este presente así que usamos el siguiente script. Es poco elegante, pero sirve para ilustrar que en ocasiones las soluciones simples están al alcance de la mano:

```{bash}
# Creo directorio
mkdir ./03_fastas
#
# Copio los archivos del outgroup
#
cp ./02_Busco/run_Xanpa2_AssemblyScaffolds/single_copy_busco_sequences/* ./03_fastas
#
# Concateno las secuencias de las otras especies
#
for SPECIES in {1..9}
   do 
       echo "species X$SPECIES"
	   for BUSCO in $(ls ./03_fastas)
          do
		  cat ./02_Busco/run_X${SPECIES}scaffoldsfiltered/single_copy_busco_sequences/$BUSCO >> ./03_fastas/$BUSCO
		  done
   done
```
Asi obtenemos un archivo fasta por BUSCO con las secuencias de los distintos genomas sin alinear. Podríamos proseguir asi, pero los nombres de las secuencias son extremadamente largos y lo que espeor diferentes para cada locus, lo que generaría problemas a la hora de procesar los alignments y los genes. Para renombrar los genes y obtener una idea de cuan completos estan los alineamientos de cada locus (BUSCO) he hescrito el siguiente script. Se puede personalizar para usar nombres personalizados más complejos que los basados en los nombres preexistentes que he utilizado. Con este scripot quiero ilustrar como un lenguaje de programación como R puede ser utilizado como un programa independiente pasandole argumentos desde el terminal.
```{r}
#!/usr/bin/Rscript
#---------------------------------------------------#
#  NAIVE PARSING OF BUSCO OUTPUT FOR PHYLOGENOMICS  #
#  FFM 2019                                         #
#  fernandf@uni-graz.at                             #
#---------------------------------------------------#
Sys.setenv(LANG="en_US.UTF-8")
#
# Get arguments
#
args <- commandArgs(trailingOnly = TRUE)
#
# Conditional info
#
if(length(args)<2)
    {
    cat("NAIVE PARSING OF BUSCO OUTPUT FOR PHYLOGENOMICS\n\n---------------------------------------\n\nI
    Insufficient arguments were supplied in the command line.
    \n\n----------------------------\n\n
    You must provide a path to the folder where single gene fasta files are placed\n
    the number of individuals required for the downstream use of BUSCO
    Example of use: Rscript rename_busco.r /home/fernando/genomics_course/new/new/03_fastas 10\n\n")
    }else{
  #
  # Check and install ape
  #
  if (!require("ape",character.only = TRUE))
      {
        install.packages("ape",dep=TRUE)
        if(!require("ape",character.only = TRUE)) stop("Ape Package not found")
      }
  if (!require("seqinr",character.only = TRUE))
      {
      install.packages("seqinr",dep=TRUE)
      if(!require("seqinr",character.only = TRUE)) stop("Sequinr Package not found")
      }
  if (!require("reshape2",character.only = TRUE))
      {
      install.packages("reshape2",dep=TRUE)
      if(!require("reshape2",character.only = TRUE)) stop("reshape2 Package not found")
      }
  require (ape)
  require (seqinr)
  require (reshape2)
  #
  #Start processing
  #
  setwd(args[1])
  foo<-list.files(args[1])
  all_fastas_nuc<-list()
  all_fastas_aa<-list()
  #
  # work with dna.fasta
  #
  i=1
  for (FILE in foo[sapply(strsplit(foo,"\\."),`[`,2)=="fna"])
    {
    foo_seq<-read.dna(FILE,format="fasta",as.matrix=FALSE)
    names(foo_seq)<-substr(sapply(strsplit(names(foo_seq),":"),`[`,2),3,8)
    if (length(foo_seq)>=as.numeric(args[2]))
      {
      write.dna(foo_seq,paste("renamed_",FILE,sep=""),format="fasta",nbcol=-1,colsep="")
      }
    all_fastas_nuc[[i]]<-names(foo_seq)
    names(all_fastas_nuc)[i]<-FILE
    i=i+1
  }
  #
  # work with aa fasta
  #
  for (FILE in foo[sapply(strsplit(foo,"\\."),`[`,2)=="faa"])
  {
    foo_seq<-read.fasta(FILE,seqtype="AA")
    names(foo_seq)<-substr(sapply(strsplit(names(foo_seq),":"),`[`,2),3,8)
     if (length(foo_seq)>=as.numeric(args[2]))
      {
      write.fasta(foo_seq,paste("renamed_",FILE,sep=""),names=names(foo_seq))
      }
  }
  all_fastas_nuc<-t(table(melt(all_fastas_nuc)))
  all_fastas_nuc<-cbind(all_fastas_nuc,completeness=rowSums(all_fastas_nuc))
  foo<-all_fastas_nuc[all_fastas_nuc[,"completeness"]>=args[2],]
  all_fastas_nuc<-rbind(all_fastas_nuc,representation=colSums(all_fastas_nuc))
  foo<-rbind(foo,representation=colSums(foo))
  writeLines("#\n#######################################\n# Complete dataset\n","report_completeness.txt")
  write.table(all_fastas_nuc,"report_completeness.txt",sep="\t",quote=FALSE,append=TRUE)
  writeLines("#\n#######################################\n# Reduced dataset\n","report_completeness.txt",append=TRUE)
  write.table(all_fastas_nuc,"report_completeness.txt",sep="\t",quote=FALSE,append=TRUE)
  pdf("completeness_histogram.pdf")
  hist(all_fastas_nuc[,"completeness"],col="blue")
  abline(v=args[2],col="red")
  dev.off()
}
```
Este script requiere introducir un path absoluto y no relativo (./03_fastas), en realidad es algo que debo solucionar. Para abreviar el análisis vamos a seleccionar sólo aquellos loci presentes en todas las muestras. En este ejemplo lo podemos permitir
```{bash}
Rscript rename_busco.r /home/fernando/genomics_course/new/new/03_fastas 10
```
Este script crea una serie de archivos en formato fasta llamados *renamed_*. Siguiendo el standard de busco *.faa* se refiere a sequencias de aminoacidos y *.fna* de nucleótidos. Sólo los BUSCOS presentes en los 10 genomas van a ser incluidos aunque la decisión depende mucho de cada caso individual. Nosotros seguiremos a partir de aquí usando exclusivamente las secuencias de nucleótidos, pues nuestros organismos estan filogenéticamente muy cerca. A nivel supra-familiar es más recomendable usar secuencias de aminoácidos, aunque quizás lo mejor (aunque dificl de automatizar) sería evaluar la alineabilidad de cada locus y usar el nivel más adecuado. De todos modos, Busco utiliza un método poco refinado (relativamente hablando) para anotar el genoma (identificar exones y proponer secuncias de proteinas). A un nivel superior sería mejor partir de anotaciones más completas y complejas para cada genoma como las proporcionadas por maker o funannotate.

### 6.4. Alinear los archivos fasta con MAFTT

Opcional refinar el alignment con Muscle 
Yo lo suelo hacer así pero creo que es innecesario.
Hay otras alternativas más complejas, algunas de las cuales refinan el alignment haciendo arboles y corrigiendo
```{bash}
mkdir ./04_alignments
```
Save the following script as run_mafft.sh. For this one can use nano and paste the text inside
```{bash}
nano run_mafft.sh
```
Paste the script below within the file run_mafft
```{bash}
#!/bin/bash
# 
cd ./03_fastas
files=$(ls renamed_*.*)
cd ..
for FILE in $files
do
	echo $FILE
	mafft --auto ./03_fastas/$FILE > ./04_alignments/aligned_${FILE}
done
```
run the script

```{bash}
sh run_mafft.sh
```

### 6.5. Refinar el alignment con trimal
Trimal es un programa desarrollado por el grupo de Toni Gabaldón. Esta descritpo en Capella-Gutierrez S, Silla-Martinez JM, Gabaldon T. *Bioinformatics*. 2009 25: 1972-1973. Para instalarlo lo mejor es clonar el repositorio <a>https://github.com/scapella/trimal.git</a>

Trimal es un programa magnifico capaz de realizar multitud de tareas y merecería un dia entero probando distintos parametros y a prendiendo su uso. En especial para el caso que nos ocupa, podríamos haber perfeccionado el pipeline usando multiples programas para alinear nuestras secuencias y usar trimal para obtener un consenso. Sería una buena alternativa para objetivar el refinamiento de los alineamientos al programa XXXXX que he mencionado más atrás en el texto. Por sacar una pega, trimal maneja de un modo extraño las direcciones de los archivos (*path*). Yo he optado por incluir un cambio de directorio en el escript para evitar usar paths relativos. No deja de ser un truquillo simple que nos puede ayudar a salir del paso.

```{bash}
mkdir ./05_trimmed
```
Save the following script as run_trimal.sh. For this one can use nano and paste the text inside
```{bash}
nano run_trimal.sh
```
Paste the script below
```{bash}
#!/bin/bash
# 
cd ./04_alignments
files=$(ls *.*)
for FILE in $files
do
    echo $FILE
    trimal -gappyout -in $FILE -out trimmed_${FILE} -fasta -htmlout visualization_${FILE}.html
done
mv trimmed_* ../05_trimmed
mv visualization_* ../05_trimmed
cd ..
```
Lanzamos el escript con:

```{bash}
sh run_trimal.sh
```
**Atención Propuesta.** Echale un vistazo a los archivos producidos por trimal usando *more* con los archivos fasta y usando el navegador web con los archivos html.
**Atención Pregunta.** Los archivos html nos ofrecen la posibilidad de decidir si nos conviene usar secuencias de aminoácidos o de nucleotidos. Tu que opinas? fna o faa?

### 6.6. Realizar reconstruccion filogenética para cada locus iqtree
Para la reconstrucción filogenética usamos *Maximum Likelihood* (ML) y no un método bayesiano. TAmpoco usamos parsimonia. Esto es una decisión metodológica debida sobre todo al tiempo de computación necesario y a los menores requerimientos computacionales de este tipo de métodologías. Esto no significa que no puedan usarse métodos bayesianos, pero si es cierto que su usabilidad depende en gran medida de las necesidades y los plazos de cada experimento.

Hay varios métodos de reconstrucción filogenética que permiten realizar análisis de ML aproximados y rápidos. Los tres más frecuentes en la bibliografía son fasttree, raxml e iqtree. Me he decantado por este ultimo porque es un programa menos habitual que los otros dos, y que sin embargo proporciona grandes ventajas metodológicas. Entre otras cosas iqtree es capaz de leer casi cualquier formato (fasta, phyllip,nexus) y en lugar de optimizar el uso de un modelo de sustitución GTR+Gamma como RaxML, incorpora un módulo de selección del modelo de sustitucion basado en AIC o BIC (default) automatizado.

La relevancia del modelo de sustitución es un tema complicado y hay muchos científicos partidarios de invertir meses en hacerlo lo más perfeccionista posible y al mismo tiempo una serie de trabajos que sugieren que tiene una influencia menor en el proceso de inferencia filogenética, llegando a entropecerlo. Me refiero por ejemplo a este paper **PAPER CRITICA MODEL TEST**.

```{bash}
mkdir ./06_iqtree
nano run_iqtree.sh
```
Seleccionamos los alineamientos de nucleótidos, y corremos iqtree en cada locus.
```{bash}
#!/bin/bash
cp ./05_trimmed/*.fna ./06_iqtree
cd ./06_iqtree
files=$(ls)
for FILE in $files
do
		iqtree -s $FILE -m MFP -o Xanpa2 -bb 1000 -bnni -nt AUTO
		rm $FILE
done
cd ..
```

<!---### 6.7. Concatenar todos los loci y hacer un análisis supermatriz iqtree

```{}
mkdir ./07_final
cat ./06_iqtree/*.treefile >> ./07_final/all_trees.tre
```
--->
## 6.7. Calcular un arbol consenso (*mayority rule*) con iqtree
La obtención de un consenso se puede hacer muy fácilmente con iqtree, ya que en principio utiliza el mismo algoritmo que al obtener un consenso de los arboles obtenidos usando *bootstrap*. Pero vamos a ver
```{}
iqtree -con all_trees.tre
```
**Atención Pregunta!** Pero porqúe no funciona? Que he hecho mal? Y como voy a enviar a imprimir mi poster mañana?...
**Atención Propuesta!** Vamos a ver que ocurre si me quedo con aquellos árboles que contengan todas las especies. Para ello vamos a usar el paquete estadistico *ape* implementado en R. Es un interfaz más intuitivo que los que nos proporcionan otros lenguajes como python o perl más enfocados a la automatización de procesoso que al análisis exploratorio de datos.
**Atención Problemilla!** No es nada obvio pero a medida que nos vayamos alejando filogenéticamente e incluyendo especies más distantes el numero de loci que busco será capaz de identificar en todas las especies será menor. Un **consenso** implica que todos los árboles tienen el mismo número de especies.
```{r}
library (ape)
trees<-read.tree("./all_trees.tre")
# Se nos han colado secuencias repetidas?
foo<-sapply(trees,`[[`,"tip.label")
foo
# Tienen todos los árboles el mismo número de especies (tips)
foo<-unlist(sapply(foo,length))
table(foo)
#
# Subset and escribir sólo los árboles completos
#
write.trees(trees[unlist(sapply(sapply(trees,`[[`,"tip.label"),length))==10],"menos_trees.tre")
quit()
```
## 6.8. Anotar el soporte estadístico de la topología
Vamos a usa el metodo propuesto por Salichos y Rokas (2013) <a>http://www.ncbi.nlm.nih.gov/pubmed/23657258</a> en el que se calculan los valores de *Internode Certainty* (IC) y *Tree Certainty* (TC). El método se describe con más profución en <a>
http://mbe.oxfordjournals.org/content/early/2014/02/07/molbev.msu061.abstractkeytype=ref&ijkey =I65FuGNx0HzR2Ow</a>. Aunque su  implementación en RAXML (version>=8.2.0) difiere ligeramente de lo publicado al permitir el uso de set de árboles incompletos como se discute aquí: <a>http://dx.doi.org/10.1101/022053</a>.
Primero debemos volcar todos los arboles obtenidos en iqtree (o raxml) anotados usando bootstrap en un solo archivo
```{}
cat >> mis_arboles.tre
```
Después correremos el programa usando el siguiente script:
```{}
raxmlHPC -L MRE -z all_trees.tre -m GTRCAT -n T1
```

También podremos calcular el arbol consenso usando una busqueda exhaustiva con:
```{}
raxmlHPC -L MRE -z all_trees.tre -m GTRCAT -n T1
```
Podemos usar el consenso que hemos obtenido en iq tree o una topología obtenida concatenando loci (supermatriz) usando el siguiente método
```{}
raxmlHPC -f i -t miconsenso.tre -z mis_arboles.tre -m GTRCAT -n T4
```

En realidad los alineamientos que hemos producido se pueden usar como cualquier otro genusando programas de reconstrucción filogenética standard. Cuando uno utiliza multiples loci en paralelo el espacio paramétrico es muy grande, en especial si los árboles se hacen interdependientes a traves de un reloj molecular. Agrupar particiones (modelos de sustitución) puede reducir el espacio paramétrico pero en ocasiones la ganacia en cuanto a computación es pequeña.

Nota mental: Incrementar el numero de loci aumenta linearmente los requerimientos informaticos, usar los genes en paralelo nos permite hacer una paralelización trivial (a manubrio) del proceso. Podríamos pensar que concatenar puede simplificar el proceso, especialmente si se reduce el numero de particiones de los modelos de sustitución. Sin embargo la enorme longitud del alineamiento complica mucho los calculos de verosimilitud (likelihood) y es necesario hacer una paralelización no trivial de la computación (se divide el alineamiento en x fragmentos y cada thread se hace cargo de calcular de los valores de una parte, esto es lo que hace Beagle usado con beast2 por ejemplo).
Por otro lado incrementar el numero de sequencias afecta la computación de manera exponencial, y satura los requerimientos de RAM en muchos casos. Calcular una filogenia con 300+ genes y las 1700 species de hongos que hay secuenciadas parece una ideaza. Pero la realidad es que implica saturar un cluster entero durante un mé (las secuencias de aminoacidos son más lentas de analizar)

## 6.9. Visualización de arboles con iTol.

El final del proceso de estimar una filogenia es gnerar un gráfico que tenga buen aspecto para publicar. Hay muchas opciones posibles, pero quiero llamaros la atención sobre iTol <https://itol.embl.de>. Es una implementación online que produce gráficos de una calidad excepcional y que permite incorporar matrices de datos para enriquecer la visualización. En un contexto filogenómico donde queremos incorporar datos de anotación funcional sobre una filogenia, este programa un buen salvavidas.

Simplemente abrid la página web e importad vuestros árboles. La introducción de datos se puede hacer desde excel (previo pago) o a mano. Yo suelo usar R para obtener una tabla, con el nombre de cada tip y una paleta de colores personalizada en RGB. Pero tiene poco misterio.

### 6.11 Limpiar de artefactos las filogenias usando treeshrink
Uno de los problemas más habituales que nos podemos encontrar es la unclusión de secuencias que por la razón que sea acumlan mayor número de caracteres diferenciales de los esperable. Esto puede ser real, pero a menudo es debido a errores en el alineamiento o a la presencia de contaminantes o parálogos no identificados.
Este es un paso importante a la hora de discutir la corrección de las inferencias filogenéticas llevadas a cabo anteriormente, aunque en muchos trabajos se usa un método de filtrado por defecto.

Treeshrink es un programa relativamente nuevo que automatiza el filtrado *a posteriori* de las topologías.
```{}
python /usr/local/src/TreeShrink/run_treeshrink.py -t all_trees.tre -o all_trees_filtered.tre
```
**Atención Pregunta!** Cuantas veces se ha eliminado cada especie?
**Atención Propuesta!** Como afecta esto al soporte estadístico? y al consenso? Puedes volver a trás y repetir los pasos anteriores pero sobre el archivo *all_trees_filtered.tre*. Otra opción es seguir adelante y usar Astral para el mísmo proposito.

### 6.12. Astral para obtener un superárbol.

En sentido estricto un consenso implica procesar árboles que contengan el mismo número de especies. Esto sólo es factible factible a niveles filogenéticos intermedios, pero a medida que nos desplazamaos a nivel de familía u orden el número de genes ortólogos de copia única presentes en todos los genómas es cada vez menor. A nivel de división a penas hay genes ortólogos que estén presentes en todas las muestras. Para procesar árboles cincompletos se requieren métodos de inferencia de *superárboles*. Los métodos para calcular superárboles fueron en los años noventa desterrados por lós metoos haciendo uso de supermatríces, por ser farragosos de usar y lentos. Aún así, hay varios métodos modernos permiten calcular superárboles, aunque normalmente no los llaman así. Un ejemplo es Astral III <https://github.com/smirarab/ASTRAL>, que bajo el constructo de que es un árbol de coalescente, lo que hace es estimar una topología de especies basada en la descomposición en quartetes.


Primero calcularemos un árbol de especies compendio (*summary*) basado en la topología más verosimil (ML) de cada gen.

```{}
java -jar /usr/local/bin/astral.5.6.3.jar -i ./all_trees.tre -o ./astral.tre
```
Después procesaremos la distribución de árboles obtenidos mediante bootstrap. Para ello crearemos un lista de archivos:

```{}
ls ./06_iqtree/*.ufboot > bootstrap_list.txt
```
que utilizaremos para calcular arboles compendio de los distintos loci. 
```{}
java -jar /usr/local/src/ASTRAL/astral.5.6.3.jar -i ./all_trees.tre -o ./astral_boot.tre -b ./bootstrap_list.txt
```
En nuestro caso el arbol de especies y el de genes contienen el mismo número de entradas. En casos en que tengamos más de un genoma por especie, es donde Astral se vuelve importante al permitir incorporar polimorfismo intraespecífico (Es decir realoiza un arbol de especies en sentido estricto).
**Atención Propuesta.** Echale un vistazo al manual de astral. Te parece el concepto de árbol de especies coherente con conceptos basados en coalescencia (multispecies coalescent)? O quizás no llamamos árbol de especies a lo mismo?

### 6.12. Redes consenso en Dendroscope.

Una alternativa interesante es usar el programa dendroscope <http://dendroscope.org> para obtener redes filogenéticas consenso. Esto será util tanto para detectar problemas como para discutir hibridación o introgresión si este fuese el caso. Además el algoritmo de z-closure permite también trabajar con árboles incompletos (supernetwork).

Para trabajar simplemente teneis que ejecutar dendroscope en la máquina virtual o el ordenador que tengais disponible e importar el archivo all_trees.tre. La interfáz gráfica es sencilla y autoexplicativa. Tiene enormes cantidades de opciones para explorar. El manual está aquí <https://ab.inf.uni-tuebingen.de/data/software/dendroscope3/download/manual.pdf>. A por ello.

### 6.11. Comparar topologías usando distancias Robinson-Foulds.

```{}
iqtree -t all_trees.tre -rf_all
```
Despues puedes abrir R y probar a interpretar la distribución de distancias
```{r}
rf<-read.table("menos_trees.tre.rfdist",skip=1,row.names=1)
rf<-as.dist(rf)
/home/fernando/genomics_course/new/new/02_Busco/run_X1scaffoldsfiltered/full_table_X1scaffoldsfiltered.tsv
```

## 7. Tutorial II.  Un pipeline usando detección de ortólogos a posteriori
### 7.1. Pasos preliminares
He instalado funannotate usando un ambiente de anaconda siguiendo las instrucciones del manual.
No olvidarse de exportar las siguientes versiones
```{bash}
export EVM_HOME=/home/fernando/anaconda2/envs/funannotate/opt/evidencemodeler-1.1.1/
export TRINITYHOME=/home/fernando/anaconda2/envs/funannotate/opt/trinity-2.6.6
export PASAHOME=/home/fernando/anaconda2/envs/funannotate/opt/pasa-2.3.3
export AUGUSTUS_CONFIG_PATH=/usr/local/src/maker/exe/augustus/config
export GENEMARK_PATH=/usr/local/src/gm_et_linux_64/gmes_petap/
export FUNANNOTATE_DB=/usr/local/src/funannotateDB
export BAMTOOLS_PATH=/usr/local/src/BOSS/bamtools
export PATH="/usr/local/src/maker/exe/RepeatMasker:$PATH"
export PATH="/usr/local/src/funannotate:$PATH"
```
El punto de partida son genoma completamente ensamblados y refinados.
Primero usamos sort para renombrar los contigs con nombres más compatibles con genbank.

```{bash}
for FILE in X1 X2 X3 X4 X5 X6 X7 X8 X9 Xanpa
do
funannotate sort \
-i /home/fernando/genomics_course/new/new/01_data/${FILE}*.fasta \
-o /home/fernando/genomics_course/new/new/01_data/${FILE}_sorted.fasta
done
```
Después se enmascaran las regiones repetidas
```{bash}
for FILE in X1 X2 X3 X4 X5 X6 X7 X8 X9 Xanpa
do
funannotate mask \
-i /home/fernando/genomics_course/new/new/01_data/${FILE}_sorted.fasta \
-o /home/fernando/genomics_course/new/new/01_data/${FILE}_masked.fasta \
-s ascomycota
done
```
Prediccion de genes usando todos los niveles de evidencia disponibles (ESTs, etc.) En nuestro caso no tenemos y usamos las proteinas de Xanthoria parietina como única evidencia.

```{bash}
for FILE in X1 X2 X3 X4 X5 X6 X7 X8 X9
do
funannotate predict \
-i  /home/fernando/genomics_course/new/new/01_data/${FILE}_masked.fasta \
-s "Caloplaca sp ${FILE}" \
-o /home/fernando/genomics_course/new/new/03_funannotate/${FILE}_annotated \
--protein_evidence /home/fernando/Documents/4_Cerodens_Scaffolded/4_maker/Xanpa2_all_proteins_20140928.aa.fasta $FUNANNOTATE_DB/uniprot_sprot.fasta \
--name ${FILE}_ \
--busco_db pezizomycotina \
--augustus_species caloplaca_erodens \
--cpus 30
done
```
### 7.3. Usamos el pipeline Orthofinder

En esta sección del tutoriasl vamos a utilizar el pipeline filogenómico Orthofinder (<https://github.com/davidemms/OrthoFinder>). Este pipeline es muy interesante pues extrae loci ortologos usando un algoritmo de *cluster* primero y un procesado *a posteriori* de los árboles filogenéticos.

Además vamos a utilizar este pippeline como introducción a docker <https://www.docker.com>. Docker es un sistema para encapsular un sistema operativo y los ejectubles de un programa de nuestro enterés en un contenedor único que puede ser utilizado en cualquier ordenador y cualquier sistema operativo. Docker a menudo soluciona problemas de dependencias (las librerias de perl suelen ser el horror) y de conflictos de versiones y permite tener un sistema estable y permanente. Tinen también ciertas desventajas respecto a la configuaración nativa de algunas aplicaciones, en especial cuando se requiere usar bases de datos externas de manera intensiva. Hay varios repositorios de contenedores de docker dedicados a la bioinformática, entre los cuales el punto de partida quizas sea biocontainers <https://github.com/BioContainers/containers>.

**Atención pregunta:** En realidad este pipeline no es adecuado para el dataset que vamos a utilizar, que es el mismo que en el ejercicio anterior. Sabrías decirme por qué?
**Atención recomendación:** Echaos un vistazo a la descripción del pipeline en su pagina web. Es magnífica.

Al turrón! Lo primero que haremos será instalar el container de docker donde está instalado el pipeline orthofinder.

```{bash}

docker pull cmonjeau/orthofinder

```
Seguidamente correremos el programa usando el siguente script

```{bash}
mkdir ./02_results
docker run -it --rm -v "/home/fernando/genomics_course/new/new/02_orthofinder/01_data":/input cmonjeau/orthofinder orthofinder.py -f /input -t 10 -a 10 -S diamond
docker run -it --rm -v "/home/fernando/genomics_course/new/new/02_orthofinder/02_results":/input cmonjeau/orthofinder trees_for_orthogroups.py /input/ -t 7
```
Orthofinder tien varias opciones de alineamiento y reconstrucción filogenética, etc. Hemos utilizado las opciones por defecto con diamond y dendroblast pues son ambos más rápidos. En general, diamond <https://github.com/bbuchfink/diamond> se ha convertido en el nuevo standard para realizar alineaminetos locales, sustituyendo a BLAST que es miles de veces más lento. Hay algunas dudas sobre si los valores reflejados por diamond son equiparables a los de blast original, pero el hecho es que la aceleración que supone ha desterrado el uso de BLAST para comparaciones de aminoacido-aminoacido (blastp) y nucleotido-aminoacido (blastx) en la mayoría de los programas más modernos.

```{bash}
orthofinder -f \
 -t 30 \
 -a 30 \
 -M dendroblast \
 -S diamond \
 -A mafft \
 -p ./tmp
````
**Atención pregunta:** Repasate los archivos de resultados de Orthofinder. Que ocurre con el arbol consenso? Porqué son tan cortas las ramas? (si desactivamos la longitud de las ramas en la visualización del arbol filogenético verás que están ahi). Fijate en cuantos ortólogos de copia única ha identificado. No te resulta extra~õ que sean tan pocos? Fijate en los arboles de la mayoría de grupos ortólogos? por qué tienen tan pocas secuencias? Que puede estar ocurriendo?

## 8. Tutorial III.  Introducción a funannotate




Hasta aquí es equivalente (pero más refinado a los que hicimos con augustus para BUSCO. Podríamos partir de las secuencias de genes identificadas usando funannotate como entrada para BUSCO (para hacer filogenómica).

Una vez identificados los genes, proseguimos con la anotación funcional. usando *antiSMASH* como primer pipeline, interproscan y finalmente se pone todo en conjunto usando *funannotate annotate*.
```{bash}
for FILE in X1 X2 X3 X4 X5 X6 X7 X8 X9
do
#Run antiSMASH:
funannotate remote -i /home/fernando/genomics_course/new/new/03_funannotate/${FILE}_annotated -m antismash -e fernandf@uni-graz.at
done
```
```{bash}
for FILE in X1 X2 X3 X4 X5 X6 X7 X8 X9
do
for FILE in X1 X2 X3 X4 X5 X6 X7 X8 X9
do
funannotate iprscan -i /home/fernando/genomics_course/new/new/03_funannotate/${FILE}_annotated -m local -c 30 --iprscan_path /usr/local/src/interproscan-5.30-69.0/
funannotate remote -i /home/fernando/genomics_course/new/new/03_funannotate/${FILE}_annotated -m antismash -e fernandf@uni-graz.at
funannotate remote -i /home/fernando/genomics_course/new/new/03_funannotate/${FILE}_annotated -m phobius -e fernandf@uni-graz.at
funannotate annotate -i /home/fernando/genomics_course/new/new/03_funannotate/${FILE}_annotated --cpus 30
done
```
**Atención, nota mental!** La anotación completa de un genoma fungico (ca. 10.000 proteinas) en funannotate requiere unas 24 horas. Yo he usado una maquina con 32 nucleos lógicos, de ahi que haya usado en los escripts los *flags* -c 30 o --cpus 30. Ten en cuenta que esto depende mucho de tu máquina.

### 6.2. Usar la comparación genómica incorporada en funannotate
```{bash}
funannotate outgroup xanthoria_parietina.ascomycota
```
```{bash}
funannotate compare -i X1_annotated  X2_annotated  X3_annotated  X4_annotated  X5_annotated  X6_annotated  X7_annotated  X8_annotated  X9_annotated --outgroup xanthoria_parietina.ascomycota
```

#### Resumen de los resultados de funannotate
o
#### Uso de COGs para calcular filogenias
o
#### Modulo incluido en funanotate, problemas y alternativas.
o
#### Proceder igual que en el tutorial III
o
#### Mapear la información en el genóma

## Integrate functional annotations
```{r}
pfam<-read.table("/Users/ferninfm/Desktop/eraseme/funannotate_compare/pfam/pfam.results.csv",sep=",",quote="\"",row.names=1,header=TRUE)
library(ape)
plot(as.phylo(hclust(dist(t(as.matrix(pfam[,1:9]))))))
```

## References

Buchfink, B., Xie, C., & Huson, D. H. (2015). Fast and sensitive protein alignment using DIAMOND. Nat Meth, 12(1), 59–60. Retrieved from http://dx.doi.org/10.1038/nmeth.3176

Capella-Gutiérrez, S., Silla-Martínez, J. M., & Gabaldón, T. (2009). trimAl: A tool for automated alignment trimming in large-scale phylogenetic analyses. Bioinformatics, 25(15), 1972–1973. https://doi.org/10.1093/bioinformatics/btp348

Catchen, J. M. (2013). Stacks: an analysis tool set for population genomics. Molecular Ecology, 22(11), 3124–3140. https://doi.org/10.1111/mec.12354.Stacks

Catchen, J. M., Amores, A., Hohenlohe, P., Cresko, W., & Postlethwait, J. H. (2011). Stacks : Building and Genotyping Loci De Novo From Short-Read Sequences. G3 Genes|Genomes|Genetics, 1(3), 171–182. https://doi.org/10.1534/g3.111.000240

Darling, A. E., Mau, B., & Perna, N. T. (2010). Progressivemauve: Multiple genome alignment with gene gain, loss and rearrangement. PLoS ONE, 5(6). https://doi.org/10.1371/journal.pone.0011147

De Wit, P., Pespeni, M. H., Ladner, J. T., Barshis, D. J., Seneca, F., Jaris, H., … Palumbi, S. R. (2012). The simple fool’s guide to population genomics via RNA-Seq: an introduction to high-throughput sequencing data analysis. Molecular Ecology Resources, 12(6), 1058–1067. https://doi.org/10.1111/1755-0998.12003

Dewey, C. N. (2011). Positional orthology: Putting genomic evolutionary relationships into context. Briefings in Bioinformatics, 12(5), 401–412. https://doi.org/10.1093/bib/bbr040

Eaton, D. a R. (2014). PyRAD: assembly of de novo RADseq loci for phylogenetic analyses. Bioinformatics, 30, 1844–1849. https://doi.org/10.1093/bioinformatics/btu121

Eddy, S. R. (1998). Profile hidden Markov models. Bioinformatics, 14(9), 755–763. https://doi.org/btb114 [pii]

Eisen, J. A. (1998). Phylogenomics : Improving Functional Predictions for Uncharacterized Genes by Evolutionary ? Analysis Phylogenomics : Improving Functional Predictions for Uncharacterized Genes by Evolutionary Analysis. Genome Research, (1997), 163–167. https://doi.org/10.1101/gr.8.3.163

Garrison E, Marth G. Haplotype-based variant detection from short-read sequencing. arXiv preprint arXiv:1207.3907 [q-bio.GN] 2012

Huson, D., Mitra, S., & Ruscheweyh, H. (2011). Integrative analysis of environmental sequences using MEGAN4. Genome Research, 21(9), 1552–1560. https://doi.org/10.1101/gr.120618.111.Freely

Kuzniar, A., van Ham, R. C. H. J., Pongor, S., & Leunissen, J. A. M. (2008). The quest for orthologs: finding the corresponding gene across genomes. Trends in Genetics, 24(11), 539–551. https://doi.org/10.1016/j.tig.2008.08.009

Langmead, B., & Salzberg, S. L. (2012). Fast gapped-read alignment with Bowtie 2. Nature Methods, 9(4), 357–359. https://doi.org/10.1038/nmeth.1923

Leavitt, S. D., Grewe, F., Widhelm, T., Muggia, L., Wray, B., & Lumbsch, H. T. (2016). Resolving evolutionary relationships in lichen-forming fungi using diverse phylogenomic datasets and analytical approaches. Scientific Reports, 6(1), 22262. https://doi.org/10.1038/srep22262

Li, H., & Durbin, R. (2009). Fast and accurate short read alignment with Burrows-Wheeler transform. Bioinformatics, 25(14), 1754–1760. https://doi.org/10.1093/bioinformatics/btp324

Li, H., Handsaker, B., Wysoker, A., Fennell, T., Ruan, J., Homer, N., … Durbin, R. (2009). The Sequence Alignment/Map format and SAMtools. Bioinformatics, 25(16), 2078–2079. https://doi.org/10.1093/bioinformatics/btp352

McKenna, A., Hanna, M., Banks, E., Sivachenko, A., Cibulskis, K., Kernytsky, A., … DePristo, M. A. (2010). The Genome Analysis Toolkit: A MapReduce framework for analyzing next-generation DNA sequencing data. Genome Research, 1297–1303. https://doi.org/http://www.genome.org/cgi/doi/10.1101/gr.107524.110.

Minh, B. Q., Anh Thi Nguyen, M., & von Haeseler, A. (2013). Ultra-Fast Approximation for Phylogenetic Bootstrap. Molecular Biology and Evolution, 30(5), 1188–1195. https://doi.org/10.1093/molbev/mst024

Mistry, J., Finn, R. D., Eddy, S. R., Bateman, A., & Punta, M. (2013). Challenges in homology search: HMMER3 and convergent evolution of coiled-coil regions. Nucleic Acids Research, 41(12), 1–10. https://doi.org/10.1093/nar/gkt263

O’Brien, S. J., Menotti-Raymond, M., Murphy, W. J., Nash, W. G., Wienberg, J., Stanyon, R., … Marshall Graves, J. A. (1999). The Promise of Comparative Genomics in Mammals. Science, 286(5439), 458 LP – 481. https://doi.org/10.1126/science.286.5439.458

O’Brien, S. J., & Stanyon, R. (1999). Ancestral primate viewed. Nature, 402(6760), 365–366. https://doi.org/10.1038/46450

Rissman, A. I., Mau, B., Biehl, B. S., Darling, A. E., Glasner, J. D., & Perna, N. T. (2009). Reordering contigs of draft genomes using the Mauve Aligner. Bioinformatics, 25(16), 2071–2073. https://doi.org/10.1093/bioinformatics/btp356

Schlötterer, C., Tobler, R., Kofler, R., & Nolte, V. (2014). Sequencing pools of individuals — mining genome-wide polymorphism data without big funding. Nature Reviews Genetics, 15(11), 749–763. https://doi.org/10.1038/nrg3803

Shen, X.-X., Zhou, X., Kominek, J., Kurtzman, C. P., Hittinger, C. T., & Rokas, A. (2016). Reconstructing the Backbone of the Saccharomycotina Yeast Phylogeny Using Genome-Scale Data. G3 Genes|Genomes|Genetics, 6(December), 3927–3939. https://doi.org/10.1534/g3.116.034744

Simão, F. A., Waterhouse, R. M., Ioannidis, P., Kriventseva, E. V., & Zdobnov, E. M. (2015). BUSCO: Assessing genome assembly and annotation completeness with single-copy orthologs. Bioinformatics, 31(19), 3210–3212. https://doi.org/10.1093/bioinformatics/btv351

Sjolander, K. (2004). Phylogenomic inference of protein molecular function: advances and challenges. Bioinformatics (Oxford, England), 20(2), 170–179.

Stanke, M., Schöffmann, O., Morgenstern, B., & Waack, S. (2006). Gene prediction in eukaryotes with a generalized hidden Markov model that uses hints from external sources. BMC Bioinformatics, 7(1), 62. https://doi.org/10.1186/1471-2105-7-62

Zhou, X., Shen, X., Hittinger, C. T., & Rokas, A. (2017). Evaluating fast maximum likelihood-based phylogenetic programs using empirical phylogenomic data. BioRxiv, http://dx.

<!---
(Pizarro et al. 2018; Zhang et al. 2018; Marthey et al. 2008; Huerta-Cepas et al. 2016; Choi and Kim 2017)
Choi, JaeJin, and Sung-Hou Kim. 2017. “A Genome Tree of Life for the Fungi Kingdom.” Proceedings of the National Academy of Sciences 114 (35): 201711939. https://doi.org/10.1073/pnas.1711939114.
Huerta-Cepas, Jaime, Damian Szklarczyk, Kristoffer Forslund, Helen Cook, Davide Heller, Mathias C. Walter, Thomas Rattei, et al. 2016. “EGGNOG 4.5: A Hierarchical Orthology Framework with Improved Functional Annotations for Eukaryotic, Prokaryotic and Viral Sequences.” Nucleic Acids Research 44 (D1): D286–93. https://doi.org/10.1093/nar/gkv1248.
Marthey, Sylvain, Gabriela Aguileta, François Rodolphe, Annie Gendrault, Tatiana Giraud, Elisabeth Fournier, Manuela Lopez-Villavicencio, Angélique Gautier, Marc Henri Lebrun, and Hélène Chiapello. 2008. “FUNYBASE: A FUNgal PhYlogenomic DataBASE.” BMC Bioinformatics 9 (i): 1–10. https://doi.org/10.1186/1471-2105-9-456.
Pizarro, David, Pradeep K. Divakar, Felix Grewe, Steven D. Leavitt, Jen Pan Huang, Francesco Dal Grande, Imke Schmitt, Mats Wedin, Ana Crespo, and H. Thorsten Lumbsch. 2018. “Phylogenomic Analysis of 2556 Single-Copy Protein-Coding Genes Resolves Most Evolutionary Relationships for the Major Clades in the Most Diverse Group of Lichen-Forming Fungi.” Fungal Diversity 92 (1): 31–41. https://doi.org/10.1007/s13225-018-0407-7.
Zhang, Chao, Maryam Rabiee, Erfan Sayyari, and Siavash Mirarab. 2018. “ASTRAL-III: Polynomial Time Species Tree Reconstruction from Partially Resolved Gene Trees.” BMC Bioinformatics 19 (Suppl 6): 15–30. https://doi.org/10.1186/s12859-018-2129-y.
--->


