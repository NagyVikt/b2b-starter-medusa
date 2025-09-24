import { QUOTE_MODULE } from "./src/modules/quote";
import { APPROVAL_MODULE } from "./src/modules/approval";
import { COMPANY_MODULE } from "./src/modules/company";
import { loadEnv, defineConfig, Modules } from "@medusajs/framework/utils";

loadEnv(process.env.NODE_ENV!, process.cwd());

/**
 * Medusa v2 configuration
 * - Admin is configured under the `admin` key (no v1 plugin)
 * - Admin path: /app
 * - Backend URL: from MEDUSA_ADMIN_BACKEND_URL or your domain
 * - Vite HMR configured for Traefik + HTTPS
 */
module.exports = defineConfig({
  admin: {
    // v1 `serve: true`  -> v2 `disable: false`
    disable: false,

    // v1 `path: "/app"`
    path: "/app",

    // v1 `backend: "https://example.com"` -> v2 `backendUrl`
    backendUrl:
      process.env.MEDUSA_ADMIN_BACKEND_URL ?? "https://admin.teherguminet.hu",

    // Vite config hook to play nice with Traefik, HTTPS, and avoid HMR/IP binding issues
    vite: (config: any) => {
      // Ensure admin assets are served under /app
      config.base = "/app/";

      // Dev server in container
      config.server = {
        ...(config.server ?? {}),
        host: true, // bind 0.0.0.0 in container
        // DO NOT force .origin (can cause bad binds)
        hmr: {
          protocol: "wss",
          host: "admin.teherguminet.hu",
          clientPort: 443,
          path: "/app",
        },
      };

      // Prevent duplicated react-refresh causing “inWebWorker/prevRefreshReg... already declared”
      const seen = new Set<string>();
      config.plugins = (config.plugins ?? []).filter((p: any) => {
        const name = p?.name ?? "";
        const isRefreshFamily =
          /react-refresh|vite:react-babel|vite:react-jsx/.test(name);
        if (!isRefreshFamily) return true;
        if (seen.has("react-refresh-family")) return false;
        seen.add("react-refresh-family");
        return true;
      });

      return config;
    },
  },

  projectConfig: {
    databaseUrl: process.env.DATABASE_URL, // comes from compose
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

    // In-memory cache & workflow engine (swap for prod as needed)
    [Modules.CACHE]: { resolve: "@medusajs/medusa/cache-inmemory" },
    [Modules.WORKFLOW_ENGINE]: {
      resolve: "@medusajs/medusa/workflow-engine-inmemory",
    },
  },
});
