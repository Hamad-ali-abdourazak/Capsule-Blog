
CapsuleBlog

Commencez ici : ouvrez `index.html` localement ou servez le dossier.

Essayer en local

```powershell
cd \path\to\capsule-blog
py -m http.server 8000
```

Ouvrir : http://localhost:8000

Essayer en local

```powershell
cd \path\to\capsule-blog
python -m http.server 8000
```

Ouvrir : http://localhost:8000/index.html

Déplacer / copier

Copiez simplement le dossier `capsule-blog` où tu veux sur ta machine. Pour extraire un ZIP (si tu en as un) :

```powershell
Expand-Archive -Path .\capsule-blog.zip -DestinationPath C:\Users\<ton-utilisateur>\capsule-blog -Force
```

Import dans WeWeb Studio

1. Crée un nouveau projet WeWeb.
2. Dans Assets > Upload, uploade `index.html`, `assets/styles.css` et `api/posts.json`.
3. Utilise une source de données JSON pointant vers `api/posts.json` pour afficher les posts dynamiquement.

Besoin d'autres templates ? Dis-moi ce que tu veux ajouter.

Améliorations récentes

- Ajout d'un favicon SVG pour une meilleure présentation.
- Styles améliorés pour un rendu plus professionnel.
- Pages individuelles `post-1.html` à `post-3.html` pour chaque post mock.

Design moderne

- Interface modernisée : navigation responsive, cartes pour les articles, recherche instantanée, animations légères.

- Articles chargés depuis l'API publique JSONPlaceholder (https://jsonplaceholder.typicode.com) avec fallback vers `api/posts.json` si l'API est indisponible.
- Formulaire de contact aligné et amélioration du rendu responsive.

- Si tu veux une version encore plus avancée (thème, composants réutilisables, animations supplémentaires), je peux intégrer Tailwind ou un petit build (Vite) pour faciliter les développements.

Si tu veux que je transforme ça en un petit site prêt à déployer (Netlify/Vercel) ou que j'ajoute une navigation complète et pages dynamiques, je peux le faire.

Serveur local sans Python

Si la commande `python` n'est pas disponible (message d'erreur : "Le terme 'python' n'est pas reconnu"), tu peux utiliser le petit serveur PowerShell inclus :

```powershell
# Depuis le dossier capsule-blog
powershell -ExecutionPolicy Bypass -File .\simple-server.ps1 -Port 8000 -Root .
```

Le script écoute sur http://localhost:8000 et sert les fichiers statiques du dossier courant.

Remarque : si le port 8000 est déjà utilisé, choisis un autre port (ex. 8080).
