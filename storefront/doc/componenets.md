# Component Map (storefront)

> Note: File paths are relative to `src/`.

Navigation & Layout
- `modules/layout/templates/nav/index.tsx` — Sticky header, brand, mega menu, search, account/cart buttons.
- `modules/layout/components/mega-menu/mega-menu.tsx` — Products mega menu (categories).
- `modules/layout/components/search-bar/index.tsx` — Header search with live suggestions (`/api/suggest`).
- `modules/layout/templates/footer/index.tsx` — Footer.
- `app/layout.tsx` — Global layout, preconnect to backend, toaster, analytics.

Home (Hero & Featured)
- `modules/home/components/hero/index.tsx` — F1-styled hero (Tehergumi), background, diagonal ribbon, wheel visual, CTAs.
- `modules/home/components/featured-products` — Featured grid (suspense/lazy).

Store & Products
- `app/[countryCode]/(main)/store/page.tsx` — Storefront listing, reads `q`, renders filters and product grid.
- `modules/store/templates/paginated-products.tsx` — Fetches and lists products (region-aware), pagination.
- `modules/products/components/product-preview` — Product tile.

Cart
- `modules/cart/components/cart-drawer/index.tsx` — Drawer mini-cart, checkout button.
- `modules/cart/templates/index.tsx` — Full cart page (items + summary + login prompt removed for guest checkout).

Checkout
- `modules/checkout/components/shipping-address` — Shipping step (HU/SK only, flags, edit when collapsed, “same as billing” checkbox).
- `modules/checkout/components/billing-address` — Billing step (auto-skip when same as shipping; edit chip on collapsed; link back to shipping removed and unified into shipping widget).
- `modules/checkout/components/shipping` — Delivery/shipping methods.
- `modules/checkout/components/payment` — Payment step.
- `modules/checkout/components/contact-details` — Email + notes.
- `lib/data/cart.ts` — Server actions for address updates, payment, placing order.

Middleware & Data
- `middleware.ts` — Country routing, regions fetch with publishable key.
- `lib/data/*` — SDK-backed server actions (cart, customer, products, regions).
- `app/api/suggest/route.ts` — Live suggestions API → backend `/store/products?q=...`.

Docs
- `doc/backend.md` — Backend endpoints and env.
- `AGENTS.md` — Rules and process flow.

