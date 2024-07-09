# OCR-R-Shiny-App

Cette application Shiny permet de télécharger des images, d'extraire du texte à l'aide de la reconnaissance optique de caractères (OCR), et de manipuler les données extraites. Les utilisateurs peuvent ajouter des localisations, supprimer des lignes et des colonnes, et télécharger les données modifiées sous forme de fichiers CSV ou Excel.

## Prérequis

Assurez-vous d'avoir les packages suivants installés dans votre environnement R :

- `shiny`
- `base64enc`
- `DT`
- `reticulate`
- `openxlsx`

Si certains de ces packages ne sont pas installés, vous pouvez les installer avec :

```r
install.packages(c("shiny", "base64enc", "DT", "openxlsx"))
```

Pour que l'application reconnaisse les espaces vides des tableaux, je me suis inspiré de ce qu'il a fait.
- `https://github.com/bilal-rachik/document-layout-analysis`

## Installation de Python et des modules nécessaires
Cette application utilise reticulate pour appeler des scripts Python depuis R. Assurez-vous d'avoir Python installé sur votre système. Vous pouvez vérifier et installer les modules Python nécessaires (opencv-python, pandas, pytesseract) avec les commandes suivantes :

```r
library(reticulate)

if (!py_module_available("cv2")) {
  py_install("opencv-python", pip = TRUE)
}

if (!py_module_available("pandas")) {
  py_install("pandas", pip = TRUE)
}

if (!py_module_available("pytesseract")) {
  py_install("pytesseract", pip = TRUE)
}
```

## Fonctionnalités
### Télécharger et visualiser une image
- `Utilisez le bouton "Choose Image File" pour télécharger une image (.png, .jpg, .jpeg).`
- `L'image téléchargée sera affichée sur l'interface utilisateur.`

### Extraction de texte (OCR)
- `Une fois l'image téléchargée, le script Python sera appelé pour effectuer l'OCR sur l'image.`
- `Les résultats de l'OCR seront affichés dans un tableau éditable.`

### Ajouter une localisation
- `Entrez un nom de localisation dans le champ "Enter Location".`
- `Cliquez sur le bouton "Add Location" pour ajouter la localisation comme une colonne au tableau. Si la colonne "Localisation" existe déjà, ses valeurs seront mises à jour.`

### Supprimer une ligne
- `Entrez le numéro de la ligne à supprimer dans le champ "Enter Row to Delete".`
- `Cliquez sur le bouton "Delete Row" pour supprimer la ligne correspondante.`

### Supprimer une colonne
- `Entrez le nom de la colonne à supprimer dans le champ "Enter Column Name to Delete".`
- `Cliquez sur le bouton "Delete Column" pour supprimer la colonne correspondante.`

### Télécharger les données
- `Cliquez sur le bouton "Download CSV" pour télécharger les données sous forme de fichier CSV.`
- `Cliquez sur le bouton "Download Excel" pour télécharger les données sous forme de fichier Excel.`
