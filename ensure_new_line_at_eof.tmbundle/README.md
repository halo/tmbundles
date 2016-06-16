https://github.com/hajder/Ensure-New-Line-at-the-EOF.tmbundle

# Ensure New Line at the EOF

TextMate 2 bundle: Adds new line at EOL if missing in current document when saving. Inspired by [Strip Whitespace On Save by Ale Muñoz](https://github.com/bomberstudios/Strip-Whitespace-On-Save.tmbundle).

## Installation

- Clone the git repo to  `~/Library/Application Support/Avian/Bundles`
- Relaunch TextMate 2

## Customization using `.tm_properties`

Customizing the bundle is easy.

Suppose you want to avoid stripping white space on some specific files (like CSV and YAML). Just add the following to your `.tm_properties` file:

```ini
[*.csv]
scopeAttributes = attr.do-not-ensure-new-line

[*.yml]
scopeAttributes = attr.do-not-ensure-new-line
```

If you wanted to preserve whitespace for that messed-up whitespace project of yours, just drop this in its `.tm_properties` file:

```ini
scopeAttributes = attr.do-not-ensure-new-line
```

Of course, you can combine those two approaches for complete control.

If you want to know which scope corresponds to each language, just hit <kbd>^⇧P</kbd> (*Show Scope*) on a document of that type, and you'll get a nice tooltip with the scope namespaces that apply at the current cursor's position.

## Notes

**You need to be using at least TextMate version 2.0.0-alpha.9317**. Open Preferences » Software Update and **ALT-click the "Check Now"** button to get the most recent nightly build (this will grab a latest version than the one you get by just clicking the button).

Enjoy it!
