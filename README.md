# Histone-H1

Ce dépôt contient tous les scripts et résultats issus de l’étude sur le rôle de l’**histone H1**.

Pour garantir une reproductibilité complète :
- Utilisez le fichier `r44_env.yml` pour recréer l’environnement **Conda** exact utilisé lors de l’analyse, incluant **R version 4.4** et toutes les dépendances nécessaires.
- Un instantané (snapshot) des packages R gérés via `renv` est disponible dans le dossier `R_script/`.

## Structure des dossiers

### `Analysis/`

- Contient la liste de tous les **gènes différentiellement exprimés (DEGs)** identifiés dans l’étude.
- Le nom de chaque fichier indique le **contexte** dans lequel ces DEGs ont été trouvés.
- Contient également des visualisations telles que :
  - **MA plots**
  - **Scatter plots**

### `R_script/`

- Contient l’ensemble du travail réalisé sous **R**.
- Comprend notamment :
  - Le prétraitement des fichiers **FASTA** et **GTF**
  - L’analyse principale
  - Le fichier `renv.lock` pour la reproductibilité des packages R

### `Shell_script/`

- Contient les scripts shell utilisés sur un **cluster SLURM**.
- Comprend les étapes allant :
  - Du **prétraitement des fichiers FastQ**
  - Jusqu’à l’**alignement et la quantification des lectures**

