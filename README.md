#  Test Aptitude – Fullstack Project

Ce projet contient une stack **Backend + Mobile** :  
- **Backend** : API REST avec [NestJS](https://nestjs.com/) et [Prisma](https://www.prisma.io/)  
- **Frontend Mobile** : Application mobile en [Flutter](https://flutter.dev/)

---

##  Prérequis

Avant de commencer, assurez-vous d’avoir installé :  

- [Node.js](https://nodejs.org/) (>= 18.x recommandé)  
- [npm](https://www.npmjs.com/) (installé avec Node.js)  
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (>= 3.x recommandé)  
- [SQLite](https://www.sqlite.org/) (utilisé par Prisma, déjà inclus dans la plupart des environnements)  

---

##  Structure du projet

```
testaptitude/
├── backends/
│   └── backend-test/                  # API NestJS + Prisma
└── frontends/
    └── mobile/
        └── testtechniqueflutter/      # Application mobile Flutter
```

---

##  Backend (NestJS + Prisma)

###  Installation et lancement

```bash
cd backends/backend-test
npm install
npm run start:dev
```

Mode production :  

```bash
npm run start:prod
```

###  Prisma

Appliquer les migrations et générer le client Prisma :

```bash
npx prisma migrate dev
npx prisma generate
```

Exécuter le script de seed (pour insérer des données initiales) :  

```bash
npx ts-node prisma/seed.ts
```

###  Variables d’environnement

Créer un fichier `.env` à la racine du backend :  

```env
DATABASE_URL="file:./dev.db"
JWT_SECRET="mon_secret_jwt"
```

###  Tests

```bash
# tests unitaires
npm run test

# tests end-to-end
npm run test:e2e
```

---

##  Frontend Mobile (Flutter)

### Installation et lancement

```bash
cd frontends/mobile/testtechniqueflutter
flutter pub get
flutter run
```

###  Fonctionnalités implémentées

-  Afficher la liste des projets  
-  Ajouter un projet  
-  Modifier un projet  
-  Supprimer un projet  
-  Connexion à l’API NestJS via un `ApiService`  

---

##  Ressources utiles

- [NestJS Docs](https://docs.nestjs.com/)  
- [Prisma Docs](https://www.prisma.io/docs)  
- [Flutter Docs](https://docs.flutter.dev/)  

---

##  Licence

Projet sous licence **MIT**.
