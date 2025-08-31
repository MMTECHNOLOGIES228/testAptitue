# Étape 1 : builder
FROM node:20-alpine AS builder

# Définir le répertoire de travail
WORKDIR /usr/src/app

# Copier package.json et package-lock.json
COPY package*.json ./

# Installer les dépendances
RUN npm install

# Copier le reste des fichiers
COPY . .

# Compiler le projet NestJS
RUN npm run build

# Étape 2 : runtime
FROM node:20-alpine AS runtime

WORKDIR /usr/src/app

# Copier uniquement les fichiers nécessaires
COPY package*.json ./
RUN npm install --only=production

COPY --from=builder /usr/src/app/dist ./dist

# Exposer le port de l'application
EXPOSE 9000

# Commande de démarrage
CMD ["node", "dist/main.js"]
