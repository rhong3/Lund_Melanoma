# All genes
# Other features BRAF

library("stats")
library('ggplot2')
library('pheatmap')
library("data.table", lib.loc="/Library/Frameworks/R.framework/Versions/3.5/Resources/library")
ica <-read.csv("~/Documents/Lund_Melanoma/phospho/ICA/Gene_phospho_ip_IC_Centroid.csv", row.names=1)
wna_clinical <- read.delim("~/Documents/Lund_Melanoma/phospho/wna_clinical.tsv", row.names=1)
proteomics <- read.delim("~/Documents/Lund_Melanoma/phospho/J_Clean_phospho_ip.tsv", row.names=1)

wna_clinical = wna_clinical[order(wna_clinical['BRAF.status_V600A'],	wna_clinical['BRAF.status_V600E'],	wna_clinical['BRAF.status_V600K'],	wna_clinical['BRAF.status_WT'],	wna_clinical['BRAF.status_nan']),]
proteomics = proteomics[match(rownames(ica), rownames(proteomics)), match(rownames(wna_clinical), colnames(proteomics))]
categoryB = data.frame(row.names=rownames(wna_clinical), category=c(rep("NA", length(which(wna_clinical['BRAF.status_nan']==1))),
                                                                    rep("WT", length(which(wna_clinical['BRAF.status_WT']==1))),
                                                                    rep("V600K", length(which(wna_clinical['BRAF.status_V600K']==1))),
                                                                    rep("V600E", length(which(wna_clinical['BRAF.status_V600E']==1))),
                                                                    rep("V600A", length(which(wna_clinical['BRAF.status_V600A']==1)))))
core_proteomics <- proteomics 

B_proteomics = transpose(core_proteomics)
colnames(B_proteomics) <- rownames(core_proteomics)
rownames(B_proteomics) <- colnames(core_proteomics)
setDT(wna_clinical, keep.rownames = TRUE)
setkey(setDT(B_proteomics, keep.rownames = TRUE), rn)
B_proteomics = B_proteomics[wna_clinical, BRAF.status_WT := i.BRAF.status_WT][]
B_proteomics = na.omit(B_proteomics)
write.csv(B_proteomics, file = "~/Documents/Lund_Melanoma/phospho/Analysis0709/BRAF/B_temp.csv", row.names=FALSE)
B_prot <- read.csv("~/Documents/Lund_Melanoma/phospho/Analysis0709/BRAF/B_temp.csv", row.names=1)
WTBRAF = subset(B_prot, B_prot$BRAF.status_WT == 1)
WTBRAF = WTBRAF[,-c(26)]
MutBRAF = subset(B_prot, B_prot$BRAF.status_WT == 0)
MutBRAF = MutBRAF[,-c(26)]
t.test(WTBRAF, MutBRAF)
x = list('Overall'=t.test(WTBRAF, MutBRAF)$p.value)
for (i in 1:1593){
  p = t.test(WTBRAF[,i], MutBRAF[,i])$p.value
  x[[colnames(WTBRAF)[i]]] = p
  if (p < 0.1){
    print(colnames(WTBRAF)[i], print(p))
  }
}
xdf=as.data.frame(x)
rownames(xdf) = c('T-Test p-value')
oxdf = transpose(xdf)
colnames(oxdf) <- rownames(xdf)
rownames(oxdf) <- colnames(xdf)
write.csv(oxdf, file = "~/Documents/Lund_Melanoma/phospho/Analysis0709/BRAF/T-Test.csv", row.names=TRUE)


# Alive/Dead binary

library("stats")
library('ggplot2')
library('pheatmap')
library("data.table", lib.loc="/Library/Frameworks/R.framework/Versions/3.5/Resources/library")
ica <-read.csv("~/Documents/Lund_Melanoma/phospho/ICA/Gene_phospho_ip_IC_Centroid.csv", row.names=1)
wna_clinical <- read.delim("~/Documents/Lund_Melanoma/phospho/wna_clinical.tsv", row.names=1)
proteomics <- read.delim("~/Documents/Lund_Melanoma/phospho/J_Clean_phospho_ip.tsv", row.names=1)
wna_clinical = wna_clinical[order(wna_clinical['Alive.2016.12.05_alive'],	wna_clinical['Alive.2016.12.05_dead'],	wna_clinical['Alive.2016.12.05_dead..likely.melanoma.'],	wna_clinical['Alive.2016.12.05_dead.other.reason'],	wna_clinical['Alive.2016.12.05_dead.unknown.reason']),]
proteomics = proteomics[match(rownames(ica), rownames(proteomics)), match(rownames(wna_clinical), colnames(proteomics))]
categoryS = data.frame(row.names=rownames(wna_clinical), category=c(rep("NA", length(which(wna_clinical['Alive.2016.12.05_nan']==1))), 
                                                                    rep("dead.unknown.reason", length(which(wna_clinical['Alive.2016.12.05_dead.unknown.reason']==1))),
                                                                    rep("dead.other.reason", length(which(wna_clinical['Alive.2016.12.05_dead.other.reason']==1))),
                                                                    rep("dead.(likely.melanoma)", length(which(wna_clinical['Alive.2016.12.05_dead..likely.melanoma.']==1))),
                                                                    rep("dead", length(which(wna_clinical['Alive.2016.12.05_dead']==1))),
                                                                    rep("alive", length(which(wna_clinical['Alive.2016.12.05_alive']==1)))))
core_proteomics <- proteomics

wna_clinical = subset(wna_clinical, wna_clinical$Alive.2016.12.05_nan == 0)

B_proteomics = transpose(core_proteomics)
colnames(B_proteomics) <- rownames(core_proteomics)
rownames(B_proteomics) <- colnames(core_proteomics)
setDT(wna_clinical, keep.rownames = TRUE)
setkey(setDT(B_proteomics, keep.rownames = TRUE), rn)
B_proteomics = B_proteomics[wna_clinical, Alive.2016.12.05_alive := i.Alive.2016.12.05_alive][]
B_proteomics = na.omit(B_proteomics)
write.csv(B_proteomics, file = "~/Documents/Lund_Melanoma/phospho/Analysis0709/binary/S_temp.csv", row.names=FALSE)
B_prot <- read.csv("~/Documents/Lund_Melanoma/phospho/Analysis0709/binary/S_temp.csv", row.names=1)
WTBRAF = subset(B_prot, B_prot$Alive.2016.12.05_alive == 1)
WTBRAF = WTBRAF[,-c(26)]
MutBRAF = subset(B_prot, B_prot$Alive.2016.12.05_alive == 0)
MutBRAF = MutBRAF[,-c(26)]
t.test(WTBRAF, MutBRAF)
x = list('Overall'=t.test(WTBRAF, MutBRAF)$p.value)
for (i in 1:1593){
  p = t.test(WTBRAF[,i], MutBRAF[,i])$p.value
  x[[colnames(WTBRAF)[i]]] = p
  if (p < 0.1){
    print(colnames(WTBRAF)[i], print(p))
  }
}
xdf=as.data.frame(x)
rownames(xdf) = c('T-Test p-value')
oxdf = transpose(xdf)
colnames(oxdf) <- rownames(xdf)
rownames(oxdf) <- colnames(xdf)
write.csv(oxdf, file = "~/Documents/Lund_Melanoma/phospho/Analysis0709/binary/T-Test.csv", row.names=TRUE)

# 5-yr binary
library("stats")
library('ggplot2')
library('pheatmap')
library("data.table", lib.loc="/Library/Frameworks/R.framework/Versions/3.5/Resources/library")
ica <-read.csv("~/Documents/Lund_Melanoma/phospho/ICA/Gene_phospho_ip_IC_Centroid.csv", row.names=1)
wna_clinical <- read.delim("~/Documents/Lund_Melanoma/phospho/wna_clinical.tsv", row.names=1)
proteomics <- read.delim("~/Documents/Lund_Melanoma/phospho/J_Clean_phospho_ip.tsv", row.names=1)
wna_clinical = wna_clinical[order(wna_clinical['Alive.2016.12.05_alive'],	wna_clinical['Alive.2016.12.05_dead'],	wna_clinical['Alive.2016.12.05_dead..likely.melanoma.'],	wna_clinical['Alive.2016.12.05_dead.other.reason'],	wna_clinical['Alive.2016.12.05_dead.unknown.reason']),]
proteomics = proteomics[match(rownames(ica), rownames(proteomics)), match(rownames(wna_clinical), colnames(proteomics))]
categoryS = data.frame(row.names=rownames(wna_clinical), category=c(rep("NA", length(which(wna_clinical['Alive.2016.12.05_nan']==1))), 
                                                                    rep("dead.unknown.reason", length(which(wna_clinical['Alive.2016.12.05_dead.unknown.reason']==1))),
                                                                    rep("dead.other.reason", length(which(wna_clinical['Alive.2016.12.05_dead.other.reason']==1))),
                                                                    rep("dead.(likely.melanoma)", length(which(wna_clinical['Alive.2016.12.05_dead..likely.melanoma.']==1))),
                                                                    rep("dead", length(which(wna_clinical['Alive.2016.12.05_dead']==1))),
                                                                    rep("alive", length(which(wna_clinical['Alive.2016.12.05_alive']==1)))))
core_proteomics <- proteomics

wna_clinical = subset(wna_clinical, wna_clinical$Alive.2016.12.05_nan == 0)

B_proteomics = transpose(core_proteomics)
colnames(B_proteomics) <- rownames(core_proteomics)
rownames(B_proteomics) <- colnames(core_proteomics)
setDT(wna_clinical, keep.rownames = TRUE)
setkey(setDT(B_proteomics, keep.rownames = TRUE), rn)
B_proteomics = B_proteomics[wna_clinical, X5.year.survival.from.primary.diagnosis...Date.death.date.prim.diagn..1825.days...Days.differing.from.5.years := i.X5.year.survival.from.primary.diagnosis...Date.death.date.prim.diagn..1825.days...Days.differing.from.5.years][]
B_proteomics = na.omit(B_proteomics)
write.csv(B_proteomics, file = "~/Documents/Lund_Melanoma/phospho/Analysis0709/5YR_Binary/5S_temp.csv", row.names=FALSE)
B_prot <- read.csv("~/Documents/Lund_Melanoma/phospho/Analysis0709/5YR_Binary/5S_temp.csv", row.names=1)
WTBRAF = subset(B_prot, B_prot$X5.year.survival.from.primary.diagnosis...Date.death.date.prim.diagn..1825.days...Days.differing.from.5.years > 0)
WTBRAF = WTBRAF[,-c(26)]
MutBRAF = subset(B_prot, X5.year.survival.from.primary.diagnosis...Date.death.date.prim.diagn..1825.days...Days.differing.from.5.years < 0)
MutBRAF = MutBRAF[,-c(26)]
t.test(WTBRAF, MutBRAF)
x = list('Overall'=t.test(WTBRAF, MutBRAF)$p.value)
for (i in 1:1593){
  p = t.test(WTBRAF[,i], MutBRAF[,i])$p.value
  x[[colnames(WTBRAF)[i]]] = p
  if (p < 0.1){
    print(colnames(WTBRAF)[i], print(p))
  }
}
xdf=as.data.frame(x)
rownames(xdf) = c('T-Test p-value')
oxdf = transpose(xdf)
colnames(oxdf) <- rownames(xdf)
rownames(oxdf) <- colnames(xdf)
write.csv(oxdf, file = "~/Documents/Lund_Melanoma/phospho/Analysis0709/5YR_Binary/T-Test.csv", row.names=TRUE)


# dis.stage #
library("stats")
library('ggplot2')
library('pheatmap')
library("data.table", lib.loc="/Library/Frameworks/R.framework/Versions/3.5/Resources/library")
ica <-read.csv("~/Documents/Lund_Melanoma/phospho/ICA/Gene_phospho_ip_IC_Centroid.csv", row.names=1)
wna_clinical <- read.delim("~/Documents/Lund_Melanoma/phospho/wna_clinical.tsv", row.names=1)
proteomics <- read.delim("~/Documents/Lund_Melanoma/phospho/J_Clean_phospho_ip.tsv", row.names=1)
wna_clinical = wna_clinical[order(wna_clinical['dis.stage']),]
proteomics = proteomics[, match(rownames(wna_clinical), colnames(proteomics))]
categoryS = data.frame(row.names=rownames(wna_clinical), category=c(rep("1", length(which(wna_clinical['dis.stage']==1))), 
                                                                    rep("3", length(which(wna_clinical['dis.stage']==3))),
                                                                    rep("4", length(which(wna_clinical['dis.stage']==4))),
                                                                    rep("NA", 4)))
core_proteomics <- proteomics

B_proteomics = transpose(core_proteomics)
colnames(B_proteomics) <- rownames(core_proteomics)
rownames(B_proteomics) <- colnames(core_proteomics)
setDT(wna_clinical, keep.rownames = TRUE)
setkey(setDT(B_proteomics, keep.rownames = TRUE), rn)
B_proteomics = B_proteomics[wna_clinical, dis.stage := i.dis.stage][]
B_proteomics = na.omit(B_proteomics)
write.csv(B_proteomics, file = "~/Documents/Lund_Melanoma/phospho/Analysis0709/dis_stage/temp.csv", row.names=FALSE)
B_prot <- read.csv("~/Documents/Lund_Melanoma/phospho/Analysis0709/dis_stage/temp.csv", row.names=1)

x = list()
for (i in 1:1593){
  ff = aov(B_prot[, i] ~ dis.stage, data = B_prot)
  p = summary(ff)[[1]][["Pr(>F)"]][1]
  x[[colnames(B_prot)[i]]] = p
  if (p < 0.1){
    print(colnames(B_prot)[i], print(p))
  }
}

xdf=as.data.frame(x)
rownames(xdf) = c('ANOVA p-value')
oxdf = transpose(xdf)
colnames(oxdf) <- rownames(xdf)
rownames(oxdf) <- colnames(xdf)
write.csv(oxdf, file = "~/Documents/Lund_Melanoma/phospho/Analysis0709/dis_stage/ANOVA.csv", row.names=TRUE)

# prim breslow class
library("stats")
library('ggplot2')
library('pheatmap')
library("data.table", lib.loc="/Library/Frameworks/R.framework/Versions/3.5/Resources/library")
ica <-read.csv("~/Documents/Lund_Melanoma/phospho/ICA/Gene_phospho_ip_IC_Centroid.csv", row.names=1)
wna_clinical <- read.delim("~/Documents/Lund_Melanoma/phospho/wna_clinical.tsv", row.names=1)
proteomics <- read.delim("~/Documents/Lund_Melanoma/phospho/J_Clean_phospho_ip.tsv", row.names=1)
wna_clinical = wna_clinical[!is.na(wna_clinical$prim.breslow.class),]
wna_clinical = wna_clinical[order(wna_clinical['prim.breslow.class']),]
proteomics = proteomics[, match(rownames(wna_clinical), colnames(proteomics))]
categoryS = data.frame(row.names=rownames(wna_clinical), category=c(rep("1", length(which(wna_clinical['prim.breslow.class']==1))), 
                                                                    rep("2", length(which(wna_clinical['prim.breslow.class']==2))),
                                                                    rep("3", length(which(wna_clinical['prim.breslow.class']==3))),
                                                                    rep("4", length(which(wna_clinical['prim.breslow.class']==4)))))
core_proteomics <- proteomics

B_proteomics = transpose(core_proteomics)
colnames(B_proteomics) <- rownames(core_proteomics)
rownames(B_proteomics) <- colnames(core_proteomics)
setDT(wna_clinical, keep.rownames = TRUE)
setkey(setDT(B_proteomics, keep.rownames = TRUE), rn)
B_proteomics = B_proteomics[wna_clinical, prim.breslow.class := i.prim.breslow.class][]
B_proteomics = na.omit(B_proteomics)
write.csv(B_proteomics, file = "~/Documents/Lund_Melanoma/phospho/Analysis0709/prim_breslow_class/temp.csv", row.names=FALSE)
B_prot <- read.csv("~/Documents/Lund_Melanoma/phospho/Analysis0709/prim_breslow_class/temp.csv", row.names=1)

x = list()
for (i in 1:1593){
  ff = aov(B_prot[, i] ~ prim.breslow.class, data = B_prot)
  p = summary(ff)[[1]][["Pr(>F)"]][1]
  x[[colnames(B_prot)[i]]] = p
  if (p < 0.1){
    print(colnames(B_prot)[i], print(p))
  }
}

xdf=as.data.frame(x)
rownames(xdf) = c('ANOVA p-value')
oxdf = transpose(xdf)
colnames(oxdf) <- rownames(xdf)
rownames(oxdf) <- colnames(xdf)
write.csv(oxdf, file = "~/Documents/Lund_Melanoma/phospho/Analysis0709/prim_breslow_class/ANOVA.csv", row.names=TRUE)

# clark
library("stats")
library('ggplot2')
library('pheatmap')
library("data.table", lib.loc="/Library/Frameworks/R.framework/Versions/3.5/Resources/library")
ica <-read.csv("~/Documents/Lund_Melanoma/phospho/ICA/Gene_phospho_ip_IC_Centroid.csv", row.names=1)
wna_clinical <- read.delim("~/Documents/Lund_Melanoma/phospho/wna_clinical.tsv", row.names=1)
proteomics <- read.delim("~/Documents/Lund_Melanoma/phospho/J_Clean_phospho_ip.tsv", row.names=1)

wna_clinical = wna_clinical[!is.na(wna_clinical$clark),]
wna_clinical = wna_clinical[order(wna_clinical['clark']),]
proteomics = proteomics[, match(rownames(wna_clinical), colnames(proteomics))]
categoryS = data.frame(row.names=rownames(wna_clinical), category=c(rep("1", length(which(wna_clinical['clark']==1))), 
                                                                    rep("2", length(which(wna_clinical['clark']==2))),
                                                                    rep("3", length(which(wna_clinical['clark']==3))),
                                                                    rep("4", length(which(wna_clinical['clark']==4))),
                                                                    rep("5", length(which(wna_clinical['clark']==5)))))
core_proteomics <- proteomics

B_proteomics = transpose(core_proteomics)
colnames(B_proteomics) <- rownames(core_proteomics)
rownames(B_proteomics) <- colnames(core_proteomics)
setDT(wna_clinical, keep.rownames = TRUE)
setkey(setDT(B_proteomics, keep.rownames = TRUE), rn)
B_proteomics = B_proteomics[wna_clinical, clark := i.clark][]
B_proteomics = na.omit(B_proteomics)
write.csv(B_proteomics, file = "~/Documents/Lund_Melanoma/phospho/Analysis0709/clark/temp.csv", row.names=FALSE)
B_prot <- read.csv("~/Documents/Lund_Melanoma/phospho/Analysis0709/clark/temp.csv", row.names=1)

x = list()
for (i in 1:1593){
  ff = aov(B_prot[, i] ~ clark, data = B_prot)
  p = summary(ff)[[1]][["Pr(>F)"]][1]
  x[[colnames(B_prot)[i]]] = p
  if (p < 0.1){
    print(colnames(B_prot)[i], print(p))
  }
}

xdf=as.data.frame(x)
rownames(xdf) = c('ANOVA p-value')
oxdf = transpose(xdf)
colnames(oxdf) <- rownames(xdf)
rownames(oxdf) <- colnames(xdf)
write.csv(oxdf, file = "~/Documents/Lund_Melanoma/phospho/Analysis0709/clark/ANOVA.csv", row.names=TRUE)

#clin class
library("stats")
library('ggplot2')
library('pheatmap')
library("data.table", lib.loc="/Library/Frameworks/R.framework/Versions/3.5/Resources/library")
ica <-read.csv("~/Documents/Lund_Melanoma/phospho/ICA/Gene_phospho_ip_IC_Centroid.csv", row.names=1)
wna_clinical <- read.delim("~/Documents/Lund_Melanoma/phospho/wna_clinical.tsv", row.names=1)
proteomics <- read.delim("~/Documents/Lund_Melanoma/phospho/J_Clean_phospho_ip.tsv", row.names=1)

wna_clinical = wna_clinical[!is.na(wna_clinical$clin.class),]
wna_clinical = wna_clinical[(wna_clinical$clin.class != ''),]
wna_clinical = wna_clinical[order(wna_clinical['clin.class']),]
proteomics = proteomics[, match(rownames(wna_clinical), colnames(proteomics))]
categoryS = data.frame(row.names=rownames(wna_clinical), category=c(rep("0", length(which(wna_clinical['clin.class']==0))),
                                                                    rep("1", length(which(wna_clinical['clin.class']==1))), 
                                                                    rep("2", length(which(wna_clinical['clin.class']==2))),
                                                                    rep("3", length(which(wna_clinical['clin.class']==3))),
                                                                    rep("4", length(which(wna_clinical['clin.class']==4))),
                                                                    rep("5", length(which(wna_clinical['clin.class']==5))),
                                                                    rep("NM", length(which(wna_clinical['clin.class']=='NM')))))
core_proteomics <- proteomics

B_proteomics = transpose(core_proteomics)
colnames(B_proteomics) <- rownames(core_proteomics)
rownames(B_proteomics) <- colnames(core_proteomics)
setDT(wna_clinical, keep.rownames = TRUE)
setkey(setDT(B_proteomics, keep.rownames = TRUE), rn)
B_proteomics = B_proteomics[wna_clinical, clin.class := i.clin.class][]
B_proteomics = na.omit(B_proteomics)
write.csv(B_proteomics, file = "~/Documents/Lund_Melanoma/phospho/Analysis0709/clin_class/temp.csv", row.names=FALSE)
B_prot <- read.csv("~/Documents/Lund_Melanoma/phospho/Analysis0709/clin_class/temp.csv", row.names=1)

x = list()
for (i in 1:1593){
  ff = aov(B_prot[, i] ~ clin.class, data = B_prot)
  p = summary(ff)[[1]][["Pr(>F)"]][1]
  x[[colnames(B_prot)[i]]] = p
  if (p < 0.1){
    print(colnames(B_prot)[i], print(p))
  }
}

xdf=as.data.frame(x)
rownames(xdf) = c('ANOVA p-value')
oxdf = transpose(xdf)
colnames(oxdf) <- rownames(xdf)
rownames(oxdf) <- colnames(xdf)
write.csv(oxdf, file = "~/Documents/Lund_Melanoma/phospho/Analysis0709/clin_class/ANOVA.csv", row.names=TRUE)

# prim site
library("stats")
library('ggplot2')
library('pheatmap')
library("data.table", lib.loc="/Library/Frameworks/R.framework/Versions/3.5/Resources/library")
ica <-read.csv("~/Documents/Lund_Melanoma/phospho/ICA/Gene_phospho_ip_IC_Centroid.csv", row.names=1)
wna_clinical <- read.delim("~/Documents/Lund_Melanoma/phospho/wna_clinical.tsv", row.names=1)
proteomics <- read.delim("~/Documents/Lund_Melanoma/phospho/J_Clean_phospho_ip.tsv", row.names=1)

wna_clinical = wna_clinical[!is.na(wna_clinical$prim.site),]
wna_clinical = wna_clinical[(wna_clinical$prim.site != ''),]
wna_clinical = wna_clinical[order(wna_clinical['prim.site']),]
proteomics = proteomics[, match(rownames(wna_clinical), colnames(proteomics))]
categoryS = data.frame(row.names=rownames(wna_clinical), category=c(rep("1", length(which(wna_clinical['prim.site']==1))), 
                                                                    rep("2", length(which(wna_clinical['prim.site']==2))),
                                                                    rep("3", length(which(wna_clinical['prim.site']==3))),
                                                                    rep("4", length(which(wna_clinical['prim.site']==4))),
                                                                    rep("5", length(which(wna_clinical['prim.site']==5))),
                                                                    rep("f", length(which(wna_clinical['prim.site']=='f')))))
core_proteomics <- proteomics

B_proteomics = transpose(core_proteomics)
colnames(B_proteomics) <- rownames(core_proteomics)
rownames(B_proteomics) <- colnames(core_proteomics)
setDT(wna_clinical, keep.rownames = TRUE)
setkey(setDT(B_proteomics, keep.rownames = TRUE), rn)
B_proteomics = B_proteomics[wna_clinical, prim.site := i.prim.site][]
B_proteomics = na.omit(B_proteomics)
write.csv(B_proteomics, file = "~/Documents/Lund_Melanoma/phospho/Analysis0709/prim_site/temp.csv", row.names=FALSE)
B_prot <- read.csv("~/Documents/Lund_Melanoma/phospho/Analysis0709/prim_site/temp.csv", row.names=1)

x = list()
for (i in 1:1593){
  ff = aov(B_prot[, i] ~ prim.site, data = B_prot)
  p = summary(ff)[[1]][["Pr(>F)"]][1]
  x[[colnames(B_prot)[i]]] = p
  if (p < 0.1){
    print(colnames(B_prot)[i], print(p))
  }
}

xdf=as.data.frame(x)
rownames(xdf) = c('ANOVA p-value')
oxdf = transpose(xdf)
colnames(oxdf) <- rownames(xdf)
rownames(oxdf) <- colnames(xdf)
write.csv(oxdf, file = "~/Documents/Lund_Melanoma/phospho/Analysis0709/prim_site/ANOVA.csv", row.names=TRUE)

