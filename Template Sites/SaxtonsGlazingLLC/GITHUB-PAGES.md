# Share this site via GitHub Pages

Preview URL (after setup):

**https://mrbobbyboykin.github.io/Projects/**

## One-time setup

1. **Push this folder** to your `Projects` repo on GitHub (`main` branch).

2. **Enable GitHub Pages** in the repo on GitHub:
   - Go to **Settings → Pages**
   - Under **Build and deployment → Source**, choose **GitHub Actions**

3. **Wait for the workflow** — after push, open the **Actions** tab and confirm **Deploy Saxtons Glazing preview** succeeds.

4. **Share the link** — send `https://mrbobbyboykin.github.io/Projects/` to anyone. No AWS required.

## How it works

- Site files live in `Template Sites/SaxtonsGlazingLLC/` on `main`
- `.github/workflows/deploy-saxtons-glazing-pages.yml` publishes only this folder to GitHub Pages
- Your portfolio projects on `main` stay unchanged; the public Pages URL shows this template site

## Update the live preview

Edit files in this folder, commit, and push to `main`. The workflow redeploys automatically.

## Notes

- Free GitHub Pages requires a **public** repo (or GitHub Pro for private repos)
- The contact form uses `mailto:` — works the same as locally
- When ready for production, deploy with Terraform in `terraform/` to AWS instead
