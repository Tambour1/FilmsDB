# FilmsDB App
# Tables des matières
- [Description](#description)
- [Sujets](#sujets)
- [Technologies](#technologies)
- [Installation](#installation)

# Description
**FilmsDB** est une application web permettant de rechercher des films en utilisant l'API OMDB. L'application offre les fonctionnalités suivantes :
- Recherche de films via des mots-clés.
- Affichage des résultats sous forme de liste.
- Consultation des détails des films sélectionnés.
- Historique des recherches.
- Stockage des données local.

Cette application a été réalisée dans le cadre d'un TD d'un cours de développement client avancé.

# Sujets
Sujets réalisés par Anthony RIMET : IUT Nancy-Charlemagne 2024
- [Partie 1](./docs/partie1-FilmsDB.pdf)
- [Partie 2](./docs/partie2-FilmsDB.pdf)

# Technologies
- **Frontend :** HTML, CSS, JavaScript avec le framework VueJs.
- **Backend :** API OMDB pour les données des films.
- **Docker :** Conteneurisation de l'application pour simplifier le déploiement.

# Installation
## Cloner le dépôt
```bash
# clonage du projet
git clone https://github.com/Tambour1/FilmsDB.git

# se placer dans le répertoire 
cd FilmsDB
```

## Utiliser Docker
```bash
# Lancer le conteneur
docker-compose up -d --build

# Arrêter et supprimer le conteneur
docker-compose down
```

L'application sera accessible à l'adresse http://localhost:4444


# ⚠️ Remarque importante sur la clé API
Dans ce projet, la clé API utilisée pour interagir avec l'API OMDB est visible dans le fichier principal de l'application. Cela a été fait intentionnellement pour simplifier l'exercice dans le cadre de ce TD.
**Cependant, dans un projet de production ou un contexte professionnel, évidement que la clé ne sera pas à la vue de tous de cette manière.** 
La clé utilisée ici est une clé de test et n'a pas de valeur critique.
Pour générer ma clé API, j'ai suivi ce lien -> https://www.omdbapi.com/apikey.aspx
