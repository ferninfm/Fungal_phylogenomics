---
title: 'Kurso de genomika fungoj: Phylogenomika'
author: "Fernando Fernandez Mendoza"
date: "18/5/2019"
output:
  html_document: default
  csl: pnas.csl
  bibliography: bibliography.bib
  word_document: default
---

# Kurso de genomika fungoj: Phylogenomika

Fernando Fernandez Mendoza

---

## 1. Introducción

El término filogenómica fue acuñado de manera casi contemporánea para referirse a dos disciplinas científicas diferentes pero que comparten un transfondo metodológico común: el uso de técnicas de reconstrucción filogenética para análizar datos genómicos. Eisen en el año 1998 fué el primero en utílizar el término para referirse al uso de modelos phylogenéticos en la anotación funcional de secuencias protéicas. Por otro lado @OBrien1999 introduce por primera vez el término para referirse al uso de datos genómicos en la reconstrucción de la historia evolutiva de un grupo taxonómico. Ambas disciplinas difieren en cuanto a métodos, objetivos e incluso en el nivel de organización biológica que estudian, pero juntas proporcionan la base conceptual para la genómica comparativa y evolutiva.

El proposito común a todos los estudios filogenéticos es la inferencia de las relaciónes evolutivas entre espécies. Hay muchos estudios cuyo único objetivo es la obtención de una hipótesis evolutiva, aunque a menudo también se usa la reconstrucción filogenética como base  para modelar procesos más complejos como patrones de diversificación, dinámicas poblacionales, evolución de caracteres, filogeografía, etc. Bajo una visión restringida, la filogenómica se podría entender como una extensión de la filogenetica tradicional  para usar ya no muchos loci, sino todos los posibles. Sus premisas y objetivos serían comunes, y sus métodos se habrían reajustado para poder afrontar el nuevo tipo y volumen de datos. Sin embargo, los métodos modernos de secuenciación masiva no sólo proporcionan un enorme número de caracteres genéticos, sino que permiten realizar una descripción detallada de la estructura de los genómas, así como de la función de cada uno de los genes que los conforman. La filogenómica pues, permite estudiar tanto la evolución de las especies como la de sus genómas, y proporciona un marco histótrico para la interpretación de los mecanismos ecológicos y moleculares asociados con el proceso evolutivo.

En definitiva, la filogenómica no es sólo filogenias, sino que proporciona una puerta de acceso al estudio comparativo de los genómas y su evolución molecular. Aunque ello requiere una importante inversión mucho mayor en recursos económicos y humanos.

## 2. Objetivos del curso

El objetivo del curso es proporcionar una visión general sobre las necesidades metodológicas que tienen los estúdios filogenómicos. El curso se compone de tres ejercicios prácticos y varias pausas de lectura. Dado que los tiempos de computación son relativamente elevados, es importante no sólo copiar y pegar para que salga el ejercicio, sino entender lo que estámos haciendo.

La primera actividad es la principal y tiene como objeto desarrollar un ejemplo de *pipeline* filogenómico basado en BUSCO (<https://busco.ezlab.org>), sencillo y poco automatizado. El objetivo es (1) familiarizarse con el uso del terminal de UNIX, (2) desarrollar todos los pasos necesarios para obtener un dataset filogenómico a partir de secuencias genómicas (de nucleótidos) y (3) desarrollar todos los pasos conducentes a la obtención de un árbol filogenómico.

La segunda actividad se centra en utilizar un pipeline filogenómico partiendo de secuencias de proteínas y en aprender a usar containers de docker.

La tercera actividad se centra en las posibilidades abiertas por el modulo de genómica comparativa del pipeline de anotación funcional funannotate (<https://funannotate.readthedocs.io/en/latest/>).

## 3. Partes de un pipeline: Propuestas metodológicas
---

Mientras que los protocolos utilizados en estudios filogenéticos están extremadamente estandarizados, en filogenómica no existe un enfoque único, una receta para todo que pueda considerarse como consenso. La filosofía y los métodos utilizados para cada estudio dependen en gran medida del tipo de datos adquiridos, su calidad y cobertura genómica y la extensión filogenética o el propósito del estudio.

El primer paso es la obtención de un set de datos que puedan ser análizados. La obtención de una matriz filogenética es sencilla, pues los loci a estudira están preseleccionados y sólo hace falta secuenciarlos, alinear sus secuencias, y usarlas para estimar uno (o más) árboles filogenéticos usando un conjunto de loci neutrales.

Cuando el objeto de estudio son organismos filogenéticamente muy cercanos, 
De hecho, debido a las limitaciones humanas y computacionales, el análisis de un gran número de loci requiere una serie de simplificaciones y compromisos que dependen en gran medida del tipo de plataforma de secuenciación, de la cobertura genómica y del propósito de la encuesta. 



a encuesta. Por ejemplo, no se dispone de métodos bayesianos altamente refinados para la prueba de modelos, la coestimación de la filogenia y los parámetros poblacionales, o incluso para hacer inferencias filogenéticas sencillas para todos los tipos de datos y, a menudo, no se adaptan bien a los conjuntos de datos genómicos que limitan su uso.

En esta sesión práctica, proporcionamos una introducción sucinta a los diferentes métodos utilizados para generar matrices de datos filogenómicos, y nos centramos en uno de ellos, haciendo uso del uso de conjuntos de genes basados ​​en ortología que proporciona un método simple y directo que puede utilizarse para abordar múltiples antecedentes. cuestiona y proporciona un buen enfoque de nivel de entrada a la filogenómica. Se resaltan las partes prácticas.



4.2 Assembling a phylogenomic data matrix
The student question quoted above on the top of the page may seem naïve, but reflects the first problem one encounters when attempting to reconstruct a phylogeny from a set of genomic samples. As of today, several handbooks CITE CITE provide a good digest guide to phylogenomics, and several pipelines have been published or made available online. Few years back, the student from the quote would have started by googleing “phylogenomics” and “genome alignment” and would have spent a couple of days trying to figure out how to use the output of MAUVE (Darling, Mau, and Perna 2010), before assuming that having the contigs systematically sorted (Rissman et al. 2009) is nice, but that it was not the point at all.
However, it remains difficult to make well-informed decissions on the design of a phylogenomic survey. First, there is an important terminological gap between the disciplines of phylogenetic systematics and molecular genomics which is often difficult to bridge; the term phylogenomics itself is widely used in the literature in surveys using evolutionary methods of genome annotation CITE and not just extended phylogenetic surveys. Second, there is no single method to assemble a genome-wide phylogenetic data matrix, starting for the genome representation of the library itself. This generates an important deal of noise, as  highly impacting genomic surveys often deal with taxonomic groups other than fungi or algae, and as our neighbouring colleagues working on animals of plants usually engage in well-informed but highly opinionated digressions about their next project during cofee breaks feeding us up with sometimes inadequate information. Third, to complicate it even more, each manuscript uses a slightly different set of scripts or pipelines to atomatize the assembly of a data-matrix. Pipelines that are often developed with a particular target organism in mind, bacteria, animals, humans, fungi... and are not always transferable to other organisms, especially lichens, where lichenized-fungi, their photobionts, and all the complex biotic community forming the lichen system provide advantaghes and dissadvantages on their own.
4.4.1 DNA alignment based resequencing pipelines
The simplest way to assemble a datamatrix to be used in a population inference and tree-building framework, is to use an alignment-based genotyping approach. Such approaches profit from having a reference genome to which raw reads are mapped, often using a short-read alignment tool as BWA (Li and Durbin 2009) or Bowtie (Langmead and Salzberg 2012). The resulting alignments are later processed using a variant calling method to call haplotype or SNP loci for each sample; general purpose methods of variant calling can be found in GATK (McKenna et al. 2010) –CombineGVCFs, GenotypeGVCFs–, samtools (Li et al. 2009) –mpileup– and other general purpose bioinformatic packages.

The usability of short-read alignment methods depends on the degree of similarity between target and reference genomes. They are widely used in resequencing experiments at infraspecific level or including closely related species within a genus, especially in surveys using reduced representation libraries. Obvious examples are the pipelines Stacks (Catchen 2013) and Pyrad (Eaton 2014) meant to process the different flavours of RADSeq/GBS datafiles, but RNASeq (De Wit et al. 2012) and poolseq (Schlötterer et al. 2014) data are processed similarly  It is worth mentioning that in some cases, the lack of a reference genome is overcome by assembling a transient reference library stacking short reads (Catchen et al. 2011), a case that is of limited usability in interpreting lichen metagenomic samples. A usable phylogenomic pipeline using an alignment to reference approach is RealPhy (Biozentrum Universität Basel n.d.) which was used for Rhizoplaca melanophthalma (Leavitt et al. 2016).

All these pipelines commented above, used for population or multispecies datasets have been developed to study organisms that have more complex genomes than fungi, like animals, especially humans and for vascular plants. In all of them the vegetative part of the life cycle is at least diploid, when not tetraploid or with even higher levels of ploidy. This has a strong influence on the type of data desired to retrieve as outcome. Some methods will provide a consensus phased genotype –a haplotype– although most methods are designed to call variants in the form of SNPs. As lichenologists, we depart from the presumption that the specimen we sequence is haploid, a presumption that causes significant base-calling uncertainty in sanger sequences of microlichens where apothecia are rutinarily used. From that perspective, it is tempting to understand SNPs as the same type of data one could get by stripping a multiple alignment from uninformative sites. However this is not exactly what SNPs are. Single Nucleotide Polymorphisms are biallelic loci, meant to cope with heerozygotic samples, and are extremely restrictive with regards to their evolutionary model, they must conform to an infinite sites model and fullfill a four allele rule. This means that in each site only two states are possible in the absence of recombination and that mutations only happen once in each site and that homoplasy (back mutation) is not possible. This pressumptions are not met in many cases in phylogenmic datasets, because the number of acceptable synonimous mutations is quite restricted in proteing coding regions and because selection and not only recombination may cause significant departures from that model. 
In programs as Stacks, all loci that do not fulfill these presumptions are systematically excluded from the analyses lsometimes leading to an important erosion in the informativenes of the dataset when the intention is building phylogeneies or coalescent reconstructions and not population assignments or traditional statistics. In addition, the data fromat exported in such pipelines is usually formated as it would for a diploid organism. These files used as they come in population genetics programs usually provide artificially low estimates of recombination and a wide clonality signal which may be missleading.
Drawbacks. Lack of information on the evolutionary history of individual genes. Further Heterozygosity filtering is necessary to ensure that the reference regions and the mapped reads are orthologous.

4.1.2 Annotation based pipelines and Orthology
A second approach to assemble a phylogenomic dataset makes use of the methods developed to estimate coding regions and protein sequences and models of protein evolution. In itself is closer to the original scope of phylogenomics (98) as addressed by early researchers.
Usually protein sequences are more conserved than their DNA counterparts and their evolution is easier to model using Hidden Markov chain models. In this case the choice of loci is not made by aligning DNA sequences but by Infering protein sequences from genomic assemblies and comparing them to a preexistent repository.
The most naive example of this kind of approach would be generating a database of target DNA sequences (ITS, Beta-tubuli, RPB1 etc) to which individual genome assemblies are blasted in order to extract the each targeted region from the assemblies, put them together and align them in a similar setup to the traditional phylogentic one. This simplistic approach works, and it is widespread in the literature, there is for instance an interesting paper including 20 nuclear loci of polar and brown bears that was published in Science in 2012. But again it is polar bears.
Using all loci extracted from a reference genome would also work but may fai in cases where genes are duplicated, or belong to transposable elements, etc....Still for taxa that are closely related to the one used as a reference it could work.
The next level of refinement would be to estimate orthology.
What is orthology and paralogy.
A simple setup best reciprocal blast hits. All protein coding genes... It gets problematic as the history of the genomes complicates for deeper phylogenetic levels.
4.1.3 Pipelines based on the use of precompiled sets of Orthologous genes.
The next level is use phylogenomic repositories containg orthologous gene sets in which the evolutionary pathways for each AA in the sequence are modeled using HMM. Global repositories as Ortho MCl etc are good for deep phylogenies but reduce the type of loci to be used to more conserved ones the more distant the relationship between the sample sin our experiment.
HMMER is used for searching sequence databases for sequence homologs, and for making sequence alignments. It implements methods using probabilistic models called profile hidden Markov models (profile HMMs).

However, this approach is scalable, and researchers have commenced developing themed sets of genes that tend to be single copy orthologs within a subset of organisms at a certain phylogenetic scale. Within the Busco pipeline originally intended to estimate genome completeness several gene sets are provided which contain different number of loci. 300 for fungi...3000 for Pezizomycotina.... Ocnsidering a genome consists of ca. 10.000 genes 1/3 is already a good number of sequence loci to use.
The developement of focus sets of orthologs, even including positional orthology (syntny) in the equation are clearly the simplest and more robust resource to produce phylogenomic datasets for a wider range of experiments and focal groups. For this reason this approach is the one we will succintly develop in the following toy pipeline
4.2 A phylogenomic pipeline
The somewhat naïve phylogenomic pipeline we propose makes use of the computational strategies implemented in the BUSCO v 3.0 (Simão et al. 2015) pipeline. BUSCO uses a repository of single copy orthologous genes defined by precompiled HMM profiles (Eddy 1998) to estimate gene-completeness of a genome assembly. Because BUSCO uses augustus (Stanke et al. 2006) for gene-prediction and HMMER (Mistry et al. 2013) for the identification of orthologs from a precompiled hmmer profile database, it covers three necessary steps in the developement of a phylogenomic pipeline. A more thorough pipeline would profit from a) using a more through iterative gene-prediction strategy, b) using a custom built taxon specific ortholog database and probaly a c) a further use of a phylogenetically explicit method of ortholog detection. A similar setup profitting from the use of BUSCO has been used in a large phylogenomic survey in Saccharomycotina (Shen et al. 2016) Fig. 1.

Figure 1: Pipeline used by
Sheen et al. 2017 (Shen et al. 2016).
4.2.1 Assement of gene-completeness with BUSCO
Task 1: Asses the gene completeness of a small genomic subset using busco.
1.	Go to the folder made for todays activities $ cd /genomics_course/day-4/
2.	Locate the busco pipeline in ./busco and the downloaded lineage specific databases in  ./busco/lineages.
3.	Decompress the lineage databases using tar –xvzf on each tar.gz file.
4.	Look for the folder containing .hmm profiles: a) How many BUSCOS does each database contain? b) Try to understand it the .hmm files by looking at it with more or a similar tool. NOTE: It shows a table with the probabilities for each aminoacid state for each position in the sequence.
5.	Let’s run BUSCO: Select one of the reduced assemblies found in  day-4/task_1
4.	Run BUSCO taking care to specify the correct path for the python script as well as for your input file, the lineages and where you want the output to be. 
$ python ../busco/scripts/run_BUSCO.py \
–i YOUR_SEQUENCE_FILE.fa \
-o OUTPUT_NAME \
-l ../busco/lineages/NAME_OF_LINEAGE -m geno
 
5.	Look at the output files. Several of them could be of use in phylogenomic pipeline, especially the aminoacid and nucleotide fasta files provided in the folder /single_copy_busco_sequences which would be easy to use downstream. Another file to take into account is the one named training_set_* which could be a good starting point for further gene-prediction and annotation pipelines. We will use the file named full_table_* downstream. It is both complete and intuitive, and serves multiple purposes that will be explained in task_2.
6.	Now... a) Are the assemblies complete? b) Are there a lot of duplicated BUSCOs? c) What could be the cause? d) Could Kmer-coverage suggest the presence of more fungi in the sample? e) Does the assembly require additional cleaning? f) Can this generate a problem downstream? g) Why is the parameter length smaller than the value of Start-End. The following table provides a simplified example.
#BUSCO_group	Status	Scaffold	Start	End	Bitscore	Length
BUSCOfEOG7CCC0Z	Complete	NODE_8_length_770894_cov_4.06215_ID_270532	553762	589411	1175.1	909
BUSCOfEOG73RBMM	Complete	NODE_8_length_770894_cov_4.06215_ID_270532	641463	652863	933.3	530
BUSCOfEOG7DVDN4	Complete	NODE_63_length_278098_cov_4.11132_ID_673671	94607	106102	713.1	448

Task 1b: Asses the gene completeness of a genomic draft using busco.
For the highly motivated among you, if your VM or local computer is working fast enough try repeating the same steps with a complete genomic draft of the ones found in folder ./task_1b.
a) How complete are they? b) Do they have a lot of duplicated BUSCOS? c) Do you observe notable differences in kmer-coverage between the scaffolds included in the genomic draft? again What does it mean? d) Does the assembly need further sanitation?
4.2.2 Parsing the BUSCO output for phylogenomics
Task_2: We developed a very simple R script to mine the output of BUSCO in order to produce a phylogenomic data matrix. In a well atomated pipeline it may be more reasonable to work with the fasta files per busco and genome provided by the program. We do however use the full_table_* file for several reasons. First in a preliminary survey, working with the full_table file allows us to a) use BUSCO in the sanitation of a preliminary assembly, in addition to a blobology-like (Shen et al. 2016) approach using augustus, diamond (Buchfink, Xie, and Huson 2015) and MEGAN (Huson, Mitra, and Ruscheweyh 2011), b) thus to manually exclude one of the duplicated BUSCOS that may be causing problems for preliminary exploration. Also, we are not departing from well-tested nor evidence-based protein predictions, so using scaffold coordinates allows us to c) include intronic regions, and d) modulate possible missinterpreted regions in the alignment step. Finally, it also serves to provide a simple example on how to work with tables and sequences in R.
To simplify the rest of the pipeline we provide a reduced full_table file and assembly for four Caloplaca specimens and part of the Xanthoria parietina genome as a reference.
1.	Go to folder ../task_2. Find the files to use, they are named coherently as x1-x4.fas and .txt
2.	Make the following directories (with mkdir) ./fastas ./alignments, and ./trees
3.	Process the files in R, append sequences to individual files per BUSCO. Notice the simple for loop.
for i in x1 x2 x3 x4 xanpa;
do
Rscript parse_busco.r ./input_files/${i}.txt \   ./input_files/${i}.fasta $i ./fastas/;
done
4.	At this stage we add a completion filter to include only BUSCOS present in all 5 samples. This is not necessary, and there is a tendency to include missing data in phylogenomic matrices as a better practice. However, BUSCOS found in too few samples and not pressent in the outgroup should be systematically excluded. Subsequently align each individual fasta file with mafft 
for FILE in ./fastas/*.*;
do
value=$(wc -l $FILE |  cut -d' ' -f1)
if [ $value -eq 10 ] # HERE THE FILTER
then
echo $value
echo $FILE
mafft --retree 2 --maxiterate 2 --adjustdirection --thread 2 $FILE > $PWD/alignments/${FILE##*/}
else
mv $FILE ./fastas/out/$FILE
fi
done

5.	Not today... At this stage we may want to refine the alignment using muscle, and potentially produce multiple alignments with different methods to calculate a consensus alignment or to use further in the –compareset option of trimal.
6.	Then we will trim the alignment using the software trimAl (Capella-Gutiérrez, Silla-Martínez, and Gabaldón 2009). You can find suggestions and a tutorial in http://trimal.cgenomics.org. First explore the alignment report for your files using the –sgt and –sident flags. An example to create a report file could be 
mkdir ./trimal_reports
for FILE in $PWD/alignments/*.*;
do
trimal -in $FILE -sgt >> ./trimal_reports/report.txt;
done 
7.	Then trim the alignment using an automated procedure, check the webpage and tutorials for details. We save an html alignment report and a phylip alignment file
mkdir ./refined
for FILE in $PWD/alignments/*.*;
do
s=${FILE##*/}
s=${s%.*}
trimal -in $FILE -automated1 -htmlout $PWD/trimal_reports/${s}.html
trimal -in $FILE -automated1 -phylip > $PWD/refined/${s}.phy
done
8.	Almost over we calculate single gene trees using raxML, do not forget to a) rename the lables that were reversed (look at the files mafft called some sequences_R_x...) and b) root the trees.

for FILE in $PWD/refined/*.phy
do
sed -i -e 's/^_R_//g' $FILE 
done
OK issue solved because it turns into a problem
mkdir ./trees
for FILE in $PWD/refined/*.phy
do
NAME=${FILE##*/}
NAME=${NAME%.*}
raxml -s $FILE -n $NAME -x 12345 -p 23456 -f a -# 100 -m GTRGAMMA -T 4 -o xanpa
mv ./RAxML_* ./trees/
done
9.	Finally we use RaxML to calculate a mayority rule consensus tree which we annotate with the Internode Certainty and Tree Certainty score (IC, ICA, TC, and TCA) proposed by Salichos and Rokas 

cat RAxML_bipartitionsBranchLabels.* > all_trees.tre
raxmlHPC -L MR -z all_trees.tre -m GTRCAT -n -T1
Additional task: Try to program two similar steps but using IQtree (Minh, Anh Thi Nguyen, and von Haeseler 2013) instead of RaxML, it can be slightly faster (Zhou et al. 2017) and it incorporates automated model-testing, which is a very interesting addition.
Additional task: Now try to wrap up all the latter steps into a single sequential script, pack it into a .sh file and try runnin it as a pipeline.
4.2.4 Single gene trees and consensus
It has become obvious that having a multiplicity of genes does not only provide information as a consensus for the whole genome. Different regions of the genome may have different histories and a consensus may not conform to a simplified ditichotomous structure as provided by a phylogenetic tree. A great tool to explore the phylogenetic signal contained at a whole genome level is the software dendroscope CITE, which provides a wide ranges of methods to estimate rooted networks for the further exploration of the phylogenetic signal encountered across loci.
Additional Task_3: Contains an additional set of 964 gene trees calculated from the same Caloplaca dataset. a) Use RaxMl to summarize them, b) Download and install Dendroscope and try to obtain further consensus representations.
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
