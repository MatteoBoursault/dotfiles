# Theme

Système de thèmes centralisé pour mes dotfiles. Un seul fichier de palette
définit les couleurs et la police pour kitty, hyprland, wofi et yazi.

## Usage

```bash
./apply-theme.sh <nom>      # change de thème
./apply-theme.sh            # réapplique le thème courant
./apply-theme.sh --list     # liste les thèmes disponibles
```

Le thème courant est mémorisé dans `.current-theme`.
Le script ne fait **aucun rechargement** (hormis `hyprctl reload` pour Hyprland).

## Thèmes fournis

| Thème              | Police             |
|--------------------|--------------------|
| `catppuccin-mocha` | `0xProtoNerdFont`  |
| `gruvbox`          | `Hack Nerd Font`   |

## Structure

```
~/.config/theme/
├── themes/                  # palettes (une par thème)
│   ├── catppuccin-mocha.env
│   └── gruvbox.env
├── templates/               # templates par outil
│   ├── hypr.conf.tmpl
│   ├── kitty.conf.tmpl
│   ├── wofi-style.css.tmpl
│   └── yazi-theme.toml.tmpl
├── apply-theme.sh           # envsubst sur les templates
├── hypr.conf      ─┐
└── kitty.conf     ─┴ fichiers générés (ne pas éditer)
```

Fichiers aussi générés ailleurs :
- `~/.config/wofi/style.css`
- `~/.config/yazi/theme.toml`

Les configs des outils pointent vers les fichiers générés :
- `hyprland.conf` : `source = ~/.config/theme/hypr.conf`
- `kitty.conf`    : `include ~/.config/theme/kitty.conf`

## Convention de nommage

Toutes les palettes définissent les mêmes variables, donc les templates
sont indépendants du thème.

| Variable                                    | Rôle                                |
|---------------------------------------------|-------------------------------------|
| `BG0`…`BG5`                                 | Fonds, du plus sombre au plus clair |
| `FG0`…`FG3`                                 | Textes, du plus visible au plus discret |
| `RED` `GREEN` `YELLOW` `BLUE` `MAGENTA` `CYAN` `ORANGE` `PURPLE` | Couleurs ANSI |
| `ACCENT`                                    | Couleur d'accentuation principale   |
| `BORDER`                                    | Bordures discrètes                  |
| `FONT_MONO`, `FONT_MONO_SIZE`               | Police monospace                    |

Format des `.env` : variables shell, valeurs hex sans `#`. Les valeurs
contenant des espaces doivent être entre guillemets (`FONT_MONO="Hack Nerd Font"`).

## Ajouter un thème

```bash
cp themes/gruvbox.env themes/nord.env
$EDITOR themes/nord.env       # remplacer hex et fonts
./apply-theme.sh nord
```

## Ajouter un outil

1. Créer `templates/<outil>.tmpl` avec des `${VARIABLE}` (majuscules).
2. Ajouter une ligne `render` dans `apply-theme.sh`.
3. Pointer la config de l'outil vers le fichier généré (via `include`,
   `source`, ou en générant directement dans son dossier).

## Fonctionnement interne

`apply-theme.sh` :
1. `source` le fichier `themes/<nom>.env` (charge les variables).
2. Pour chaque template, lance `envsubst` avec une **whitelist** des
   variables connues : seules ces variables sont substituées, les autres
   `$xxx` (comme `$bg0` dans la sortie hypr) restent littéraux.
3. Écrit le nom du thème dans `.current-theme`.
