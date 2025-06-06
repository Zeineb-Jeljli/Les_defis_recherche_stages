# Installer les packages nécessaires (si ce n'est pas déjà fait)
if (!require("corrplot")) install.packages("corrplot")
if (!require("readxl")) install.packages("readxl")
if (!require("FactoMineR")) install.packages("FactoMineR")
if (!require("factoextra")) install.packages("factoextra")
if (!require("RColorBrewer")) install.packages("RColorBrewer")
if (!require("questionr")) install.packages("questionr")
if (!require("ggplot2")) install.packages("ggplot2")
if (!require("ggrepel")) install.packages("ggrepel")
if (!require("cluster")) install.packages("cluster")

# Charger les packages
library(readxl)
library(FactoMineR)
library(factoextra)
library(corrplot)
library(RColorBrewer)
library(questionr)
library(ggplot2)
library(ggrepel)
library(cluster)

# Charger le fichier Excel
data <- read_excel("C:\\Users\\21655\\Downloads\\data.xlsx")
View(data)

######################
### 1. ACP - Bloc 1 ###
######################

colonnes_likert_bloc1 <- c(
  "Maîtrise_compétences",
  "Suivi_formations",
  "Préparé_entretiens",
  "Simulations_entretiens",
  "Compréhension_attentes",
  "Connaissance_entreprises",
  "Confiance_entretiens",
  "Connaissance_questions",
  "Difficulté_ciblage",
  "Connaissance_tendances",
  "Difficulté_mise_valeur",
  "Difficulté_mise_pratique",
  "Difficulté_identification",
  "Compétences_manquantes",
  "Aise_outils_logiciels"
)

# Sélectionner le bloc pour l'ACP
data_bloc1 <- data[, colonnes_likert_bloc1]

# Explorer les données
head(data_bloc1)  # Afficher les premières lignes
str(data_bloc1)   # Vérifier la structure des variables
summary(data_bloc1)  # Résumé statistique

# Calculer et visualiser la matrice des corrélations pour le bloc
M <- cor(data_bloc1, use = "complete.obs")
corrplot(M, type = "upper", order = "hclust", 
         col = brewer.pal(n = 8, name = "RdBu"),
         tl.cex = 0.7, tl.srt = 45)

# Exécuter l'ACP avec variables démographiques comme qualitatives supplémentaires
res.pca <- PCA(data, 
               scale.unit = TRUE, 
               ncp = 5,
               quanti.sup = NULL,
               quali.sup = 1:4,  # Sexe, formation, année, disponibilité
               graph = FALSE)

# Afficher les valeurs propres
print(res.pca$eig)

# Visualiser le scree plot
fviz_screeplot(res.pca, ncp = 10, addlabels = TRUE)

# Coordonnées et cos2 des variables
print(res.pca$var$coord[colonnes_likert_bloc1, ])
print(res.pca$var$cos2[colonnes_likert_bloc1, ])

# Graphique des variables
fviz_pca_var(res.pca, 
             col.var = "contrib",
             select.var = list(name = colonnes_likert_bloc1),
             repel = TRUE) +
  scale_color_gradient2(low = "white", mid = "blue", high = "red", midpoint = 0.6) +
  theme_minimal()

# Graphique des individus
fviz_pca_ind(res.pca, 
             geom = "point",
             col.ind = "cos2",
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"))

########## 2eme ACP ##############

# Sélection des colonnes du bloc 2 (variables Likert du bloc 2)
colonnes_likert_bloc2 <- colnames(data)[20:34]
data_bloc2 <- data[, colonnes_likert_bloc2]

# Étape 1 : Calcul et visualisation de la matrice des corrélations
M2 <- cor(data_bloc2, use = "complete.obs")
corrplot(M2, type = "upper", order = "hclust",
         col = brewer.pal(n = 8, name = "RdBu"),
         tl.cex = 0.7, tl.srt = 45)
# Étape 2 : Exécuter l'ACP avec variables démographiques comme qualitatives supplémentaires
res.pca_bloc2 <- PCA(data, 
                     scale.unit = TRUE, 
                     ncp = 5,
                     quanti.sup = NULL,
                     quali.sup = 1:4,  # Sexe, formation, année, disponibilité
                     graph = FALSE)

# Étape 3 : Afficher les valeurs propres
print(res.pca_bloc2$eig)
# Étape 4 : Visualiser le scree plot
fviz_screeplot(res.pca_bloc2, ncp = 10, addlabels = TRUE)
# Sauvegarde du scree plot pour le rapport
ggsave("screeplot_bloc2.png", width = 8, height = 6)
# Étape 5 : Coordonnées et cos2 des variables
print(res.pca_bloc2$var$coord[colonnes_likert_bloc2, ])
print(res.pca_bloc2$var$cos2[colonnes_likert_bloc2, ])

# Étape 6 : Graphique des variables
fviz_pca_var(res.pca_bloc2, 
             col.var = "contrib",
             select.var = list(name = colonnes_likert_bloc2),
             repel = TRUE) +
  scale_color_gradient2(low = "white", mid = "blue", high = "red", midpoint = 0.6) +
  theme_minimal()
# Étape 7 : Graphique des individus
fviz_pca_ind(res.pca_bloc2, 
             geom = "point",
             col.ind = "cos2",
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"))
# Sauvegarde de la carte des individus pour le rapport
ggsave("individuals_pca_bloc2.png", width = 8, height = 6)

######################
######################
### 3. ACM         ###
######################

# Sélection des colonnes de AI à AP (35 à 43 en index R)
colonnes_acm <- c("Dur_près","Frais_transp","Stage_nonpayé","Compliqué_étud","Obligations","Chercher_plus","Engagements","Contacts_necess") 
df_acm <- data[, colonnes_acm]

# Recodage en facteur (variables binaires 0/1)
for(col in colonnes_acm) {
  df_acm[[col]] <- factor(df_acm[[col]], 
                          levels = c(0, 1),
                          labels = c("Non", "Oui"))
  print(paste("Répartition pour", col, ":"))
  print(round(prop.table(table(df_acm[[col]])) * 100, 1))
}

# ACM (Analyse des Correspondances Multiples)
res.mca <- MCA(df_acm, graph = FALSE, ncp = 5)

# Valeurs propres (variance expliquée par chaque dimension)
print(res.mca$eig)

# Graphique des valeurs propres (éboulis)
fviz_screeplot(res.mca, addlabels = TRUE)

# Carte des modalités (variables)
fviz_mca_var(res.mca,
             choice = "var.cat",
             repel = TRUE,
             col.var = "contrib",
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"))

# Carte des individus
fviz_mca_ind(res.mca,
             col.ind = "cos2",
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"))

# Description des dimensions (corrélations variables-axes)
print(dimdesc(res.mca, axes = 1:2))

##############################
### 4. Classification (CAH) sur le Bloc 1 ###
##############################

# 1. Classification hiérarchique ascendante (CAH) avec agnes
classif <- agnes(data_bloc1, method = "ward")
# Visualiser le dendrogramme
plot(classif, xlab = "Individu", main = "")
title("Dendrogramme - Classification hiérarchique (Bloc 1)")
# 2. Déterminer la meilleure partition
classif2 <- as.hclust(classif)
# Visualiser l'effet coude pour choisir le nombre de classes
plot(rev(classif2$height), type = "h", ylab = "Hauteurs", xlab = "Nombre de classes")
inertie <- sort(classif2$height, decreasing = TRUE)
plot(inertie[1:20], type = "s", xlab = "Nombre de classes", ylab = "Inertie", 
     main = "Inertie en fonction du nombre de classes")
# Découper en 2 classes (basé sur l'effet coude potentiel)
classes <- cutree(classif2, k = 2)
rect.hclust(classif2, k = 2)
# 3. Ajouter la classe d'affectation de chaque individu comme variable
data_with_classes <- cbind.data.frame(data, as.factor(classes))
colnames(data_with_classes)[ncol(data_with_classes)] <- "Classe"
head(data_with_classes)
# 4. Description des classes avec catdes
res.cat <- catdes(data_with_classes, num.var = ncol(data_with_classes))
print(res.cat)
# 5. Représentation des classes sur le plan factoriel de l'ACP
# Ajouter la variable "Classe" comme variable qualitative supplémentaire
res.pca_with_classes <- PCA(data_with_classes, 
                            scale.unit = TRUE, 
                            ncp = 5,
                            quanti.sup = NULL,
                            quali.sup = c(1:4, ncol(data_with_classes)),  # Inclure la variable Classe
                            graph = FALSE)

# Visualiser les individus avec habillage par classe
fviz_pca_ind(res.pca_with_classes, 
             geom = c("point", "text"),
             col.ind = data_with_classes$Classe,
             palette = "jco",
             addEllipses = TRUE,
             ellipse.type = "confidence",
             repel = TRUE,
             title = "Représentation des classes sur le plan factoriel (Bloc 1)") +
  theme_minimal()

# 6. Utilisation de HCPC pour une classification directe à partir de l'ACP
res.hcpc <- HCPC(res.pca, nb.clust = -1, consol = TRUE, graph = FALSE)
# Visualiser le dendrogramme HCPC
fviz_dend(res.hcpc, show_labels = FALSE)
# Visualiser les classes sur le plan factoriel
fviz_cluster(res.hcpc, 
             geom = c("point", "text"),
             repel = TRUE,
             show.clust.cent = TRUE,
             palette = "jco",
             main = "Classification HCPC sur le plan factoriel (Bloc 1)") +
  theme_minimal()
# Description des classes HCPC
print(res.hcpc$desc.var)

