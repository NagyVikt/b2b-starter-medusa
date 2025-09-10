
# Medusa v2: Implementing B2B (Companies, Employees, Approvals)

This guide explains how to implement the B2B features our storefront expects using Medusa v2 modules (no `medusa-extender`). It covers entities, services, HTTP routes, and configuration so the frontend endpoints work.

## What the storefront calls

Public (publishable key header `x-publishable-api-key`):
- GET `/store/regions`
- GET `/store/products?q=...&limit=...`

Customer (JWT cookie `_medusa_jwt`):
- POST `/auth/customer/emailpass/register` (returns token)
- POST `/auth/customer/emailpass/login` (returns token)
- GET `/store/customers/me`

B2B (customer auth required):
- POST `/store/companies` → create company
- POST `/store/companies/:company_id/employees` → add employee (link customer)
- POST `/store/companies/:company_id/approval-settings` → toggle approvals
- POST `/store/carts/:cart_id/approvals` → request cart approval

The storefront already handles guest checkout and normal customer registration. These endpoints enable company flows.

## Prerequisites
- Medusa v2 project (modules architecture).
- Postgres configured.
- Customer auth strategy for email/password enabled.
- Sales Channel + Publishable Key created and attached (so regions/products endpoints accept the header).

Backend env (examples):
```
PORT=9000
STORE_CORS=http://localhost:8000,http://localhost:8001
ADMIN_CORS=http://localhost:7001,http://localhost:8001
COOKIE_SECRET=<random-long-string>
```

## Module overview (b2b)
Create a custom module (e.g., `src/modules/b2b`) with:
- Entities: `Company`, `Employee`, `CartApproval`
- Services: encapsulate business logic
- HTTP routes: expose the 4 B2B endpoints above
- Migrations: create tables/indices

Suggested tree:
```
src/modules/b2b/
  entities/
    company.entity.ts
    employee.entity.ts
    cart-approval.entity.ts
  repositories/
    company.repository.ts
    employee.repository.ts
    cart-approval.repository.ts
  services/
    company.service.ts
    employee.service.ts
    approval.service.ts
  http/
    store.routes.ts      # defines /store/* routes
  migrations/
    1700000000000_init_company_employee.ts
    1700000001000_init_cart_approval.ts
  b2b.module.ts          # registers entities, services, routes, migrations
```

> Note: Use your project’s ORM/libs (MikroORM/TypeORM) consistent with v2 setup.

### Entities (fields)
- Company: `id`, `name`, `email`, `phone?`, `address`, `city`, `state?`, `zip`, `country`, `currency_code` (use `"eur"`), `approval_settings` JSON, timestamps.
- Employee: `id`, `company_id` (FK), `customer_id` (FK), `is_admin`, `spending_limit` (integer), timestamps.
- CartApproval: `id`, `cart_id` (FK), `status` (e.g., `pending|approved|rejected`), `requested_by` (customer_id), `metadata` JSON, timestamps.

### Services
- CompanyService
  - `createCompany(data)`
  - `updateApprovalSettings(companyId, requires_admin_approval)`
- EmployeeService
  - `addEmployee(companyId, { customer_id, is_admin, spending_limit })`
- ApprovalService
  - `requestCartApproval(cartId, requestedBy)`

Enforce authorization (customer must own/administrate the company where applicable).

### HTTP routes (store scope)
Implement a store HTTP router that:
- Reads the logged-in customer from the request context/auth container.
- Validates request bodies (basic zod/validator).
- Calls services and returns `{ company }`, `{ employee }`, `{ approval }`.

Examples (pseudo/TypeScript, adapt to your router abstraction):
```ts
// store.routes.ts
import type { Router } from "@medusajs/framework" // adjust to your setup

export default function registerStoreB2BRoutes(router: Router, container: any) {
  const companyService = container.resolve("companyService")
  const employeeService = container.resolve("employeeService")
  const approvalService = container.resolve("approvalService")

  // Require customer auth middleware on these routes
  const requireCustomer = container.resolve("requireCustomerMiddleware")

  router.post("/store/companies", requireCustomer, async (req, res) => {
    const { name, email, phone, address, city, state, zip, country, currency_code } = req.body
    const company = await companyService.createCompany({
      name, email, phone, address, city, state, zip, country, currency_code: currency_code ?? "eur",
    }, req.user.id)
    res.json({ company })
  })

  router.post("/store/companies/:company_id/employees", requireCustomer, async (req, res) => {
    const { company_id } = req.params
    const { customer_id, is_admin, spending_limit } = req.body
    // ensure req.user has admin rights on company_id inside service
    const employee = await employeeService.addEmployee(company_id, { customer_id, is_admin, spending_limit })
    res.json({ employee })
  })

  router.post("/store/companies/:company_id/approval-settings", requireCustomer, async (req, res) => {
    const { company_id } = req.params
    const { requires_admin_approval } = req.body
    const company = await companyService.updateApprovalSettings(company_id, requires_admin_approval)
    res.json({ company })
  })

  router.post("/store/carts/:cart_id/approvals", requireCustomer, async (req, res) => {
    const { cart_id } = req.params
    const approval = await approvalService.requestCartApproval(cart_id, req.user.id)
    res.json({ approval })
  })
}
```

### Module registration
Export a module file that registers:
- Entities/repositories
- Services
- HTTP routes registrar
- Migrations
Then add your module to the Medusa v2 config so it’s loaded at boot.

### Migrations
Add migrations for each entity table and any indices. Ensure your CLI (e.g., MikroORM) discovers these files. Run migrations during deploy.

## Customer auth (email/password)
Enable the email/password strategy for customers in your v2 auth module. Verify endpoints:
- `POST /auth/customer/emailpass/register` → 200 token
- `POST /auth/customer/emailpass/login` → 200 token
- `GET /store/customers/me` with JWT returns the profile
The storefront uses these flows and stores JWT in `_medusa_jwt`.

## Sales Channel + Publishable Key
- Create a publishable key in Admin.
- Attach it to the Sales Channel used by your store.
- Put it in storefront `.env` as `NEXT_PUBLIC_MEDUSA_PUBLISHABLE_KEY=pk_...`.
- Confirm:
  - `curl -H "x-publishable-api-key: pk_..." $BASE/store/regions`
  - `curl -H "x-publishable-api-key: pk_..." "$BASE/store/products?q=tire&limit=3"`

## Acceptance checklist
- Storefront `/[cc]/store` loads products and regions with publishable key.
- Register/login works; `/[cc]/account` loads without 403.
- POST `/store/companies` creates a company; employees & approval settings update work.
- POST `/store/carts/:cart_id/approvals` returns an approval object.

## Notes
- Keep endpoints idempotent where sensible.
- Return small JSON envelopes `{ company }`, `{ employee }`, `{ approval }` to match the frontend expectations.
- Log and 403 on unauthorized access; don’t leak details.

If you want, I can scaffold a ready-to-drop `src/modules/b2b` with entities/services/routes adapted to your v2 project structure once you share the backend repo.
