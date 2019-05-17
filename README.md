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

*Fernando Fernández Mendoza*

17-05-2019

---

## 1. Introducción

El término filogenómica fue acuñado de manera casi contemporánea para referirse a dos disciplinas científicas diferentes pero que comparten un trasfondo metodológico común: el uso de técnicas de reconstrucción filogenética para analizar datos genómicos. Eisen en el año 1998 fue el primero en utilizar el término para referirse al uso de modelos filogenéticos en la anotación funcional de secuencias proteicas. Por otro lado O'Brien (1999) introdujo el término para referirse al uso de datos genómicos en la reconstrucción de la historia evolutiva de un grupo taxonómico. Ambas disciplinas difieren en cuanto a métodos, objetivos e incluso en el nivel de organización biológica que estudian, pero juntas proporcionan la base conceptual para la genómica comparativa y evolutiva.

El propósito común a todos los estudios filogenéticos es la inferencia de las relaciones evolutivas entre especies. Hay muchos estudios cuyo único objetivo es la obtención de una hipótesis evolutiva, aunque a menudo también se usa la reconstrucción filogenética como base  para modelar procesos más complejos como patrones de diversificación, dinámicas poblacionales, evolución de caracteres, filogeografía, etc. Bajo una visión restringida, la filogenómica se podría entender cómo una extensión de la filogenética tradicional  para usar ya no muchos loci, sino todos los posibles. Sus premisas y objetivos serían comunes, y sus métodos se habrían reajustado para poder afrontar el nuevo tipo y volumen de datos. Sin embargo, los métodos modernos de secuenciación masiva no sólo proporcionan un enorme número de caracteres genéticos, sino que permiten realizar una descripción detallada de la estructura de los genomas, así como de la función de cada uno de los genes que los conforman. La filogenómica pues, permite estudiar tanto la evolución de las especies como la de sus genomas, y proporciona un marco histórico para la interpretación de los mecanismos ecológicos y moleculares asociados con el proceso evolutivo.

En definitiva, la filogenómica no es sólo calcular filogenias, sino que proporciona una puerta de acceso al estudio comparativo de los genomas y su evolución molecular. Aunque ello requiere una importante inversión mucho mayor en recursos económicos y humanos.

## 2. Objetivos del curso

El objetivo del curso es proporcionar una visión general sobre las necesidades metodológicas que tienen los estudios filogenómicos. El curso se compone de tres ejercicios prácticos e incluye varias pausas de lectura, que sirven para optimizar el uso de los tiempos de computación, que son relativamente elevados. Aunque suene a meme de Paulo Coelho: “Entender lo que estamos haciendo es tan importante como entender por qué lo estamos haciendo.”

El primer tutorial es la actividad principal. Tiene como objeto desarrollar un *pipeline* filogenómico basado en la aplicación [BUSCO](https://busco.ezlab.org). Es un pipeline sencillo y poco automatizado, pero ejemplifica los distintos pasos necesarios para realizar un estudio filogenómico e ilustra los requerimientos computacionales reales de este tipo de estudios. Los objetivos son: (1) familiarizarse con el uso del terminal de UNIX, (2) desarrollar todos los pasos necesarios para obtener un set de datos filogenómico a partir de ensamblajes genómicos no anotados, (3) probar distintos métodos de reconstrucción filogenética basada en múltiples loci.

El segundo tutorial se centra en utilizar un pipeline filogenómico en el que se parte de secuencias de proteínas y en el que se hace una identificación de ortólogos *de novo* . Además sirve para practicar el uso de contenedores de docker.

El tercer tutorial se centra en introducir el pipeline de anotación funcional [funannotate](https://funannotate.readthedocs.io/en/latest/) y de las posibilidades de análisis filogenómico que ofrece su módulo de genómica comparativa. Este es un tutorial más abierto, y está centrado en aprender a usar R para procesar los distintos resultados y recursos que funannotate pone en nuestras manos.

## 3. Partes de un pipeline: Propuestas metodológicas

Mientras que los protocolos utilizados en estudios filogenéticos están extremadamente estandarizados, en filogenómica no existe un enfoque único, una receta para todo que pueda considerarse como consenso. La filosofía y los métodos utilizados para cada estudio dependen en gran medida del tipo de datos adquiridos, su calidad y cobertura genómica y la extensión filogenética o el propósito del estudio.

En general un estudio filogenómico va a requerir muchos de los siguientes pasos:
1. Secuenciación (del genoma o del transcriptoma, completo o no)
2. Ensamblado de los genomas (*de novo* o alineando a una referencia)
3. Refinamiento del ensamblajes.
4. Predicción de genes (o loci)
5. Anotación (Comparación con bases de datos, anotación funcional)
6. Agrupamiento (*cluster*) de secuencias génicas
7. Selección de loci ortólogos (*a priori*)
8. Alineamiento de secuencias (de nucleótidos o aminoácidos)
9. Refinamiento del Alineamiento
10. Reconstrucción filogenética (*supermatrix* o árboles de genes)
11. Selección de loci ortólogos (*de novo*)
12. Filtrado de topologías
13. Construcción de un consenso (*supertree*)

Distintos pipelines enfatizan uno u otro elemento dependiendo de su enfoque y su propósito, aunque las mayores diferencias radican en el método usado para identificar ortólogos y al extensión filogenética que se pretende analizar.

## 4. Que son genes ortólogos? 

El primer paso es la obtención de un set de datos genéticos que puedan ser analizados. Obtener una matriz de datos filogenética usando secuenciación Sanger es bastante sencillo. Los loci a estudiar han sido seleccionados de antemano y vienen definidos por el par de cebadores o *primers* que se usará para la amplificación mediante PCR. Sin embargo, generar matrices filogenómicas puede resultar muy complejo, en especial cuando se está tratando con organismos alejados de los modelos genómicos tradicionales o cuando la relación filogenética entre ellos es distante.

Una de las primeras preguntas intuitivas que un científico proveniente de la sistemática filogenética se plantea es "Ya tengo mis genomas. Y ahora cómo se alinean?". Y si, hay métodos para alinear genomas, desde MAUVE (Darling, Mau, and Perna 2010) y métodos para identificar bloques sinténicos entre genomas como [SyMap](https://academic.oup.com/nar/article/39/10/e68/1310457), [MCScanX](https://academic.oup.com/nar/article/40/7/e49/1202057) o [Sibeliaz]( https://www.biorxiv.org/content/10.1101/548123v1.abstract ); pero que no son lo que necesitamos hacer.

En la actualidad, los estudios a nivel genómico son habituales, y es relativamente fácil encontrar un *pipeline* o un software que haga algo parecido a lo que queremos hacer. A pesar de ello, sigue resultando muy difícil tomar decisiones bien informadas para diseñar un estudio filogenómico con anticipación.

La brecha terminológica existente entre las disciplinas de la sistemática filogenética y la genómica molecular, también contribuye a crear cierta confusión. Los términos filogenómica y ortólogo por ejemplo, son más habituales en el contexto de la anotación funcional que en su uso como marcadores filogenéticos.

El concepto de ortología, es sin duda fundamental para entender los métodos filogenómicos. Uno de los conceptos básicos de la biología evolutiva es el de analogía y homología. Para establecer relaciones de parentesco evolutivo sólo se pueden utilizar caracteres –morfológicos o genéticos– homólogos, es decir caracteres cuya semejanza –funcional– se deba a que tienen un mismo origen evolutivo, derivan de las presentes en un ancestro común. Los caracteres análogos son aquellos cuya semejanza resulta de una convergencia,  han sido adquiridos de manera secundaria e independiente, y por tanto su uso no informa sobre relaciones de parentesco evolutivo.

Los conceptos de homología y analogía también son aplicables a nivel molecular. Aun cuando dos genes produzcan un enzima que degrade el mismo sustrato, si no derivan de una proteína ancestral común, las diferencias entre ellas no son informativas para establecer relaciones de parentesco.

Cuando se trata con caracteres genéticos, las duplicaciones de genes hacen que la homología no sea un criterio suficiente. Una duplicación genera dos copias del mismo gen en el mismo genoma que evolucionan siguiendo dos líneas independientes, y pueden estar sujetas a presiones evolutivas completamente opuestas. Los genes originados por una duplicación se denominan parálogos, y los que se generan siguiendo una línea evolutiva lineal, ortólogos (Fitch 1970, 2000). En otras palabras, los genes ortólogos son aquellos cuyas diferencias se originan siguiendo linealmente el proceso de especiación y por tanto permiten trazar una línea de herencia unívoca hasta un ancestro común. 

Cuando el objetivo es entender la historia evolutiva de un gen, la inclusión de ortólogos y parálogos no es negativa, al contrario, permite discutir duplicaciones, procesos de transferencia horizontal de genes, etc… Esto es muy interesante tanto para la anotación funcional, como para modelar la evolución de los genomas, siempre que el nivel de organización de interés sea el genómico.

Si el objetivo es calcular una filogenia a nivel de especie, los parálogos introducen una fuente de variación que no es causada por el proceso que queremos modelar, que es el de especiación, y por tanto no deben ser utilizados. 

Cuando los dos genes procedentes de una duplicación están en el mismo genoma, se dice que son parálogos internos (*in-paralogs*). Estos son obviamente fáciles de identificar y filtrar. Los parálogos encontrados en dos o mas genomas se denominan externos o *out-paralogs*, y para su identificación se requiere un contexto filogenético. El problema es que las duplicaciones de genes no suelen mantenerse en los genomas de manera estable. Lo mas habitual es que una de esas copias sea silenciada y limpiada del genoma a lo largo del devenir evolutivo. Cuando los parálogos son externos, y no están presentes en todos los genomas pueden ser interpretados como ortólogos sin serlo. Es frecuente además que el tiempo en que un gen esta duplicado al menos una de las copias sufra modificaciones importantes neofuncionalización o especialización que alteran importantemente su secuencia de aminoácidos.

Para complicar más esta cuestión de los ortólogos, el concepto de ortólogo está ampliamente integrado en el discurso de la genética molecular donde se utiliza habitualmente referido a grupos de proteínas cuya función ha sido asignada basándose en criterios de ortología, como por ejemplo *clusters of ortologous groups* de [COG] (https://www.ncbi.nlm.nih.gov/COG/) o la base de  datos [OrthoMCL](https://orthomcl.org/orthomcl/) de la que deriva el programa BUSCO.

La identificación de genes ortólogos es un campo central en genómica comparativa y anotación funcional. La referencia española más importante es sin duda [Toni Gabaldón](https://www.crg.eu/en/programmes-groups/gabaldon-lab), que toma parte de la iniciativa [*Quest for orthologs*](https://questfororthologs.org) (Kuzniar et al. 2008) y cuyo proyecto [Phylome](http://phylomedb.org) es un recurso filogenómico muy importante.

## 5. Cómo generar una matriz de datos filogenómicos?

Hay varias opciones metodológicas encaminadas a obtener una matriz de datos analizable mediante métodos filogenéticos. Los criterios para seleccionar una u otra aproximación dependen tanto del objetivo del estudio como de la proximidad filogenética de los organismos estudiados. En términos generales podemos proponer las siguientes categorías:

### 5.1. Métodos basados en resecuenciación genómica (poblaciones o especies muy cercanas, subgéneros)

Cuando el objeto de estudio son organismos filogenéticamente muy cercanos, se puede considerar que los genomas guardan una gran similitud estructural y por lo tanto una casi total ortología posicional (si esa es otra manera de verlo: Dewey 2011). En este caso bastaría alinear los *reads* directamente a un genoma de referencia usando herramientas como BWA (Li and Durbin 2009) o Bowtie2 (Langmead and Salzberg 2012), filtrar las regiones con una heterocigosidad fuera de la distribución esperada para evitar parálogos e inferir SNVs usando programas como Freebayes (Garrison & Marth 2012), Stacks (Catchen 2013) o Pyrad (Eaton 2014) dependiendo del tipo de librerías que hayamos secuenciado, o incluso métodos generales de *variant calling* como los implementados en GATK (McKenna et al. 2010) o samtools (Li et al. 2009). Este tipo de implementaciones también se usan para analizar datos obtenidos mediante RNASeq (De Wit et al. 2012) y poolseq (Schlötterer et al. 2014).

Un ejemplo de *pipeline* filogenómico que usa este tipo de aproximación es [RealPhy](https://realphy.unibas.ch/realphy/),  usado por ejemplo para estudiar el hongo liquenizado *Rhizoplaca melanophthalma* (Leavitt et al. 2016). La mayor ventaja de este tipo de metodologías es que nos permiten estar a medio camino entre la genética de poblaciones y la filogenética. Su mayor limitación es la dificultad para incorporar *outgroups*.  Estas metodologías no las vamos a tratar en este curso. 

### 5.2. Métodos basados en la comparación con bases de datos

La mayoría de estudios filogenómicos no suelen estar basados en la resecuenciación de genomas de especies muy cercanas entre sí, sino que suelen estudiar grupos taxonómicos mas distantes. En este caso no se puede asumir una ortología posicional a nivel genomico, aunque es cierto que en el caso de los genomas de hongos se suelen identificar grandes bloques sinténicos conservados aun entre genomas distantes.

En este caso se suelen comparar genomas ensamblados, bien completamente terminados o bien *drafts* genómicos parciales. Estos son procesados para predecir genes, cuyas secuencias son el punto de punto de partida para la identificación de ortólogos.

La identificación de ortólogos se suele realizar comparando las secuencias proteicas predichas con una base de datos de referencia. La comparación se realiza usando [Blast](https://blast.ncbi.nlm.nih.gov/Blast.cgi) u otro algoritmo de alineamiento local mas moderno y rápido como lo es [*diamond*](https://github.com/bbuchfink/diamond). Con esta idea de base podríamos clasificar la mayoría de pipelines filogenómicas según que tipo de base de datos de referencia usan:

#### 5.2.1. Usando un genoma externo como referencia (Outgroup)

El método más sencillo es convertir un genoma conocido en una colección de secuencias proteicas a usar como referencia. Para identificar el gen ortólogo que queremos solo debemos alinear los genes del genoma que queremos procesar con la base de datos y seleccionar para la reconstrucción filogenética el mejor *hit* unidireccional para cada locus –Es decir el gen que mejor se alinea con la referencia, el resultado positivo del alineamiento local *blast* que tenga un evalor (*e-value*) menor–. Este paso es obvio y en realidad es una parte fundamental de la mayoría de *pipelines* que automatizan la anotación de genomas, donde se usa como evidencia externa. 

Esté método para identificar ortólogos, puede funcionar a nivel de género o incluso de familia. Como inconvenientes, no es particularmente sólido y no permite identificar genes ortólogos de un modo explicito. A medida que se incluyen más genomas aumentan los riesgos de incluir parálogos. Un ejemplo algo más refinado de este grupo de métodos es el pipeline [RealPhy]( https://realphy.unibas.ch/realphy/) que usa más de un genoma como referencia.

#### 5.2.2. Usando todos los genomas como referencia (*Best reciprocal blast hit*)

Un segundo método, que es un refinamiento del anterior sería utilizar para la selección de loci, no ya el mejor *hit* unidireccional con el genoma de referencia sino usar como criterio el mejor *hit* recíproco (*best reciprocal blast hit*). Es decir, crearíamos una base de datos del genoma A (*reference*) sobre la que buscaríamos las proteínas de B (*query*) alineándolas. Seguidamente crearíamos una base de datos con el genoma B sobre el que buscaríamos el mejor *hit* de A. Estos resultados se tabulan para cada genoma y se seleccionan sólo los genes cuya comparación es recíproca e unívoca. Este método es mejor que el blast unidireccional.

El segundo paso conceptual es sencillo e implica ampliar las comparaciones cruzadas a todos los genomas que quiero analizar haciendo un *blast* de todos contra todos. Estos resultados son más difíciles de tabular pero permiten identificar parálogos y ortólogos en un contexto filogenético personalizado. Este es el punto de partida para la identificación de ortólogos *de novo*.

A partir de aquí los distintos pipelines difieren en cuanto a los algoritmos que usan para tabular los resultados e inferir ortólogos. En general se utiliza un algoritmo de *cluster* para organizar los genes de todos los genomas en grupos ortólogos. Acto seguido se suelen realizar reconstrucciones filogenéticas de cada cluster ortólogo para refinar la identificación de  parálogos. Para entendernos, podemos decir que hacen una identificación de ortólogos *de novo* o *a posteriori*. 

Este método es el más completo a cualquier escala filogenética, y en principio es el que mas ortólogos podrá identificar. Partiendo de los ortólogos identificados se pueden usar secuencias de nucleótidos, que normalmente solo contienen exones (*transcripts*) o de aminoácidos. Un poco a ojo, las secuencias de nucleótidos se pueden utilizar en filogenias hasta a nivel de familia y quizás incluso orden, las secuencias de aminoácidos permiten realizar filogenias a niveles taxonómicos mayores hasta nivel de Clase, a partir de donde su uso comienza a ser problemático.

Su mayor desventaja es que tiende a recuperar pocos ortólogos, especialmente de copia única cuando los genomas no son suficientemente buenos, bien porque contengan secuencias contaminantes, bien porque estén fragmentados, algo habitual cuando tenemos un cierto grado de poliploidia en el genoma.

#### 5.2.4. Usando bases de datos externas como referencia.

Una tercera opción sería usar una base de datos externa como referencia. La comparación con las bases de datos del NCBI o Swissprot son un paso rutinario para la anotación funcional, y aunque los resultados se podrían reutilizar en un contexto filogenómico no se suele hacer. Hay otras bases de datos dedicadas a la sistematización de proteínas ortólogas. Estas proveen una información global que puede ser utilizada para decidir *a priori* que genes ortólogos buscar en cada genoma. Estas bases de datos son demasiado completas y complejas desde un punto de vista taxonómico, lo que las hace difíciles de usar.

Para poder identificar genes ortólogos útiles para su estudio filogenómico, habría que acotar un contexto filogenentico y filtrar los gene interesantes.

El primer intento de hacer algo semejante fue el *Core Eukaryotic gene mapping approach* ([CEGMA]( http://korflab.ucdavis.edu/datasets/cegma/)) que contenía genes eucarióticos básicos para la función celular que aparecen en todos los genomas, que son ortólogos y que suelen ser de copia única. En paralelo a la [defunción de CEGMA] (http://www.acgt.me/blog/2015/5/18/goodbye-cegma-hello-busco) apareció [BUSCO](https://busco.ezlab.org)(Benchmarking Universal Single-Copy Orthologs). BUSCO nace con la idea de asistir la identificación de genes en genomas de especies que no son modelo. Para ello el primer paso es identificar un set de genes conocidos y conservados en genomas que aún no han sido anotados. Para dotar el análisis de un contexto taxonómico, han procesado las base de datos OrthoMCL seleccionando genes ortólogos de copia única que están representados en un grupo taxonómico específico> Entre ellos, cortesia de [Jason Stajich](http://lab.stajich.org/home/people/jason-stajich/) hay varias categorías de hongos.

Además de posibilitar la anotación de genomas de especies alejadas de los modelos más habituales, BUSCO es útil para analizar la cobertura génica y la calidad de un ensamblaje genómico. Como añadido, también permite identificar cientos o miles de genes ortólogos que pertenecen a una categoría taxonómica concreta y evaluar si son de copia única o no, permitiendo definir los genes ortólogos que queremos usar *a priori*.

La ventaja principal de BUSCO es que es un proceso muy rápido, y sobre todas las cosas que proporciona un filtrado taxonómico de los genes presentes en un genoma. Esto es, que teniendo un genoma mediocre, como por ejemplo un metagenoma de liquen con sus hongos, algas, bacterias y la grasa del bocata del que lo recolectó, Busco sólo identificara los genes semejantes a aquellos especificados para el grupo taxonómico que hayamos elegido. Cuanto más pequeña sea la categoría que usemos, mayor será el numero de ortólogos identificables, y menor el numero de genes foráneos que aparezcan en el dataset. 

Busco no es todo ventajas, tiene limitaciones importantes. La capacidad de identificar ortólogos en un genoma es proporcional al grado de similitud con la base de datos utilizada, y hay grupos de hongos que son extremadamente divergentes. También es habitual encontrar genes ortólogos de copia única (llamémoslos BUSCOs) duplicados. A medida que ampliemos la cobertura filogenética de nuestro estudio, el numero de ortólogos comunes a todas las muestras será menor. En un dataset incluyendo los más o menos 1700 genomas de hongos que hay disponibles en Genbank, no hemos identificado ningún ortólogo presente en copia única en todas las muestras, y muy pocos BUSCOs de los incluidos en el dataset de hongos están presentes en mas de la mitad de los genomas.

Por otro lado BUSCo usa augustus para identificar genes. Es un método magnifico pero no esta lo suficientemente optimizado para algunos genomas y puede devolvernos secuencias proteicas poco realistas.

Busco funciona bien a niveles taxonómicos entre género y Clase. A nivel de División podemos encontrarnos con una proporción de loci incompletos demasiado alta. De igual modo que cualquiera de los métodos anteriores basados en la identificación de genes ortólogos, se puede usar BUSCO para obtener datasets de nucleótidos y de proteínas, aunque si el objetivo es trabajar con alineamientos de aminoácidos quizás sea conveniente hacer una identificación de genes mas exhaustiva antes de usar BUSCO.
El cuerpo principal de este curso es implementar un *pipeline* basado en BUSCO.

### 5.3. ¡Esto no funciona! ¿qué hacemos? (División, Reino, *Tree of life*)

A partir de la categoría de División, generar una reconstrucción filogenómica como tenemos en mente no es factible. Los métodos basados en alinear secuencias de aminoácidos o nucleótidos no son utilizables, pues habitualmente el ruido supera de largo cualquier tipo de información contenida en las matrices de datos. En este caso se prefiere utilizar métodos *alignment free* como alternativa. Básicamente se trata de obtener una medida de similitud entre genomas y hacer árboles de distancias. Si encima anotamos el soporte estadístico de la topología usando bootstrapping el método seria ya espectacular.

*Distancia basada en estructura del proteoma*

En bacteriología es bastante habitual encontrar árboles filogenéticos basados en distancias genómicas. Las bacterias tienen genomas muy pequeños que se deshacen rápido de aquellas enzimas implicadas en vías metabólicas que no les interesan, y tienden a obtener genes por transferencia horizontal. El contenido genómico tiene una importancia funcional, pero también filogenética. Así, tabulando los genes presentes en cada genoma (presencia/ausencia o 0 copias,1 copia,+1 copia) se puede hacer una reconstrucción filogenómica del dominio Eubacteria bastante sólida. Esta metodología no es habitual en hongos pero la vamos a probar en el último ejercicio práctico.

*Distancia basada en oligómeros*
Un grupo de métodos emergentes se basan en la descomposición del genoma en pequeños fragmentos de tamaño fijo. En general yo los llamo k-meros que es el término que se usa para secuencias de nucleótidos. Para secuencias de aminoácidos se suele hablar de *features* pero yo quiero enfatizar que es la misma idea. Simplificando, lo que se hace es partir de un proteoma, segmentarlo en todos los grupos de k aminoácidos consecutivos posibles; con solapamiento, claro está. 

A partir de esta descomposición se mide la frecuencia con que aparece cada K-mero en el proteoma. A partir de aquí hay dos opciones metodológicas. Si usamos un valor de k pequeño (k=5) el número de secuencias posibles pequeño. De este modo podemos obtener una matriz de frecuencias bastante compacta que usar para calcular una matriz de distancias. Si usamos un valor de k mas alto (k=20) el número de secuencias 20-mericas posibles es inmensa, pero podemos eliminar de cada genoma aquellos *features* que estén poco representados y elaborar una base de datos más compacta. Después de pueden cruzar las bases de datos (habitualmente son *hash tables*) de composición de *features* de todos los genomas, lo que nos da una idea importante de la similitud composicional del proteoma en global y nos permite generar una matriz de datos a usar con fines filogenómicos. Este tipo de métodos se ha usado en hongos recientemente ([Choi & Kim 2017](https://www.pnas.org/content/114/35/9391)) utilizando un método llamado [FFP](https://github.com/jaejinchoi/FFP). En esta misma línea cabe también mencionar el software [ProtSpaM](https://github.com/jschellh/ProtSpaM).

Este tipo de métodos también se puede usar con secuencias de nucleótidos, aunque en este caso hay que tener en cuenta que una secuencia y su complemento deben ser agrupadas juntas. Tienen muchas aplicaciones potenciales, que se salen del propósito de este curso. Os añado [este review] (https://academic.oup.com/gigascience/article/7/12/giy125/5140149) metodológico por puro vicio. En mi opinión, estos métodos serán el futuro del DNA-barcoding.

## 6. Métodos de reconstrucción filogenética

Como punto de partida hay que recordar una serie de conceptos relevantes para entender qué son y cómo funcionan los métodos de reconstrucción filogenética. Aunque si por la razón que sea sientes que necesitas un tratamiento sistemático te recomiendo que empieces por “The Phylogenetic Handbook” editado por Lemey et al. (2009).

En términos generales, el problema de la inferencia de árboles filogenéticos no es más que un problema estadístico. Más o menos refinados, ponderados, iterados, usando modelos implícitos o explícitos, ajustando la topología más probable a la vista de los datos o la probabilidad de los datos dado un modelo, todos los métodos de reconstrucción filogenética se pueden encuadrar de manera general dentro de los métodos matemáticos de cluster jerárquico. Todos ellos tienen como objetivo organizar los datos en un grafo dicótomo (árbol) que nosotros interpretamos como hipótesis de relación evolutiva entre las especies/alelos/genes que introducimos en la matriz de datos. 

El punto de partida común casi todas las implementaciones de análisis filogenético es obtener una matriz de caracteres que nos permita evaluar la similitud entre las distintas observaciones o especies. En el caso de caracteres genéticos las secuencias de nucleótidos o de aminoácidos necesitan alinearse, de manera que los caracteres a comparar sean homólogos, o al menos hayamos maximizando la probabilidad de que los caracteres agrupados en loci sean homólogos. Esto se hace mediante métodos de alineamiento múltiple de secuencias, y su descripción detallada también la podéis encontrar en el manual al que me he referido anteriormente.
 
Los métodos más sencillos de inferencia filogenética realizan la inferencia de la topología en dos pasos. Primero utilizan un modelo evolutivo probabilístico para estimar la distancia o la disimilitud entre observaciones. Basándose en esas distancias se utilizan distintos algoritmos para calcular una topología ya sea usando métodos de cluster generales como UPGMA o diseñados específicamente para tratar matrices de datos genéticos como Neighbour-joining. Estos algoritmos obtienen el árbol más probable basado en los datos fijando un modelo de sustitución. Un caso especial son los métodos basados en parsimonia, que interpretan las sustituciones desde un perspectiva eventual, y no utiliza modelos evolutivos en los que las distintas sustituciones son tratadas de manera explicita y dependiente del contexto.

El siguiente nivel de complejidad en los algoritmos de inferencia filogenética hace uso del concepto de Verosimilitud o *Likelihood* desarrollado por Felsenstein en los años 80 y 90 del siglo pasado y evalúa la probabilidad de obtener los datos a la luz de una topología y un modelo de sustitución impuesto. Primero usa una matriz de distancias para optimizar la parametrización del modelo y obtener una topología de partida, y la optimiza de modo iterativo hasta obtener el árbol más verosímil, que maximiza la probabilidad de los datos dado un modelo y una topología. Este tipo de aproximación se denomina *Maximum likelihood*.

Dado que estamos optimizando la probabilidad de los datos, evaluar la solidez de la topología requiere modificar los datos de partida. Para obtener el soporte estadístico de cada topología se recurre al bootstrapping. Se generan  matrices de datos randomizadas en las que las posiciones genéticas se introducen con repetición en un alineamiento igual de largo que el original y se optimiza la probabilidad de cada set de datos simulado. Al final se recurre a un método de consenso para evaluar en cuántos de los árboles simulados se encuentra cada partición y esto genera unos valores de soporte estadístico.

El último nivel de complejidad pasa por utilizar métodos de optimización bayesiana, en concreto cadenas de Markov (*Metropolis coupled markov chain Montecarlo*). En estos se lleva a cabo un proceso parecido al de ML, pero topología y parametrización del modelo se optimizan conjuntamente. La optimización Bayesiana tiene grandes ventajas sobre los métodos de ML. Primero no es tan dependiente del punto de partida (el árbol UPGMA por ejemplo), segundo al asumir en la cadena cambios a peor y no solo a seleccionar la mayor verosimilitud, es capaz de evitar óptimos locales mejor y es capaz de explorar el espacio paramétrico de manera más exhaustiva. Además la evaluación del soporte estadístico parte de árboles basados en obtener una distribución de árboles en principio equiprobables basados en los datos reales y no en un constructo artificial con pseudodatos como se hace con el bootstrapping.

4. Reloj Molecular

5. Árboles multigénicos y árboles de especies

Por ahora solo hemos hablado de cómo calcular arboles de genes. Cuando solo se cuenta con un locus y un espécimen por especie se puede plantear que la topología del gen, si es neutral debería informar sobre la filogenia de las especies. Sabemos sin embargo que es importante utilizar multiples líneas de evidencia para poder obtener una topología que sea verdaderamente representativa de la del nivel especifico y no solo la historia evolutiva de cada gen. Sin embargo integrar multiples líneas de evidencia (genes) es complicado.

Los métodos mas tradicionales son los llamados de supermatriz y de superarbol (supermatrix and supertree). Para calcular un árbol de especies basado en una supermatriz se concatenan todos los alineamientos en una sola matriz de datos y se calcula una única topología. Este método funciona a escalas evolutivas muy amplias, donde domina la deriva génica. A pesar de ello se considera que la topología media que produce no es precisa. A pesar de ello se sigue utilizando y es legitimo sus uso cuando se incorporan genes de compartimentos celulares donde no haya recombinación sexual (genomas de bacterias, mitocondrias, cloroplastos… virus)

Una segunda opción es calcular los arboles de cada gen independientemente y tratar de combinarlos en una sola topología. Un método de este tipo es usar arboles consenso, pero estos requieren que todos los arboles tengan el mismo numero de terminales. Cuando no es así el método se complica y es lo que se denominan superarboles. Los métodos para calcular superarboles suelen ser lentos y poco satisfactorios, aunque en la actualidad hay varias implementaciones utilizables. 

Con una filosofía diferente, pero también cercana a la de los superarboles están los métodos de reconciliación. Estos son mas flexibles y descomponen las topologías de los arboles de genes para integrarlas en un árbol de especies compendio *summary*, que habitualmente permite integrar múltiples alelos por cada especie. Hay muchos ejemplos de este tipo de métodos. Algunos como Astral descomponen las topologías en quartetes e infieren una compendio mas o menos complejo. Otros se basan en el *multispecies coalescent* como BEST o *starBeast. Estos últimos son casi exclusivamente métodos bayesianos.

A caballo entre los métodos de consenso están los algoritmos que compuatn redes consenso como los implementados en dendroscope.

6. Cálculo del soporte topológico

7. Limitaciones computacionales 

Debido a las limitaciones humanas y computacionales, el análisis de un gran número de loci requiere una serie de simplificaciones y compromisos que dependen en gran medida del tipo de plataforma de secuenciación, de la cobertura genómica y del propósito del estudio. Los métodos bayesianos, que incorporan modelos muy refinados para estimar parámetros poblacionales, comparar hipótesis, coestimar arboles de genes y de especies y para delimitar especies filogenéticas no se adaptan bien al inmenso volumen que suponen los datos genómicos. Por eso se suelen utilizar métodos basados en Maxima verosimilitud (ML).

Hay cosas que hay que entender antes de llevar a cabo un estudio. Lo primero es como se hace la paralelización. Cualquier método basado en *likelihood* paraleliza la inferencia separando el alineamiento en fragmentos sobre los que calcular la probabilidad. Cuando la matriz de datos es muy grande y el numero de particiones pequeño los datos a manejar por cada proceso paralelo son demasiado grandes. Si usamos demasiadas particiones, con modelos de sustitución diferentes, el numero de parámetros y de procesos paralelos también causara problemas graves. Por eso tratar el dataset concatenando genes sin mas suele acabar consumiendo muy por encima de los 200GB de memoria RAM y el ananlisis suele quedarse a medias. Calcular arboles de genes por separado se puede considerar como un modo de hacer paralelización trivial, y usa muchos menos recursos.

El segundo problema es que la mayoría de métodos están limitados por el numero de secuencias mas que por el numero de loci. Los requerimientos computacionales aumentan linealmente con el numero de loci, pero de manera exponencial con el numero de muestras. En mi experiencia el limite para un árbol de un solo gen esta en unas 1100 secuencias. Llegados a ese punto los grados de libertad son tan grandes que la topología se vuelve inestable y no es correcta. Hay métodos como fasttree que usan simplificaciones que permiten incorporar mas secuencias, pero siempre a costa de una menor credibilidad de la topología.

Calcular una filogenia con 300+ genes y las 1700 especies de hongos que hay secuenciadas parece una ideaza. Pero la realidad es que implica saturar un cluster entero durante un mes. Además las secuencias de aminoácidos son más lentas de analizar. Y al final los arboles son terribles.

## 7. Tutorial I. Pipeline filogenómico basado en BUSCO y un poquito a pedal.

En este tutorial implementaremos un *pipeline* filogenómico basado en la aplicación BUSCO v 3.0 (Simão et al. 2015)  <https://busco.ezlab.org> para automatizar la identificación de genes ortólogos. El *pipeline* en sí es algo naïve y bastante manual. Aunque su automatización sería fácil de implementar, está pensado para entender la sucesión de métodos paso a paso, de manera que pueda servir como base para modificar otros *pipelines* e implementar un métodos más personalizados.

Todos los archivos necesarios se encuentran en mi repositorio de Github. Por eso lo primero que debemos hacer es elegir una carpeta donde trabajar y clonar el repositorio:

```{bash}
git clone https://github.com/ferninfm/Fungal_phylogenomics
```

Como hemos comentado con anterioridad, BUSCO es un programa desarrollado con dos objetivos principales, posibilitar la anotación *de novo* de genomas de organismos no modelo previamente y para evaluar la calidad de un genoma ensamblado usando su cobertura genómica, es decir que porcentaje de los genes esperados son identificables. Para ello, BUSCO utiliza un set de genes ortólogos de copia única que son los que busca en el genoma a analizar. Estos genes ortólogos se encuentran definidos como perfiles HMM, obtenidos a través del uso de Modelos ocultos de Markov (HMM, Eddy 1998) para distintos niveles taxonómicos. Debido a su versatilidad BUSCO fue rápidamente reutilizado para fines más allá de su propósito inicial. En nuestro caso, BUSCO automatiza varios de los pasos necesarios para obtener un dataset filogenómico desde cero: primero utiliza *augustus* (Stanke et al. 2006) como algoritmo de predicción de genes, que al fin y al cabo es la base de métodos de predicción de genes más complejos, y segundo *HMMER* (Mistry et al. 2013) para comparar los genes estimados con la base de datos de ortólogos de copia única.

Sus virtudes son al mismo tiempo sus mayores desventajas. Cuando se usan secuencias de nucleótidos el sesgo es menor, pero para utilizar pipeline mas maduro se debería partir de genes estimados usando un procesos iterativo mas complejo (maker3 o funannotate). Por otro lado se podría  optimizar la captura de genes ortólogos desarrollando bases de datos mas especificas para el grupo taxonómico que estamos estudiando. Un *setup* similar se puede encontrar en el estudio filogenómico de Saccharomycotina publicado por Shen et al. (2016) o el de Parmeliaceos de Pizarro et al. (2018).

**Atención propuesta!** En el repositorio he dejado un ejemplo de HMM así como un par de publicaciones explicativas de lo que son Hidden Markov Models (HMMs, Eddy 1998). El archivo de cada HMM proporciona información estadística sobre la secuencia de aminoácidos de cada grupo ortólogo. Están alineados y proporcionan un consenso estadístico flexible que permite capturar mayor variabilidad y más rápido que una búsqueda directa como Blast.

![Esquema del pipeline basado en BUSCO](https://github.com/ferninfm/Fungal_phylogenomics/blob/master/pipeline_1.png)

### 7.1. Pasos preliminares
Para reducir el tiempo de computación y hacer el curso un poco más dinámico he decidido realizar varios pasos de antemano.

#### 7.1.1 Ensamblar los genomas
Para este ejercicio contamos con nueve genomas pertenecientes al género *Caloplaca* (Teloschistaceae) obtenidas en el marco del proyecto Hiperdiversidad en simbiosis fúngicas extremotolerantes ([FWF P26359](http://ferninfm.github.io/Hyperdiversity_project_webpage)). Aunque bastante completos son versiones inacabadas cuya versión final está en proceso de publicación. Por cautela no os he dado las referencias concretas ni el nombre. Los números de entrada de genbank serán añadidos a este documento en el futuro. Además de esos nueve genomas también he incluido como referencia la version 1.1 del genoma de *Xanthoria Parietina* que se puede encontrar aquí  (<a>https://genome.jgi.doe.gov/Xanpa2/Xanpa2.home.html</a>)

Las librerías genómicas originales fueron preparadas usando TruSeq de Illumina, en su mayoría sin PCR. Las librerías fueron secuenciadas usando dos lanes de un Illumina HiSeq, usando lecturas pareadas (paired reads) de 200 pares de bases. El tamaño del *insert* medio es de 500 pares de bases. Los genomas fueron ensamblados usando [Spades](http://cab.spbu.ru/software/spades/).

Los genomas de partida están ya ensamblados. El genoma X1 proviene de un cultivo axénico mientras que los demás provienen de metagenomas y han sido limpiados usando BUSCO, un script propio semejante a blobology (Shen et al. 2016) usando augustus, diamond (Buchfink, Xie, and Huson 2015) y MEGAN (Huson, Mitra, and Ruscheweyh 2011). Los archivos están comprimidos entro de la carpeta 01_data, aunque como he dicho no vamos a usarlos directamente. El primer paso implicaría descomprimirlos para poder ser analizados. Antes de nada ve al directorio raíz en donde hayas instalado este documento, para eso has de hacer uso del comando cd que has aprendido al inicio de este curso. Seguidamente debemos descomprimir los genomas.
```{}
# Cambiar al directorio de datos

cd 01_data

# Descomprimir los datos

tar -xvzf ./genomes.tar.gz

# Despues de observar si los archivos están correctos usando
# los comandos head, tail o more. Después volver al directorio raíz

cd ..
```
#### 7.1.2. Ejecutar BUSCO
Antes de ejecutar BUSCO hay que elegir un método para hacerlo. Podemos haber instalado BUSCO de modo nativo en nuestro ordenador. Este método es el más habitual y requiere de haber instalado los programas de los que BUSCO depende para su funcionamiento. Mantener la estabilidad de las dependencias constituye un problema en muchos programas bioinformáticos, y no es extraño que programas dejen de funcionar tras actualizar el sistema o tras instalar una consola (shell) diferente. Para evitar estos problemas hay cada vez una mayor tendencia a usar los programas bioinformáticos empaquetados en máquinas virtuales. De ellas, las máquinas virtuales propiamente dichas son las menos versátiles, pero las que más se adecuan al uso de ciertos programas que usan bases de datos externas. BUSCO proporciona una máquina virtual propia basada en ubuntu que se puede utilizar. Otra opción es incluir los programas necesarios en un contenedor de docker. Esta solución es en muchos casos la mejor, aunque no siempre los contenedores están listos para su uso y requieren invertir una importante cantidad de tiempo...

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
**Atención *mea culpa***: En realidad lo suyo sería haber usado la base de datos disponible para Pezizomycotina, que contiene casi el triple de BUSCOs. Sin embargo esta nos daría un volumen de resultados excesivo para este tutorial.
Las carpetas con los resultados del análisis de los BUSCOs han sido comprimidos en archivos gzip. Para poder usarlos debemos descomprimir los directorios de datos.
```{bash}
cd ../02_busco
gunzip *.gz
```
### 7.2. Evaluar busco
Lo primero que debemos hacer es evaluar el resultado de las busquedas de BUSCOs para poder inferir que  genomas incluir o no en el análisis. Para ello usamos el programa [multiqc](https://multiqc.info).
```{bash}
multiqc ./run*
```
**Atención pregunta:**: Hay alguna muestra más incompleta? A priori parece que alguna de ellas sea de peor calidad o más problemáticas?

### 7.3. Extraer los buscos

***EMPEZAMOS AQUI***

El paso siguiente es extraer las secuencias de los BUSCOs encontrados en los genomas y agregarlos en un archivo fasta por cada BUSCO sobre el que proseguir con el pipeline filogenético.
Hay multitud de ejemplos online para hace esto. Los scripts más antiguos procesan la tabla de resultados de cada *run* de BUSCO. Tienen ventajas y desventajas. Un ejemplo es el script *extract_buscos_pylo.py* distribuido en <a>https://gitlab.com/ezlab/busco_usecases/blob/master/phylogenomics/readme.md</a.

En nuestro caso, no nos interesa tener loci en los que el *outgroup* no este presente así que usamos el siguiente script. Es poco elegante, pero sirve para ilustrar que en ocasiones las soluciones simples están al alcance de la mano:

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
Así obtenemos un archivo fasta por BUSCO con las secuencias de los distintos genomas sin alinear. Podríamos proseguir así, pero los nombres de las secuencias son extremadamente largos y lo que es peor diferentes para cada locus, lo que generaría problemas a la hora de procesar los alineamientos y los genes. Para renombrar los genes y obtener una idea de cuan completos están los alineamientos de cada locus (BUSCO) he escrito el siguiente script. Se puede personalizar para usar nombres personalizados más complejos que los basados en los nombres preexistentes que he utilizado. Con este script quiero ilustrar como un lenguaje de programación como R puede ser utilizado como un programa independiente pasándole argumentos desde el terminal.
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
Este script requiere introducir un path absoluto y no relativo (./03_fastas), en realidad es algo que debo solucionar. Para abreviar el análisis vamos a seleccionar sólo aquellos loci presentes en todas las muestras. En este ejemplo lo podemos permitir.

```{bash}
Rscript rename_busco.r /home/fernando/genomics_course/new/new/03_fastas 10
```
Este script crea una serie de archivos en formato fasta llamados *renamed_*. Siguiendo el estándar de busco *.faa* se refiere a secuencias de aminoácidos y *.fna* de nucleótidos. Sólo los BUSCOS presentes en los 10 genomas van a ser incluidos aunque la decisión depende mucho de cada caso individual. Nosotros seguiremos a partir de aquí usando exclusivamente las secuencias de nucleótidos, pues nuestros organismos están filogenéticamente muy cerca. A nivel supra-familiar es más recomendable usar secuencias de aminoácidos, aunque quizás lo mejor (aunque difícil de automatizar) sería evaluar la alineabilidad de cada locus y usar el nivel más adecuado. De todos modos, Busco utiliza un método poco refinado (relativamente hablando) para anotar el genoma (identificar exones y proponer secuencias de proteínas). A un nivel superior sería mejor partir de anotaciones más completas y complejas para cada genoma como las proporcionadas por maker o funannotate.

**Atención sugerencia:**: Sabes utilizar R. Si no lo haces ya estás tardando… Si lo haces te recomiendo que eches un vistazo a como esta escrito para ser usado como un ejecutable independiente. Entiendes el código? Si no pregúntame.

### 7.4. Alinear los archivos fasta con MAFTT

Mafft es un programa de alineamiento múltiple de secuencias rápido y escalable. Yo en origen tendía a refinar el alineamiento con Muscle después, pero creo que es innecesario. Hay muchas otras alternativas para obtener alineamientos, algunas más complejas que refinan el alineamiento calculando arboles y corrigiendo o programas como trimal que permiten promediar los alineamientos generados usando distintos algoritmos. Este tipo de refinamientos pueden ser convenientes de cara a hacer un trabajo para publicar.

```{bash}
mkdir ./04_alignments
```
Guarda el script como run_mafft.sh usando por ejemplo nano…
```{bash}
nano run_mafft.sh
```
y pegando el siguiente script dentro de run_mafft
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
corre el script

```{bash}
sh run_mafft.sh
```

### 7.5. Refinar el alignment con trimal

[Trimal](https://github.com/scapella/trimal.git) (Capella-Gutierrez et al. 2009) es un programa desarrollado por el grupo de Toni Gabaldón. Para instalarlo lo mejor es clonar el repositorio de github <a>https://github.com/scapella/trimal.git</a>

Trimal es un programa magnifico capaz de realizar multitud de tareas y merecería un día entero probando distintos parámetros y aprendiendo su uso. En especial para el caso que nos ocupa, podríamos haber perfeccionado el pipeline usando múltiples programas para alinear nuestras secuencias y usar trimal para obtener un consenso. Por sacar una pega, trimal maneja de un modo extraño las direcciones de los archivos (*path*). Yo he optado por incluir un cambio de directorio en el script para evitar usar paths relativos. No deja de ser un truquillo simple que nos puede ayudar a salir del paso.

```{bash}
mkdir ./05_trimmed
```

Guarda el siguiente script como run_trimal.sh. Usa nano y pega el texto del script dentro.

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

Corremos el script con:

```{bash}
sh run_trimal.sh
```
**Atención Propuesta.** Échale un vistazo a los archivos producidos por trimal usando *more* con los archivos fasta y usando el navegador web con los archivos html.
**Atención Pregunta.** Los archivos html nos ofrecen la posibilidad de decidir si nos conviene usar secuencias de aminoácidos o de nucleótidos. Tu que opinas? .fna o .faa?

### 7.6. Realizar reconstrucción filogenética para cada locus

Para la reconstrucción filogenética usamos *Maximum Likelihood* (ML) y no un método bayesiano. Tampoco usamos parsimonia. Esto es una decisión metodológica debida sobre todo al tiempo de computación necesario y a los menores requerimientos computacionales de este tipo de métodologías. Esto no significa que no puedan usarse métodos bayesianos, pero si es cierto que su usabilidad depende en gran medida de las necesidades y los plazos de cada experimento.

Hay varios métodos de reconstrucción filogenética que permiten realizar análisis de ML aproximados y rápidos. Los tres más frecuentes en la bibliografía son [fasttree]( http://www.microbesonline.org/fasttree/), [raxml]( https://cme.h-its.org/exelixis/software.html) e [iqtree]( http://www.iqtree.org). Me he decantado por este ultimo porque es un programa menos habitual que los otros dos, y que sin embargo proporciona grandes ventajas metodológicas. Entre otras cosas iqtree es capaz de leer casi cualquier formato (fasta, phyllip, nexus) y en lugar de optimizar el uso de un modelo de sustitución GTR+Gamma como RaxML, incorpora un módulo de selección automatizado del modelo de sustitución basado en AIC, AICc o BIC (este es el default).

La relevancia del modelo de sustitución es un tema complicado y hay muchos científicos partidarios de invertir meses en hacerlo lo más perfeccionista posible y al mismo tiempo una serie de trabajos que sugieren que tiene una influencia menor en el proceso de inferencia filogenética, llegando a entorpecerlo. Me refiero por ejemplo a este [trabajo](**PAPER CRITICA MODEL TEST**).

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

## 7.7. Calcular un árbol consenso (*mayority rule*) con iqtree.

La obtención de un consenso se puede hacer muy fácilmente con iqtree, ya que en principio utiliza el mismo algoritmo que al obtener un consenso de los arboles obtenidos usando *bootstrap*. Pero vamos a ver…

```{}
iqtree -con all_trees.tre
```

**Atención Pregunta!** ¿Funciona? Si funciona puedes continuar al punto 7.8. Si no funciona ¿Porqué no funciona?

**Atención Problemilla!** En muchas ocasiones, por un error o porque elegimos incluir todos los árboles que contienen un porcentaje de especies. O porque hemos usado un programa para limpiar las topologías los consensos no funcionan. Necesitan que todos los árboles tengan los mismos terminales (especies).

Esto no es siempre realista, puesto que a medida que nos vayamos alejando filogenéticamente e incluyendo especies más distantes el numero de loci que busco será capaz de identificar en todas las especies será menor. 

Una opción es calcular el consenso solo con los arboles completos y usar los otros para anotar el soporte de la topología. Para ello podemos vamos a usar el paquete estadistico *ape* implementado en R. Es un interfaz más intuitivo que los que nos proporcionan otros lenguajes como python o perl más enfocados a la automatización de procesos que al análisis exploratorio de datos.

Para hacer esto deberéis abrir R simplemente escribiendo R en el terminal. Despues podreis correr el siguiente script paso a paso.

```{r}
library (ape)
#
#Si vienes de 7.7.
#
trees<-read.tree("./all_trees.tre")
#
#Si vienes de 7.10
#
trees<-read.tree("./all_trees_filtered.tre ")
#
#
# Se nos han colado secuencias repetidas?
#
foo<-sapply(trees,`[[`,"tip.label")
foo
#
# Tienen todos los árboles el mismo número de especies (tips)
#
foo<-unlist(sapply(foo,length))
table(foo)
#
# Subset y escribir sólo los árboles completos
#
write.trees(trees[unlist(sapply(sapply(trees,`[[`,"tip.label"),length))==10],"menos_trees.tre")
quit()
```

Ahora podríamos calcular el consenso con menos árboles

```{}
iqtree -con menos_trees.tre
```

## 7.8. Anotar el soporte estadístico de la topología.

Para anotar el soporte nodal de la topología vamos a usa el método propuesto por [Salichos y Rokas (2013)](http://www.ncbi.nlm.nih.gov/pubmed/23657258) en el que se calculan los valores de *Internode Certainty* (IC) y *Tree Certainty* (TC). El método se describe con más profundidad en [este trabajo](http://mbe.oxfordjournals.org/content/early/2014/02/07/molbev.msu061.abstractkeytype=ref&ijkey =I65FuGNx0HzR2Ow). Aunque su  implementación en RAXML (version>=8.2.0) difiere ligeramente de lo publicado al permitir el uso de set de árboles incompletos como se discute [aquí]( http://dx.doi.org/10.1101/022053). 

Primero deberemos volcar todos los arboles obtenidos en iqtree (o raxml) anotados usando bootstrap en un solo archivo. Esto lo hemos hecho anteriormente.

Después correremos el programa usando el siguiente script:

```{}
raxmlHPC -L MRE -z all_trees.tre -m GTRCAT -n T1
```

También podremos calcular el árbol consenso usando una búsqueda exhaustiva con:

```{}
raxmlHPC -L MRE -z all_trees.tre -m GTRCAT -n T1
```

Podemos usar el consenso que hemos obtenido en iqtree o una topología obtenida concatenando loci (supermatriz) usando el siguiente método

```{}
raxmlHPC -f i -t all_trees.con -z all_trees.tre -m GTRCAT -n T4
```

## 7.9. Visualización de arboles con iTol.

El final del proceso de estimar una filogenia es generar un gráfico que tenga buen aspecto para publicar. Hay muchas opciones posibles, pero quiero llamaros la atención sobre [iTol](https://itol.embl.de). Es una implementación online que produce gráficos de una calidad excepcional y que permite incorporar matrices de datos para enriquecer la visualización. En un contexto filogenómico donde queremos incorporar datos de anotación funcional sobre una filogenia, este programa puede ser un buen salvavidas.

Simplemente abrid la página web e importad vuestros árboles. La introducción de datos se puede hacer desde excel (previo pago) o a mano. Yo suelo usar R para obtener una tabla, con el nombre de cada taxon y una paleta de colores personalizada en RGB. Pero tiene poco misterio.

### 7.10. Limpiar de artefactos las filogenias usando Treeshrink

Uno de los problemas más habituales que nos podemos encontrar es la inclusión de secuencias que por la razón que sea acumulan mayor número de caracteres diferenciales de los esperable. Esto puede ser real, pero a menudo es debido a errores en el alineamiento o a la presencia de contaminantes o parálogos no identificados. Este es un paso importante a la hora de discutir la corrección de las inferencias filogenéticas llevadas a cabo anteriormente, aunque en muchos trabajos no se usa un método de filtrado. Treeshrink es un programa relativamente nuevo que automatiza el filtrado *a posteriori* de las topologías.

```{}
python /usr/local/src/TreeShrink/run_treeshrink.py -t all_trees.tre -o all_trees_filtered.tre
```

**Atención Pregunta!** Cuantas veces se ha eliminado cada especie?

**Atención Propuesta!** Como afecta esto al soporte estadístico? y al consenso? Puedes volver atrás y repetir los pasos anteriores (7.7 y 7.8) pero sobre el archivo *all_trees_filtered.tre*. Veras que tendrás problemas. Otra opción es seguir adelante y usar Astral con el mismo propósito.

### 7.11. Astral para obtener un árbol compendio.

En sentido estricto un consenso implica procesar árboles que contengan el mismo número de especies. Esto sólo es factible a niveles filogenéticos intermedios, pero a medida que nos desplazamos a nivel de familia u orden el número de genes ortólogos de copia única presentes en todos los genomas es cada vez menor. A nivel de división a penas hay genes ortólogos que estén presentes en todas las muestras. Para procesar árboles incompletos se requieren métodos de inferencia de superárboles. Los métodos para calcular superárboles fueron en los años noventa desterrados por los métodos haciendo uso de supermatrices, por ser farragosos de usar y lentos. Aún así, hay varios métodos modernos que permiten calcular superárboles, aunque normalmente no los llaman así.

Un ejemplo es [Astral III](https://github.com/smirarab/ASTRAL), que bajo el constructo de que es un árbol de coalescente, lo que hace es estimar una topología de especies basada en la descomposición en quartetes.

Primero calcularemos un árbol de especies compendio (*summary*) basado en la topología más verosímil (ML) de cada gen.

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

En nuestro caso el árbol de especies y el de genes contienen el mismo número de entradas. En casos en que tengamos más de un genoma por especie, es donde Astral se vuelve importante al permitir incorporar polimorfismo intraespecífico (Es decir estima un árbol de especies en sentido estricto).

**Atención Propuesta.** Échale un vistazo al manual de astral.

### 7.12. Redes consenso en Dendroscope.

Una alternativa interesante es usar el programa [dendroscope](http://dendroscope.org) para obtener redes filogenéticas consenso. Esto será útil tanto para detectar problemas como para discutir hibridación o introgresión si este fuese el caso. Además el algoritmo de z-closure permite también trabajar con árboles incompletos (supernetwork).

Para trabajar simplemente tenéis que ejecutar dendroscope en la máquina virtual o el ordenador que tengáis disponible e importar el archivo all_trees.tre. La interfáz gráfica es sencilla y autoexplicativa. Tiene enormes cantidades de opciones para explorar. El manual está [aquí](https://ab.inf.uni-tuebingen.de/data/software/dendroscope3/download/manual.pdf).

### 7.13. Comparar topologías usando distancias Robinson-Foulds.

Para terminar quiero recordar que se pueden calcular distancias entre topologías usando el método de Robinson-Foulds. Estudiar las diferencias entre arboles de genes puede servir para patrones de coherencia o incoherencia a través del genoma o para detectar topologías no comunes.

Primero puedes usar iqtree para esto.

```{}
iqtree -t all_trees.tre -rf_all
```

Despues puedes abrir R y probar a interpretar la distribución de distancias. En R podríamos también añadir otros datos como distancia o familia de proteínas para observar si hay diferencias evolutivas entre distintos clusters funcionales o regiones del genoma.

```{r}
rf<-read.table("menos_trees.tre.rfdist",skip=1,row.names=1)
rf<-as.dist(rf)
plot(rf)
library(vegan)
pcoa_rf<-prcomp(rf)
ordiplot(pcoa_rf)
```
<!-- # Si te ves con ganas 
/home/fernando/genomics_course/new/new/02_Busco/run_X1scaffoldsfiltered/full_table_X1scaffoldsfiltered.tsv
--->

## 8. Tutorial II.  Un pipeline usando detección de ortólogos a posteriori.

En este tutorial vamos a utilizar un pipeline filogenómico llamado [Orthofinder](https://github.com/davidemms/OrthoFinder). Comparado con el pipeline que acabamos de desarrollar, Orthofinder está muy empaquetado y automatizado. Es contraste con nuestro pipeline, tiene como objetivo principal la extracción de genes ortólogos *de novo* o *a posteriori*. Para esto utiliza un algoritmo de *cluster* primero con el que obtiene grupos de ortólogos, los que previa reconstrucción filogenética son filtrados para seleccionar genes ortólogos.

Además vamos a utilizar este pipeline como introducción a docker <https://www.docker.com>. Docker es un sistema para encapsular un sistema operativo y los ejecutables de un programa de nuestro interés en un contenedor único que puede ser utilizado en cualquier ordenador y cualquier sistema operativo. Docker a menudo soluciona problemas de dependencias –las librerías de Perl suelen ser el horror– y de conflictos de versiones, lo que permite tener un sistema estable y permanente. Tiene sin embargo ciertas desventajas respecto a configurar los programas de modo nativo, en especial cuando se requiere usar bases de datos de manera intensiva. Hay varios repositorios de contenedores de docker dedicados a la bioinformática, entre los cuales el punto de partida quizás sea [biocontainers](https://github.com/BioContainers/containers).

**Atención pregunta:** Este pipeline no es adecuado para el dataset que estamos utilizando, que es el mismo que en el ejercicio anterior. Sabrías decirme por qué?

**Atención recomendación:** Echaos un vistazo a la descripción del pipeline en su pagina web. Se entiende muy bien.

### 8.1. Pasos preliminares (Solo para que los sepáis)

Este pipeline parte de secuencias de proteínas y no de aminoácidos. Requiere por tanto un paso previo de predicción de genes. Para ello he usado funannotate, del que hablaré en el siguiente tutorial. He instalado funannotate usando un ambiente de anaconda siguiendo las instrucciones del manual. 

No hay que olvidarse de olvidarse de exportar las siguientes variables ambientales.
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
Primero usamos *sort* para renombrar los *contigs* con nombres más compatibles con el formato soportado por genbank. He dejado los PATHS absolutos de mi maquina (/home/fernando/genomics_course/new/new/01_data/) para evitar confusiones cuando decidáis usar funannotate vosotros.

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
Predicción de genes usando todos los niveles de evidencia disponibles (ESTs, etc.) En nuestro caso no tenemos y usamos las proteinas de Xanthoria parietina como única evidencia.

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

### 8.3. Ahora si usamos el pipeline Orthofinder

Lo primero que haremos será instalar el container de docker donde está instalado el pipeline orthofinder.

```{bash}

docker pull cmonjeau/orthofinder

```
Seguidamente correremos el programa usando el siguente script modificado para vuestro caso particular podeis usar en lugar de VUESTRACARPETA el path completo o ${pwd} para hacer que se corra en la carpeta donde estais

```{bash}
mkdir ./02_results
docker run -it --rm -v "VUESTRACARPETA/02_orthofinder/01_data":/input cmonjeau/orthofinder orthofinder.py -f /input -t 10 -a 10 -S diamond
docker run -it --rm -v "VUESTRACARPETA/02_orthofinder/02_results":/input cmonjeau/orthofinder trees_for_orthogroups.py /input/ -t 7
```

Orthofinder tiene varias opciones de alineamiento y reconstrucción filogenética, etc. Hemos utilizado las opciones por defecto con diamond y dendroblast pues son los más rápidos. En general, [diamond](https://github.com/bbuchfink/diamond) se ha convertido en el nuevo standard para realizar alineaminetos locales, sustituyendo a BLAST que es miles de veces más lento. Hay algunas dudas sobre si los valores reflejados por diamond son equiparables a los de BLAST original, pero el hecho es que la aceleración que supone ha desterrado el uso de BLAST para comparaciones de aminoácido vs. aminoácido (blastp) y nucleótido vs aminoácido (blastx) en la mayoría de los pipelines más modernos.

```{bash}
orthofinder -f \
 -t 30 \
 -a 30 \
 -M dendroblast \
 -S diamond \
 -A mafft \
 -p ./tmp
````

**Atención pregunta:** Repásate los archivos de resultados de Orthofinder. Que ocurre con el árbol consenso? Porqué son tan cortas las ramas? (si desactivamos la longitud de las ramas en la visualización del árbol filogenético verás que están ahi). Fíjate en cuantos ortólogos de copia única ha identificado. No te resulta extraño que sean tan pocos? Fíjate en los arboles de la mayoría de grupos ortólogos? por qué tienen tan pocas secuencias? Que puede estar ocurriendo?

## 9. Tutorial III.  Introducción a funannotate

En este tutorial quiero daros a conocer las posibilidades del programa de anotación funcional funannotate en el contexto de la filogenómica. El tutorial lo desarrollare mas o menos dependiendo de el tiempo que tengamos y como estemos trabajando.

### 9.1. Pasos preliminares

Los primeros pasos de anotación los añadí como pasos preliminares para orthofinder. Hasta ahí es equivalente, aunque más refinado, a los que hace augustus dentro de BUSCO. De hecho podríamos partir de las secuencias de genes identificadas usando funannotate como entrada para BUSCO (para hacer filogenómica).

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

**Atención, nota mental!** La anotación completa de un genoma fúngico (ca. 10.000 proteínas) en funannotate requiere unas 24 horas. Yo he usado una maquina con 32 núcleos lógicos, de ahí que haya usado en los scripts los *flags* -c 30 o --cpus 30. Ten en cuenta que esto depende mucho de tu máquina.

### 9.2. Usar la comparación genómica incorporada en funannotate

```{bash}
funannotate outgroup xanthoria_parietina.ascomycota
```

```{bash}
funannotate compare -i X1_annotated  X2_annotated  X3_annotated  X4_annotated  X5_annotated  X6_annotated  X7_annotated  X8_annotated  X9_annotated --outgroup xanthoria_parietina.ascomycota
```

### 9.3. Resumen de los resultados de funannotate

Os he dejado los resultados de funannotate para que os los estudieis. Funannotate genera una enorme cantidad de archivos que se pueden usar para distintos propósitos, pero además nos da una serie de archivos web que contienen todos los datos resumidos. Abre el archivo index.html en tu navegador y a jugar.

**Atención Pregunta** ¿Como son los asemblies genómicos? ¿Difiern mcho en tamaño y fragmentación? ¿Cuáles son los mas fragmentados?

**Atención Pregunta** ¿Contienen todos el mismo numero de proteínas de las distintas familias? ¿Cuáles son los más divergentes?

### 9.4. Pequeña prueba de árbol filogenómico basado en la composición del funcional proteoma.

Vamos a partir de los resultados de la identificación de familias de proteínas [Pfam]( http://pfam.xfam.org) para elaborar un árbol. En nuestro caso bueno no va a ser pero se puede hacer. Vamos a por ello.

Abrid R y escribid
```{r}
pfam<-read.table("VUESTRACARPETA/funannotate_compare/pfam/pfam.results.csv",sep=",",quote="\"",row.names=1,header=TRUE)
library(ape)
plot(as.phylo(hclust(dist(t(as.matrix(pfam[,1:9]))))))
```

Se parece la topología a nuestros consensos? Hay algún genoma divergente? Que significan las familias identificadas como sobre-representadas en ese genoma?

### 9.5. Llegamos al final.

**Atención Pregunta** ¡Maldición! ¡Esto calcula un árbol filogenómico el solo! Pero ¿que opinas? ¿Los valores de soporte de la topología son altos o bajos? ¿Que significan?¿Crees que se puede mejorar usando lo que ya hemos aprendido?

Algo magnifico de funannotate es que genera todo tipo de resultados. Entre otras cosas si buscáis la carpeta */funannotate_compare/prot_orth/* veréis que funannotate también identifica genes ortólogos basándose en el mejor Blast reciproco. He quitado la mayoría de archivos intermedios para reducir el espacio ocupado en disco, pero he dejado los del genoma X1. Los resultados tabulados están en la carpeta */funannotate_compare/orthology/* donde hay un archivo archivo llamado all_transcripts.fa (que he comprimido) y una tabla llamada orthology_groups.tsv. Esta tabla y el archivo de transcripts contienen todo lo que necesitamos para hacer un pipeline filogenómico refinado como nos gusta. 


**Atención, trabajo de fin de master** Abre R y abre la tabal usando read.table(), carga el paquete ape y abre los transcripts con read.dna(). ¿Te ves capaz de elegir los ortólogos presentes en todas las especies y exportarlos con un loop de for () y la función write.dna()? Querido compañero, querida compañera, creo que llego el momento de que escribas tu propio pipeline filogenómico como tu quieras. 

<!--#### Uso de COGs para calcular filogenias
o
#### Modulo incluido en funanotate, problemas y alternativas.
o
#### Proceder igual que en el tutorial III
o
#### Mapear la información en el genóma
-->

## References

Abadi, Shiran, Dana Azouri, Tal Pupko, and Itay Mayrose. 2019. “Model Selection May Not Be a Mandatory Step for Phylogeny Reconstruction.” Nature Communications 10 (1). https://doi.org/10.1038/s41467-019-08822-w.

Buchfink, B., Xie, C., & Huson, D. H. (2015). Fast and sensitive protein alignment using DIAMOND. Nat Meth, 12(1), 59–60. Retrieved from http://dx.doi.org/10.1038/nmeth.3176

Capella-Gutiérrez, S., Silla-Martínez, J. M., & Gabaldón, T. (2009). trimAl: A tool for automated alignment trimming in large-scale phylogenetic analyses. Bioinformatics, 25(15), 1972–1973. https://doi.org/10.1093/bioinformatics/btp348

Catchen, J. M. (2013). Stacks: an analysis tool set for population genomics. Molecular Ecology, 22(11), 3124–3140. https://doi.org/10.1111/mec.12354.Stacks

Catchen, J. M., Amores, A., Hohenlohe, P., Cresko, W., & Postlethwait, J. H. (2011). Stacks : Building and Genotyping Loci De Novo From Short-Read Sequences. G3 Genes|Genomes|Genetics, 1(3), 171–182. https://doi.org/10.1534/g3.111.000240

Choi, JaeJin, and Sung-Hou Kim. 2017. “A Genome Tree of Life for the Fungi Kingdom.” Proceedings of the National Academy of Sciences 114 (35): 201711939. https://doi.org/10.1073/pnas.1711939114.

Darling, A. E., Mau, B., & Perna, N. T. (2010). Progressivemauve: Multiple genome alignment with gene gain, loss and rearrangement. PLoS ONE, 5(6). https://doi.org/10.1371/journal.pone.0011147

De Wit, P., Pespeni, M. H., Ladner, J. T., Barshis, D. J., Seneca, F., Jaris, H., … Palumbi, S. R. (2012). The simple fool’s guide to population genomics via RNA-Seq: an introduction to high-throughput sequencing data analysis. Molecular Ecology Resources, 12(6), 1058–1067. https://doi.org/10.1111/1755-0998.12003

Dewey, C. N. (2011). Positional orthology: Putting genomic evolutionary relationships into context. Briefings in Bioinformatics, 12(5), 401–412. https://doi.org/10.1093/bib/bbr040

Eaton, D. a R. (2014). PyRAD: assembly of de novo RADseq loci for phylogenetic analyses. Bioinformatics, 30, 1844–1849. https://doi.org/10.1093/bioinformatics/btu121

Eddy, S. R. (1998). Profile hidden Markov models. Bioinformatics, 14(9), 755–763. https://doi.org/btb114 [pii]

Eisen, J. A. (1998). Phylogenomics : Improving Functional Predictions for Uncharacterized Genes by Evolutionary ? Analysis Phylogenomics : Improving Functional Predictions for Uncharacterized Genes by Evolutionary Analysis. Genome Research, (1997), 163–167. https://doi.org/10.1101/gr.8.3.163

Fitch WM. (1970) Distinguishing homologous from analogous proteins. Systematic Zoology, 19:99-113.

Fitch WM. (2000) Homology a personal view on some of the problems. Trends on Genetics, 16:227-231

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

(Eisen 1998; Langmead and Salzberg 2012; Kuzniar et al. 2008; Dewey 2011; O’Brien and Stanyon 1999; O’Brien et al. 1999; Sjolander 2004; Choi and Kim 2017; Huerta-Cepas et al. 2016; Marthey et al. 2008; Zhang et al. 2018; Pizarro et al. 2018; Jiao et al. 2011; Mai and Mirarab 2018; Philippe et al. 2005; Krogh 1998; Salichos and Rokas 2011; Shen, Salichos, and Rokas 2016; Kominek et al. 2019; Moon et al. 2019; Labella et al. 2019; Abadi et al. 2019; Yang 2001; Yang et al. 2000; Roy 2009; Mauro et al. 2019; Mckain and Johnson 2018)

Dewey, Colin N. 2011. “Positional Orthology: Putting Genomic Evolutionary Relationships into Context.” Briefings in Bioinformatics 12 (5): 401–12. https://doi.org/10.1093/bib/bbr040.
Eisen, Jonathan A. 1998. “Phylogenomics : Improving Functional Predictions for Uncharacterized Genes by Evolutionary ? Analysis Phylogenomics : Improving Functional Predictions for Uncharacterized Genes by Evolutionary Analysis.” Genome Research, no. 1997: 163–167. https://doi.org/10.1101/gr.8.3.163.
Huerta-Cepas, Jaime, Damian Szklarczyk, Kristoffer Forslund, Helen Cook, Davide Heller, Mathias C. Walter, Thomas Rattei, et al. 2016. “EGGNOG 4.5: A Hierarchical Orthology Framework with Improved Functional Annotations for Eukaryotic, Prokaryotic and Viral Sequences.” Nucleic Acids Research 44 (D1): D286–93. https://doi.org/10.1093/nar/gkv1248.
Jiao, Yuannian, Norman J. Wickett, Saravanaraj Ayyampalayam, André S. Chanderbali, Lena Landherr, Paula E. Ralph, Lynn P. Tomsho, et al. 2011. “Ancestral Polyploidy in Seed Plants and Angiosperms.” Nature 473 (7345): 97–100. https://doi.org/10.1038/nature09916.
Kominek, Jacek, Drew T. Doering, Dana A. Opulente, Xing Xing Shen, Xiaofan Zhou, Jeremy DeVirgilio, Amanda B. Hulfachor, et al. 2019. “Eukaryotic Acquisition of a Bacterial Operon.” Cell 176 (6): 1356-1366.e10. https://doi.org/10.1016/j.cell.2019.01.034.
Krogh, Anders. 1998. “Chapter 4 An Introduction to Hidden Markov Models for Biological Sequences.” New Comprehensive Biochemistry 32 (C): 45–63. https://doi.org/10.1016/S0167-7306(08)60461-5.
Kuzniar, Arnold, Roeland C H J van Ham, Sándor Pongor, and Jack A M Leunissen. 2008. “The Quest for Orthologs: Finding the Corresponding Gene across Genomes.” Trends in Genetics 24 (11): 539–51. https://doi.org/10.1016/j.tig.2008.08.009.
Labella, Abigail L., Dana A. Opulente, Jacob L. Steenwyk, Chris Todd Hittinger, and Antonis Rokas. 2019. “Variation and Selection on Codon Usage Bias across an Entire Subphylum Abigail.” BioRxiv. https://doi.org/: http://dx.doi.org/10.1101/608042. The.
Langmead, Ben, and Steven L Salzberg. 2012. “Fast Gapped-Read Alignment with Bowtie 2.” Nature Methods 9 (4): 357–59. https://doi.org/10.1038/nmeth.1923.
Mai, Uyen, and Siavash Mirarab. 2018. “TreeShrink: Fast and Accurate Detection of Outlier Long Branches in Collections of Phylogenetic Trees.” BMC Genomics 19 (Suppl 5). https://doi.org/10.1186/s12864-018-4620-2.
Marthey, Sylvain, Gabriela Aguileta, François Rodolphe, Annie Gendrault, Tatiana Giraud, Elisabeth Fournier, Manuela Lopez-Villavicencio, Angélique Gautier, Marc Henri Lebrun, and Hélène Chiapello. 2008. “FUNYBASE: A FUNgal PhYlogenomic DataBASE.” BMC Bioinformatics 9 (i): 1–10. https://doi.org/10.1186/1471-2105-9-456.
Mauro, Diego San, David Wilcockson, Mark Wilkinson, Davide Pisani, Mary J O Connell, and Christopher J Creevey. 2019. “Inadvertent Paralog Inclusion Drives Artifactual Topologies and Timetree Estimates in Phylogenomics.” https://doi.org/10.1093/molbev/msz067.
Mckain, Michael R, and Matthew G Johnson. 2018. “Practical Considerations for Plant Phylogenomics” 6 (3): 1–15. https://doi.org/10.1002/aps3.1038.
Moon, Jiyun M., John A. Capra, Patrick Abbot, and Antonis Rokas. 2019. “Signatures of Recent Positive Selection in Enhancers across 41 Human Tissues.” BioRxiv. https://doi.org/http://dx.doi.org/10.1101/534461.
O’Brien, Stephen J, Marilyn Menotti-Raymond, William J Murphy, William G Nash, Johannes Wienberg, Roscoe Stanyon, Neal G Copeland, Nancy A Jenkins, James E Womack, and Jennifer A Marshall Graves. 1999. “The Promise of Comparative Genomics in Mammals.” Science 286 (5439): 458 LP – 481. https://doi.org/10.1126/science.286.5439.458.
O’Brien, Stephen J, and Roscoe Stanyon. 1999. “Ancestral Primate Viewed.” Nature 402 (6760): 365–66. https://doi.org/10.1038/46450.
Philippe, Hervé, Yan Zhou, Henner Brinkmann, Nicolas Rodrigue, and Frédéric Delsuc. 2005. “Heterotachy and Long-Branch Attraction in Phylogenetics.” BMC Evolutionary Biology 5: 1–8. https://doi.org/10.1186/1471-2148-5-50.
Pizarro, David, Pradeep K. Divakar, Felix Grewe, Steven D. Leavitt, Jen Pan Huang, Francesco Dal Grande, Imke Schmitt, Mats Wedin, Ana Crespo, and H. Thorsten Lumbsch. 2018. “Phylogenomic Analysis of 2556 Single-Copy Protein-Coding Genes Resolves Most Evolutionary Relationships for the Major Clades in the Most Diverse Group of Lichen-Forming Fungi.” Fungal Diversity 92 (1): 31–41. https://doi.org/10.1007/s13225-018-0407-7.
Roy, Scott William. 2009. “Phylogenomics : Gene Duplication , Unrecognized Paralogy and Outgroup Choice” 4 (2). https://doi.org/10.1371/journal.pone.0004568.
Salichos, Leonidas, and Antonis Rokas. 2011. “Evaluating Ortholog Prediction Algorithms in a Yeast Model Clade.” PLoS ONE 6 (4). https://doi.org/10.1371/journal.pone.0018755.
Shen, Xing Xing, Leonidas Salichos, and Antonis Rokas. 2016. “A Genome-Scale Investigation of How Sequence, Function, and Tree-Based Gene Properties Influence Phylogenetic Inference.” Genome Biology and Evolution 8 (8): 2565–80. https://doi.org/10.1093/gbe/evw179.
Sjolander, Kimmen. 2004. “Phylogenomic Inference of Protein Molecular Function: Advances and Challenges.” Bioinformatics (Oxford, England) 20 (2): 170–79.
Yang, Ziheng. 2001. “Codon-Substitution Models for Detecting Molecular Adaptation at Individual Sites Along Specific Lineages,” 908–17.
Yang, Ziheng, Rasmus Nielsen, Nick Goldman, and Anne-mette Krabbe Pedersen. 2000. “Codon-Substitution Models for Heterogeneous Selection Pressure at Amino Acid Sites.”
Zhang, Chao, Maryam Rabiee, Erfan Sayyari, and Siavash Mirarab. 2018. “ASTRAL-III: Polynomial Time Species Tree Reconstruction from Partially Resolved Gene Trees.” BMC Bioinformatics 19 (Suppl 6): 15–30. https://doi.org/10.1186/s12859-018-2129-y.
-->
