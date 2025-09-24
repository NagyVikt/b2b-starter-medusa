import { QUOTE_MODULE } from "./src/modules/quote";
import { APPROVAL_MODULE } from "./src/modules/approval";
import { COMPANY_MODULE } from "./src/modules/company";
import { loadEnv, defineConfig, Modules } from "@medusajs/framework/utils";

loadEnv(process.env.NODE_ENV!, process.cwd());

module.exports = defineConfig({
  // ✅ Admin plugin configuration
  plugins: [
    {
      resolve: "@medusajs/admin",
      /** @type {import('@medusajs/admin').PluginOptions} */
      options: {
        // Serve the admin with the backend under /app
        serve: true,
        path: "/app",

        // Tell the admin where your backend is (via Traefik)
        // For production builds, also set MEDUSA_ADMIN_BACKEND_URL to this.
        backend: "https://admin.teherguminet.hu",

        // Make the dev server line up with your reverse proxy/domain
        develop: {
          host: "admin.teherguminet.hu",
          port: 9000,
          allowedHosts: "auto",
          // Force HMR over WSS through your domain, under /app
          webSocketURL: "wss://admin.teherguminet.hu/app",
          // Optional niceties:
          // open: false,
          // logLevel: "error",
          // stats: "normal",
        },
      },
    },
  ],

  projectConfig: {
    databaseUrl: process.env.DATABASE_URL,
    http: {
      storeCors: process.env.STORE_CORS!,
      adminCors: process.env.ADMIN_CORS!,
      authCors: process.env.AUTH_CORS!,
      jwtSecret: process.env.JWT_SECRET || "supersecret",
      cookieSecret: process.env.COOKIE_SECRET || "supersecret",
    },
  },

  modules: {
    [COMPANY_MODULE]: {
      resolve: "./modules/company",
    },
    [QUOTE_MODULE]: {
      resolve: "./modules/quote",
    },
    [APPROVAL_MODULE]: {
      resolve: "./modules/approval",
    },
    [Modules.CACHE]: {
      resolve: "@medusajs/medusa/cache-inmemory",
    },
    [Modules.WORKFLOW_ENGINE]: {
      resolve: "@medusajs/medusa/workflow-engine-inmemory",
    },
  },
});
