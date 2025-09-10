# Backend Integration (teherguminet storefront)

This document lists the backend endpoints, headers, and env required by the storefront.

Base URL
- `NEXT_PUBLIC_MEDUSA_BACKEND_URL` (e.g., `http://localhost:9000`)
- All examples assume this as the origin.

Auth & Headers
- Public requests: include `x-publishable-api-key: <pk_...>` (attach publishable key to the store’s sales channel).
- Authenticated requests: JWT cookie `_medusa_jwt` (set via customer login/register).

CORS & Cookies (backend .env)
- `STORE_CORS=http://localhost:8000,http://localhost:8001`
- `ADMIN_CORS=http://localhost:7001,http://localhost:8001`
- `COOKIE_SECRET=<long-random>`

Key Endpoints Used
- Regions
  - GET `/store/regions`
  - Headers: `x-publishable-api-key`
  - Used by middleware to map `countryCode` to region, and by cart region updates.

- Products
  - GET `/store/products?q=<term>&limit=<n>&region_id=<id>`
  - Headers: `x-publishable-api-key` (public) OR auth for private data
  - Used by store listing and header suggestions.

- Customers
  - GET `/store/customers/me` — requires JWT
  - POST `/auth/customer/emailpass/register` — returns token
  - POST `/auth/customer/emailpass/login` — returns token
  - The storefront then calls `sdk.store.customer.create(...)` with bearer token to persist the customer entity.

- Cart
  - POST `/store/carts` (via SDK) — create cart with `region_id`
  - GET `/store/carts/:id`
  - POST `/store/carts/:id` — update (addresses, region, metadata, etc.)
  - POST `/store/carts/:id/line-items`, `.../shipping-methods`, etc.
  - POST `/store/carts/:id/complete` — completes order

B2B Extensions (required for full feature set)
- Company
  - POST `/store/companies` → create company (name, email, address, city, zip, country, currency_code=eur)
- Employees
  - POST `/store/companies/:company_id/employees` → link customer to company (is_admin, spending_limit)
- Approval Settings
  - POST `/store/companies/:company_id/approval-settings` → `{ requires_admin_approval }`
- Cart Approvals
  - POST `/store/carts/:cart_id/approvals` → request approval for a cart

Note: If these routes are not present, implement them in the backend module and secure with customer auth. See acceptance checks below.

Acceptance Checks
- `/store/regions` returns regions with `x-publishable-api-key`.
- Customer register/login returns JWT; `/store/customers/me` returns profile.
- `/store/products?q=hu&limit=3` returns search results.
- B2B routes respond 200 for authorized customers and fulfill company/employee flows.

cURL Cheatsheet
- Regions: `curl -H "x-publishable-api-key: pk_..." $BASE/store/regions`
- Search: `curl -H "x-publishable-api-key: pk_..." "$BASE/store/products?q=tire&limit=3"`
- Me: `curl -H "authorization: Bearer <token>" $BASE/store/customers/me`

