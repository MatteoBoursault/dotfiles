# Theme

Système de thèmes centralisé pour mes dotfiles. Un seul fichier de palette
(16 couleurs + police) définit l'apparence de kitty, hyprland, wofi et neovim (mini.base16).

## Usage

```bash
./apply-theme.sh <nom>      # change de thème
./apply-theme.sh            # réapplique le thème courant
./apply-theme.sh --list     # liste les thèmes disponibles
```

Le thème courant est mémorisé dans `.current-theme`.
Le script ne fait **aucun rechargement** (hormis `hyprctl reload` pour Hyprland).

## Structure

```
~/.config/theme/
├── themes/                  # palettes (une par thème)
│   ├── da-one-gray.env
│   └── ...
├── templates/               # templates par outil
│   ├── hypr.tmpl
│   ├── kitty.tmpl
│   ├── wofi.tmpl
│   └── nvim.tmpl
└── apply-theme.sh
```

## Ajouter un thème

```bash
cp themes/gruvbox.env themes/nord.env
$EDITOR themes/nord.env       # remplacer les 18 couleurs + la police
./apply-theme.sh nord
```

## Ajouter un outil

1. Créer `templates/<outil>.tmpl` avec des `${VARIABLE}` (majuscules).
2. Ajouter une ligne `render` dans `apply-theme.sh` pointant vers le
   répertoire de configuration de l'outil.
3. Pointer la config de l'outil vers le fichier généré (via `include`,
   `source`, `require`…) si nécessaire.
