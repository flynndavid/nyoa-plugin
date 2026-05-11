# Neighborhood Landing Pages

Written by `/nyoa-neighborhood-page`. One file per neighborhood, named `<slug>.md` (e.g., `east-nashville.md`, `lockeland-springs.md`).

Each file is a CMS-ready Markdown page: title, meta description, H1, intro paragraph, 4-5 feature blocks with H2s as questions, 3 schema-ready FAQs, CTA block, compliance footer.

## Convention

- File name: lowercase, dash-separated slug.
- One file per neighborhood. If the agent re-runs with updates, the prior version is backed up to `<slug>.bak.md` before the new one is written.
- Internal-link suggestions in the page point to other files in this folder when they exist.

## Compliance

Every page in this folder is written under NYOA's neighborhood-page Fair Housing rules. The skill won't generate a page that violates them — and if a prior version stored here predates v0.7.0, run `/nyoa-neighborhood-page` again to regenerate with current compliance.
