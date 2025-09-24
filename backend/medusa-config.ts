import { QUOTE_MODULE } from "./src/modules/quote";
import { APPROVAL_MODULE } from "./src/modules/approval";
import { COMPANY_MODULE } from "./src/modules/company";
import { loadEnv, defineConfig, Modules } from "@medusajs/framework/utils";

loadEnv(process.env.NODE_ENV!, process.cwd());

module.exports = defineConfig({
  // ✅ Medusa v2 Admin configuration (no plugin needed)
  // medusa.config.ts  (Medusa v2 style)
  admin: {
    path: "/app",
    backendUrl:
      process.env.MEDUSA_ADMIN_BACKEND_URL ?? "https://admin.teherguminet.hu",
    disable: false,
    vite: (config) => {
      // Serve admin under /app
      config.base = "/app/";

      // Bind inside container; let Traefik terminate TLS
      config.server = {
        ...(config.server ?? {}),
        host: "0.0.0.0",
        // DO NOT set `origin` (it can make Vite bind to that address)
        hmr: {
          protocol: "wss",
          host: "admin.teherguminet.hu",
          clientPort: 443,
          path: "/app",
          // DO NOT set `port` here → avoids random bind to public IP:port
        },
      };

      // B) De-dupe react-refresh (see below)
      const seen = new Set<string>();
      config.plugins = (config.plugins ?? []).filter((p: any) => {
        const name = p?.name ?? "";
        const isRefreshish =
          /react-refresh|vite:react-babel|vite:react-jsx/.test(name);
        if (!isRefreshish) return true;
        if (seen.has("react-refresh-family")) return false;
        seen.add("react-refresh-family");
        return true;
      });

      return config;
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
