FROM node:18 AS build

WORKDIR /app

# Copie des fichiers de dépendances
COPY package*.json ./ 

# Installation des dépendances
RUN npm install

# Copie des fichiers sources du projet dans le conteneur
COPY . .

# Construction de l'application
RUN npm run build

FROM nginx:alpine

# Supprimer la page par défaut de Nginx
RUN rm -rf /usr/share/nginx/html/*

# Copier les fichiers construits dans le répertoire Nginx
COPY --from=build /app/dist /usr/share/nginx/html

# Exposer le port 80 pour le serveur
EXPOSE 80

# Commande par défaut pour Nginx
CMD ["nginx", "-g", "daemon off;"]
