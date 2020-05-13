getwd()
setwd("/Users/juancarrillo/Dropbox (PaleoColombia)/Documents work/Research Projects/Thuxleya ArtEx/Well-corroborated tree/Merge datasets/test")
dir()
library(ape)
library(corHMM)

# Example of DNA matrix
?read.dna  
test.dna<-read.dna("testDNA.txt",format="interleaved",as.character=TRUE)
str(test.dna)
head(test.dna)
test.dna[,0]

# Example of Amoniacids (AA) matrix (same format as DNA matrix)
test.prot<-read.dna("testprotein.txt",format="interleaved",as.character=TRUE)
str(test.prot)
head(test.prot)
test.prot[,0]

# Example of morphological matrix
# The multistate characters will have to be formated manually afterwards with a text editor
?readNexusMorph
test.morph<-readNexusMorph("testmorph.txt")
str(test.morph)
head(test.morph)
tmorph<-as.matrix(test.morph)
str(tmorph)
tmorph[,0]

## Merge matrices and drop taxa missing data for some character partition ##

# Example 1:Merge DNA and AA matrices, dropping taxa without DNA data
ndna.prot<-match(rownames(test.dna),rownames(test.prot))
tdna.prot2<-cbind(test.dna,test.prot[ndna.prot,])
head(tdna.prot2)

# Example 2: Merge morphology and DNA matrices, dropping taxa without morphology
nmorph.dna<-match(rownames(test.morph),rownames(test.dna))
tmorph.dna<-cbind(test.morph,test.dna[nmorph.dna,])
head(tmorph.dna)
str(tmorph.dna)
tmorph.dnam<-as.matrix(tmorph.dna)
tmorph.dnam[is.na(tmorph.dnam)]<-"?"
head(tmorph.dnam)

# Example 3: Merge morphology, DNA and AA keeping only the taxa with morphology
nmorph.dna.prot<-match(rownames(tmorph.dnam),rownames(test.prot))
tmorph.dna.prot<-cbind(tmorph.dnam,test.prot[nmorph.dna.prot,])
head(tmorph.dna.prot)
str(tmorph.dna.prot)
tmorph.dna.prot[is.na(tmorph.dna.prot)]<-"?"
head(tmorph.dna.prot)

# Format of polymorphisms have to be changed in a text editor

#Export final matrix as nexus file 
?write.nexus.data
write.nexus.data(tmorph.dna.prot,file="tmerge",datablock=T,interleaved=F)


  

