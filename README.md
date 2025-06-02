# Les Défis de la Recherche de Stages

## Présentation
Ce projet, réalisé par Zeineb Jeljli, Houayda Chawali et Mazen Ben Brahim à l'École Supérieure des Sciences Appliquées et Informatiques (ESSAI), analyse les défis rencontrés par les étudiants dans leur recherche de stages. À travers un questionnaire administré à 61 répondants, nous avons utilisé des méthodes statistiques (ACP, ACM, CAH) pour identifier les principaux obstacles et proposer des recommandations.

## Structure du Projet
- **data/** : Contient le fichier de données `Les_defis_recherche_stages.xlsx`.
- **scripts/** : Scripts R pour les analyses :
  - `acp_bloc1.R` : ACP sur le Bloc 1 (Préparation et Compétences).
  - `acp_bloc2.R` : ACP sur le Bloc 2 (Ressources et Accompagnement).
  - `acm_bloc3.R` : ACM sur le Bloc 3 (Contraintes et Obstacles).
  - `cah_bloc1.R` : CAH sur le Bloc 1 (Profils d’étudiants).
- **figures/** : Graphiques générés (corrgrammes, scree plots, cartes des variables/individus, dendrogramme, etc.).
- **docs/** : Rapport complet (`rapport_analyse_donnees.pdf`).

## Méthodologie
1. **ACP (Bloc 1 et 2)** : Analyse des variables quantitatives (échelles de Likert) pour identifier les dimensions principales des défis (ex. Préparation vs Difficultés).
2. **ACM (Bloc 3)** : Analyse des contraintes binaires (Oui/Non) pour explorer les associations entre obstacles.
3. **CAH (Bloc 1)** : Classification des étudiants en deux groupes (bien préparés vs moins préparés).

## Résultats Principaux
- **Bloc 1** : Dim1 (26.27%) oppose les étudiants compétents/préparés à ceux moins préparés ; Dim2 (9.12%) met en avant les difficultés pratiques.
- **Bloc 2** : Dim1 (26.27%) concerne l’utilisation des ressources numériques ; Dim2 (9.12%) le soutien et les difficultés initiales.
- **Bloc 3** : Dim1 (27.1%) et Dim2 (18.2%) montrent les contraintes liées à la recherche prolongée et aux besoins de contacts.
- **CAH** : Deux classes identifiées : étudiants confiants/préparés (Classe 2) vs ceux en difficulté (Classe 1).

## Comment Reproduire
1. Clonez le dépôt :
   ```bash
   git clone https://github.com/tonnom/Les_defis_recherche_stages.git
