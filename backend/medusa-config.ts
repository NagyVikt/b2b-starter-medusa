import { QUOTE_MODULE } from "./src/modules/quote";
import { APPROVAL_MODULE } from "./src/modules/approval";
import { COMPANY_MODULE } from "./src/modules/company";
import { loadEnv, defineConfig, Modules } from "@medusajs/framework/utils";

loadEnv(process.env.NODE_ENV!, process.cwd());

module.exports = defineConfig({
  admin: {
    path: "/app",
    vite: (config) => {
      // Make Vite serve everything under /app/
      config.base = "/app/";

      // Server + HMR behind HTTPS reverse proxy at admin.teherguminet.hu
      config.server = {
        ...(config.server ?? {}),
        host: true, // bind 0.0.0.0
        origin: "https://admin.teherguminet.hu",
        allowedHosts: ["admin.teherguminet.hu"],
        hmr: {
          host: "admin.teherguminet.hu",
          protocol: "wss",
          clientPort: 443,
          path: "/app",
        },
      };

      return config; // mutate & return (avoid duplicating plugins)
    },
  },

  projectConfig: {
    databaseUrl: process.env.DATABASE_URL,
    http: {
      storeCors: process.env.STORE_CORS!,
      adminCors: process.env.ADMIN_CORS!,
      authCors: process.env.AUTH_CORS!,
      jwtSecret: process.env.JWT_SECRET || "supersecret",
      cookieSecret: process.env.COOKIE_SECRET || "supersecret",
    },
    databaseDriverOptions: {
      ssl: false,
      sslmode: "disable",
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
