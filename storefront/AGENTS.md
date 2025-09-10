# AGENTS Guidance (storefront)

Scope: This file applies to the entire repository. Read this first before making changes. It links process flow and docs for backend and components.

Core Rules
- Localization: Hungarian-first UI. Prefer Hungarian labels, keep high contrast and strong focus-visible rings.
- Guest checkout: Allowed. Show Edit on collapsed steps. Default “billing same as shipping” and skip billing; let users uncheck to edit billing.
- Countries: Limit selectable countries to Hungary (🇭🇺) and Slovakia (🇸🇰) in checkout. Currency: EUR.
- Links: Use `LocalizedClientLink` for country-aware routes (e.g., `/{countryCode}/store`).
- Performance: Prefer CSS gradients/patterns over heavy images; reduce large blurs/shadows; lazy-load non-critical images/components; avoid dev-only logs.
- Hero/Header Design (F1 Aesthetic):
  - Palette vars: `--f1: #E10600`, `--f1-dk` (darker), `--panel: rgba(20,20,22,.65)`, `--ring: rgba(225,6,0,.25)`.
  - Background: near-black with warehouse photo + gradient vignette for legibility.
  - Composition: left content panel (glass-carbon pit-wall), right wheel on tachometer ring; diagonal F1 red ribbon with soft glow; subtle, slow checker pattern + speed lines.
  - CTAs: primary solid F1 red pill; secondary translucent pill; third red-gradient “Árlista megtekintése” with sparkle; strong focus rings.
  - Motion: subtle, long loops (18–30s). Keep effects GPU-friendly.

Process Flow (high level)
1) Region select middleware: reads `x-vercel-ip-country` or default `NEXT_PUBLIC_DEFAULT_REGION`, fetches `/store/regions` with `x-publishable-api-key`, redirects to `/{countryCode}` if missing.
2) Navigation header loads cart + customer; search bar suggests products (`/api/suggest` → backend `/store/products?q=...`).
3) Product listing uses `listProductsWithSort` (backend `/store/products`).
4) Checkout steps: shipping-address → billing-address (auto-copied unless unchecked) → delivery → contact → payment.
5) Orders: `sdk.store.cart.complete` redirects to confirmation.

Docs
- Backend API and env: see `doc/backend.md`.
- Component map and responsibilities: see `doc/componenets.md`.

