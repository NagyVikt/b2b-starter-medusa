import { QUOTE_MODULE } from "./src/modules/quote";
import { APPROVAL_MODULE } from "./src/modules/approval";
import { COMPANY_MODULE } from "./src/modules/company";
import { loadEnv, defineConfig, Modules } from "@medusajs/framework/utils";

loadEnv(process.env.NODE_ENV!, process.cwd());

module.exports = defineConfig({
  // ✅ Medusa v2 Admin configuration (no plugin needed)
  admin: {
    // where the admin is served by the backend
    path: "/app",

    // where the admin should talk to (your backend URL through Traefik)
    backendUrl:
      process.env.MEDUSA_ADMIN_BACKEND_URL ?? "https://admin.teherguminet.hu",

    // optional: ensure the admin is not disabled
    disable: false,

    // optional: tweak Vite so it works behind Traefik at /app with WSS HMR
    vite: (config) => {
      // Serve assets/modules under /app/
      config.base = "/app/";

      // Make dev server bind correctly and use WSS over your domain
      config.server = {
        ...(config.server ?? {}),
        host: true,
        origin: "https://admin.teherguminet.hu",
        allowedHosts: ["admin.teherguminet.hu"],
        hmr: {
          protocol: "wss",
          host: "admin.teherguminet.hu",
          clientPort: 443,
          path: "/app",
        },
      };

      return config; // mutate & return (prevents duplicate react-refresh)
    },
  },

  projectConfig: {
    databaseUrl: process.env.DATABASE_URL,
    // ✅ expose Redis so you don’t get “fake redis” message
    redisUrl: process.env.REDIS_URL,
    http: {
      storeCors: process.env.STORE_CORS!,
      adminCors: process.env.ADMIN_CORS!,
      authCors: process.env.AUTH_CORS!,
      jwtSecret: process.env.JWT_SECRET || "supersecret",
      cookieSecret: process.env.COOKIE_SECRET || "supersecret",
    },
  },

  modules: {
    [COMPANY_MODULE]: { resolve: "./modules/company" },
    [QUOTE_MODULE]: { resolve: "./modules/quote" },
    [APPROVAL_MODULE]: { resolve: "./modules/approval" },
    [Modules.CACHE]: { resolve: "@medusajs/medusa/cache-inmemory" },
    [Modules.WORKFLOW_ENGINE]: {
      resolve: "@medusajs/medusa/workflow-engine-inmemory",
    },
  },
});
