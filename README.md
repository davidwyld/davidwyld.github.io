# davidwyld.github.io

Built using quarto.

Previewing: `quarto preview`

Deploy: `quarto publish gh-pages`

## Updating publications

1. Export `publications.bib` in BibTeX format from Zotero or similar.
2. Run `pandoc publications.bib --standalone --from=bibtex --to=markdown --lua-filter filters/clean-publications.lua > publications.yml`
