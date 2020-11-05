getwd()
dir()
ls()
library(ape)
library(Claddis)

# Example of DNA matrix
?read.dna  
test.dna<-read.dna("testDNA.txt",format="interleaved",as.character=TRUE)
str(test.dna)
head(test.dna)
rownames(test.dna)

# Example of Amoniacids (AA) matrix (same format as DNA matrix)
test.prot<-read.dna("testprotein.txt",format="interleaved",as.character=TRUE)
str(test.prot)
head(test.prot)
rownames(test.prot)

# Example of morphological matrix
# The multistate characters will have to be formated manually afterwards with a text editor
?read_nexus_matrix
morpho<-read_nexus_matrix("testmorph.nex")
str(morpho)
# The character matrix can be seen in
test.morph<-morpho$matrix_1$matrix
rownames(test.morph)
# Note that the missing character states appear as NA, we can edit that
test.morph[is.na(test.morph)]<-"?"
# The character gaps appear as a space, we can edit to make it -
test.morph[test.morph==""]<-"-"
# Finally we can also edit the polymorphisms
test.morph[test.morph=="0&1&2"]<-"(012)"

## Merge matrices and drop taxa missing data for some character partition ##

# Example 1:Merge DNA and AA matrices, dropping taxa without DNA data
ndna.prot<-match(rownames(test.dna),rownames(test.prot))
tdna.prot<-cbind(test.dna,test.prot[ndna.prot,])
head(tdna.prot)
tdna.prot[is.na(tdna.prot)]<-"?"

# Example 2: Merge morphology and DNA matrices, dropping taxa without morphology
nmorph.dna<-match(rownames(test.morph),rownames(test.dna))
tmorph.dna<-cbind(test.morph,test.dna[nmorph.dna,])
head(tmorph.dna)
tmorph.dna[is.na(tmorph.dna)]<-"?"

# Example 3: Merge morphology, DNA and AA keeping only the taxa with morphology
nmorph.dna.prot<-match(rownames(tmorph.dna),rownames(test.prot))
tmorph.dna.prot<-cbind(tmorph.dna,test.prot[nmorph.dna.prot,])
head(tmorph.dna.prot)
tmorph.dna.prot[is.na(tmorph.dna.prot)]<-"?"

# Concatenate matrices without dropping taxa
# Example 4: Merge morphology and DNA, but keep all the taxa 
row.names(test.morph)
row.names(test.dna)
test.morph
test.dna
morph_dna<-as.matrix(merge(test.morph,test.dna, by="row.names",all=TRUE))
str(morph_dna)
morph_dna[,1:12]
rownames(morph_dna)<-morph_dna[,1]
morph_dna[,2:12]
morph_dna<-morph_dna[,2:12]
morph_dna[is.na(morph_dna)]<-"?"

#Export final matrix as nexus file 
?write.nexus.data
write.nexus.data(tmorph.dna.prot,file="tmerge",datablock=T,interleaved=F)
write.nexus.data(morph_dna,file="matrix_concatenated",datablock=T,interleaved=F)