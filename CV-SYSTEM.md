# Job-application system

A small, repeatable system for applying to jobs. Everything lives in this repo — no build
step, no tooling. **`MASTER-CV.md` is the single source of truth and the generator**; you
tailor from it per application.

## The one file that drives everything

**`MASTER-CV.md`** holds the full record (every role, project, number), the voice guide, the
truthfulness guardrails, the role variants + keyword banks, and the recipes for writing a
cover letter (§10) and a one-page CV (§11). To apply: paste the job ad into its §13 and
generate the two documents from it. Facts flow **one way** — from `MASTER-CV.md` outward —
so nothing you send can contradict anything else.

## The four things you send per application

| Artifact | Source | Notes |
|---|---|---|
| **1. Tailored one-page CV** | `one-pager-cv.html` → Print to PDF | Built from `MASTER-CV.md` + the job ad. Carries a tailored profile + skills. |
| **2. Cover letter** | `MASTER-CV.md` §10 recipe | Tailored to the role; ~1 page. |
| **3. Case study** | a small project you build for the role | Links to the portfolio; if rejected, fold it into `projects/`. |
| **4. Portfolio website** | the live site (`index.html`) | The "web CV," with the coaching link and the CV download. |

## The files

| File | What it is |
|---|---|
| `MASTER-CV.md` | **The single source of truth + generator.** Full record, voice, guardrails, variants, and the cover-letter / one-pager recipes. Private — never sent. |
| `master-cv.html` | The **public detailed background CV** (live web CV + PDF source), derived from `MASTER-CV.md`. **No profile/skills section, by design** — those are added per job on the one-pager. |
| `one-pager-cv.html` | **Copy-me template** for a job-tailored one-pager: profile + core skills + selected projects + trimmed experience. Tuned to print to one A4 page. |
| `cv-print.css` | Print/PDF styling for both CV pages. |
| `assets/CV_Meric_Erler.pdf` | The downloadable PDF, regenerated from `master-cv.html` (see below). |

## Workflow

### A. Keep the record current
1. Edit the fact in **`MASTER-CV.md` first** (it's the source of truth), then mirror it into
   `master-cv.html`. Never the other way round.
2. Regenerate the PDF: open `master-cv.html` in a browser → **Print → Save as PDF → A4** →
   save **over** `assets/CV_Meric_Erler.pdf`. The print stylesheet hides nav/footer and forces
   a clean light theme automatically.
3. Commit.

### B. Tailor a one-pager for a specific job
1. Duplicate `one-pager-cv.html` (e.g. `applications/one-pager-cv-<company>.html`).
2. Work through every `<!-- TAILOR -->` block using the job ad, pasting the matching variant,
   keywords and domain skill-row from **`MASTER-CV.md` §9** (also mirrored as comments in
   `one-pager-cv.html`):
   - **Title-line + Profile** — pick the role variant; tune the first clause to the ad.
   - **Core skills** — keep/reorder the groups the ad asks for; swap the `Domain` row.
   - **Selected projects** — the 2–3 closest; the case study you built goes first.
   - **Experience** — the 3–4 relevant roles, trimmed to their best 1–2 bullets.
3. **Only use facts that are also in `MASTER-CV.md`.** Never invent dates, titles, or numbers.
4. Print → Save as PDF (tuned to one page). Rename `Meric_Erler_CV_<Role>.pdf`, run the
   pre-send checklist in **`MASTER-CV.md` §11**, and attach it with the cover letter.

### C. The per-application case study
1. Build a small, focused case study for the role (the way `IdleBankTycoonCaseStudy` was built
   for a game-economy job).
2. Link it from the cover letter and the one-pager.
3. **If the application is rejected**, add it to the portfolio: create a `projects/<name>.html`
   page (copy an existing project page as the template), add a card to the `#work` or `#games`
   grid in `index.html`, and link it from `master-cv.html`.

## Ground rules
- One source of truth: facts flow **from `MASTER-CV.md`** → `master-cv.html` → the one-pager,
  never the other way.
- No fabrication: numbers, dates, and titles must match `MASTER-CV.md`.
- `master-cv.html` stays profile/skills-free on purpose — those belong only on the tailored
  one-pager. Don't re-add them (there's a standing comment in the file).
- Phone number is intentionally omitted from the CV pages — add it in one place (the contact
  band) if you want it on the PDF.
