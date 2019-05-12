---
title: "Curso de Genómica de Hongos: Filogenómica"
author: "Fernando Fernandez Mendoza"
date: "18/5/2019"
output:
  html_document: default
  word_document: default
  bibliography: bibliography.bib
---

# 1. Introducción

El término filogenómica fue acuñado por Eisen 1998 @ para referirse al estudio de EISEN1 
A common goal to all phylogenomic surveys is to provide a reconstruction of the evolutionary history of a taxonomic group using genome-wide data. In some cases reconstructing a phylogeny may be the ultimate goal of the experiment, but more often phylogenies provide a framework to interpret population dynamics, especiation events or provide the background signal to interpret comparative genomic trends.
Qué es filogenómica?

The protocols commonly used in phylogenetic surveys to select, sanger-sequence, align and estimate a phylogenetic tree with a set of neutral loci are very standarized. In phylogenomics, however there is no single approach or consensus protocol that can be invoqued as a consensus. In fact, due to human and computational limitations, analyzing a high number of loci requieres a series of simplifications and compromises that largely depend on the type of sequencing plattform, of genomic coverage and the purpuse of the survey. The philosophy and methods used for every step are extremely dependent on the type of data acquired and the purpose of the survey. For instance highly refined Bayesian methods of model testing, coestimation of phylogeny and population parameters or even making simple phylogenetic inferences are not available for all types of data and often they do not scale well to cope with genomic datasets extremely limiting their use.
In this practical session we provide a succint introduction to different methods used to generate phylogenomic data matrices, and focus on one of them, making use of use of orthology based gene sets which provides a simple and straightforward method that can be used to address multiple background questions and provides a good entry-level approach to phylogenomics. The practical parts are highlighted 


Ideas generales sobre lo que signifcan los caracteres genómicos
Que se puede hacer y no
Conceptos Genoma
Ortologos

Conceptos de resonstruccion filogenética

# 2. Objetivos del curso
Punto de partida

# 3. Partes de un pipeline: Propuestas metodológicas
No hay una sola aproximación a realizar un estudio filogenómico. Es altamente dependiente del tipod de datos que tengamos

En terminos generales:
## 1. Assembly
## 2. Annotation
## 3. Comparison to database
## 4. Clustering of gene sequences
## 5. Subsetting of gene sequences (prior)
## 6. Alignment of sequences
## 7. Alignmnet refinement
## 8. Tree building
## 9. Subseting of gene sequences (post)
## 10. Cleaning topologies
## 11. Consensus building

Propuestas metodológicas
Tenemos el de freebayes 
Tenemos el de busco
tenemos el de phylogenoma
Tenemos el de funnannotate

# 4. Ejemplo práctico I. Un pipeline filogenómico un poquito a pedal

En este tutorial implementaremos un pequeño pipeline filogenómico basado en el uso de la aplicación BUSCO <a>https://busco.ezlab.org</a> para automatizar la identificación de génes ortólogos.

FIGURA CON EL PIPELINE

## 4.1. Pasos preliminares
Para hacer el curso un poco más dinámico he dicidido realizar varios pasos preliminares de antemano.
### 4.1.1 Ensamblar los genomas
Para este ejercicio contamos con nueve genomas pertenecientes al género *Caloplaca* (Teloschistaceae) obtenidas en el marco del proyecto Hiperdiversidad en symbiosis fungicas poliextremotolerantes (FWF P26359, <a>http://ferninfm.github.io/Hyperdiversity_project_webpage</a>. Aunque bastante completos son versiones interminadas cuya version final está en proceso de publicación. Por cautela no os he dado las referencias concretas ni el nombre. Los accession numbers serán añadidos en el futuro. Además de esos nueve genómas también he incluido como referencia la version 1.1 del genóma de *Xanthoria Parietina* que se puede encontar aquí  (<a>https://genome.jgi.doe.gov/Xanpa2/Xanpa2.home.html</a>)

Los librerias genímicas originales fueron preparadas usando TrueSeq de Illumina, en su mayoria sin PCR. Las liberiras fueron secuenciados usando dos lineas de un Illumina HiSeq, usando lecturas pareadas (paired reads) de 200 pares de bases. El tamaño del insert medio es de 350 pares de bases. LOs genomas fueron ensamblados usando Spades (CITE).

Los genomas de partida están ya ensamblados y están comprimidos en el archivo *genomes.tar.gz* dentro de la carpeta 01_data. El primer paso implicaría descomprimirlos para poder ser analizados. Antes de nada ve al directorio raíz en donde hayas instalado este documento, para eso has de hacer uso del comando cd que has aprendido al inicio de este curso. Seguidamente debemos descomprimir los genomas.
```{}
# Cambiar al directorio de datos

cd 01_data

# Descomprimir los datos

tar -xvzf ./genomes.tar.gz

# Despues de observar si los archivos estan correctos usando
# los comandos head, tail o more. Después volver al directorio raíz

cd ..
```
### 4.1.2. Correr BUSCO
Antes de correr busco hay que elegir un método para hacerlo. Podemos haber instalado BUSCO de modo nativo en nuestro ordenador. Este método es el más habitual y requiere de haber instalado los programas de los que BUSCO depende para su funcionamiento. Mantener la estabilidad de las dependencias constituye un problema en muchos programas bioinformaticos, y no es extraño que programas dejen de funcionar tras actualizar el sistema o tras instalar una consola (shell) diferente. Para evitar estos problemas hay cada vez una mayor tendencia a usar los programas bioinformaticos empaquetados en máquinas virtuales. De ellas, las máquinas virtuales propiamente dichas son las menos versátiles, pero las que más se adecuan al uso de ciertos programas que usan bases de datos externas. BUSCO proporciona una máquina virtual propia basada en ubuntu que se puede utilizar. Otra opción es incluir los programas necesarios en un contenedor de docker. Esta solucion es en muchos casos la mejor, aunque no siempre los contenedores están listos para su uso y requieren invertir una importante cantidad de tiempo...

Una vez descomprimidos los genomas son analizados usando el siguiente script
Lo primero sort y luego mask


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
En realida podría haber usado la base de datos de pezizomycotina, pero esta nos daria un volumen de resultados no utilizable en el curso de este tutorial.
Las carpetas con los resultados del análisis de los BUSCOs han sido comprimidos en archivos gzip. Para poder usarlos debemos descomprimir los directorios de datos.
```{bash}
cd ../02_busco
gunzip *.gz
```
## 4.2. Evaluar busco
Lo primero que debemos hacer es evaluar el resultado de las busquedas de BUSCOs para poder inferir que  genomas incluir  o no muestras que estén muy incompletas o cuyos ensamblajes presenten claros problemas.
```{bash}
multiqc ./run*
```
## 4.3. Extraer los buscos
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

## 4.4. Alinear los archivos fasta con MAFTT

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

## 4.5. Refinar el alignment con trimal
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

## 4.6. Realizar reconstruccion filogenética para cada locus iqtree
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

## 4.7. Concatenar todos los loci y hacer un análisis supermatriz iqtree

```{}
mkdir ./07_final
cat ./06_iqtree/*.treefile >> ./07_final/all_trees.tre
```
## 4.8. Calcular un arbol consenso (*mayority rule*) con iqtree
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

## 4.9. Anotar el soporte estadístico de la topología
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

## 4.11. Visualización de arboles con iTol.

```{}
```

## 4.11. Obtener consensos cuando el dataset es incompleto y también visualizar incertidumbre en forma de redes con dendroscope.

```{}
```

## 4.12. Comparar topologías.

```{}
```

# 5. Tutorial II.  Un pipeline más filogenémico usando funannotate

# 6. Tutorial II.  Un pipeline usando proteinas

## 6.1. Pasos preliminares
### 6.1.1. Correr funannotate
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

## 6.2. Usar la comparación genómica incorporada en funannotate
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

## Example III. Departing from proteomes
https://github.com/davidemms/OrthoFinder
#
#
#
docker pull cmonjeau/orthofinder
#
#
mkdir ./02_results
docker run -it --rm -v "/home/fernando/genomics_course/new/new/02_orthofinder/01_data":/input cmonjeau/orthofinder orthofinder.py -f /input -t 10 -a 10 -S diamond
docker run -it --rm -v "/home/fernando/genomics_course/new/new/02_orthofinder/02_results":/input cmonjeau/orthofinder trees_for_orthogroups.py /input/ -t 7
#
#
#
orthofinder -f \
 -t 30 \
 -a 30 \
 -M dendroblast \
 -S diamond \
 -A mafft \
 -p ./tmp
## Integrate functional annotations
```{r}
pfam<-read.table("/Users/ferninfm/Desktop/eraseme/funannotate_compare/pfam/pfam.results.csv",sep=",",quote="\"",row.names=1,header=TRUE)
library(ape)
plot(as.phylo(hclust(dist(t(as.matrix(pfam[,1:9]))))))
```