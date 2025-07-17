# Histone-H1

Ce dépôt contient tous les scripts et résultats issus de l’étude sur le rôle de l’histone H1.

Pour garantir la reproductibilité :
- Utilisez le fichier `r44_env.yml` pour créer un environnement **Conda** avec **R version 4.4**. 
- En activant l'environnement conda, lancer Rstudio dans le terminal pour être sous R v4.4 et utilisé `renv::restore()` en étant dans le dossier `R_script` .

## Structure des dossiers

### `FLowchart/`
Contient un schéma des étapes du travail effectué.

### `Analysis/`

- Contient la liste de tous les **gènes différentiellement exprimés (DEGs)** identifiés dans l’étude.
- Le nom de chaque fichier indique le **contexte** dans lequel ces DEGs ont été trouvés.
- Contient également des visualisations telles que :
  - **MA plots**
  - **Scatter plots**

### `R_script/`

- Contient l’ensemble du travail réalisé sous **R**.
- Comprend notamment :
  - Le prétraitement des fichiers FASTA et GTF
  - L’analyse principale
  - Le fichier `renv.lock` pour la reproductibilité des packages R

### `Shell_script/`

- Contient les scripts shell utilisés sur un cluster **SLURM**.
- Comprend les étapes allant :
  - Du prétraitement des fichiers FastQ
  - Jusqu’à l’alignement et la quantification des lectures

