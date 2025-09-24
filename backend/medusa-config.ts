import { QUOTE_MODULE } from "./src/modules/quote";
import { APPROVAL_MODULE } from "./src/modules/approval";
import { COMPANY_MODULE } from "./src/modules/company";
import { loadEnv, defineConfig, Modules } from "@medusajs/framework/utils";

loadEnv(process.env.NODE_ENV!, process.cwd());

module.exports = defineConfig({
  admin: {
    path: "/app",
    vite: (config) => {
      // Serve under /app and make HMR work through Traefik
      config.base = "/app/";
      config.server = {
        ...(config.server ?? {}),
        host: true,
        origin: "https://admin.teherguminet.hu",
        allowedHosts: ["admin.teherguminet.hu"],
        hmr: {
          host: "admin.teherguminet.hu",
          protocol: "wss",
          clientPort: 443,
          path: "/app",
        },
      };

      // 🔧 Dedupe react-refresh / react plugin injections
      const seen = new Set<string>();
      config.plugins = (config.plugins ?? []).filter((p: any) => {
        const name = p?.name ?? "";
        // Anything that injects refresh code
        const isRefreshish =
          /react-refresh|vite:react-babel|vite:react-jsx/.test(name);
        if (!isRefreshish) return true;

        if (seen.has("react-refresh-family")) {
          // drop subsequent duplicates
          return false;
        }
        seen.add("react-refresh-family");
        return true; // keep first occurrence
      });

      return config; // mutate & return
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
    [COMPANY_MODULE]: { resolve: "./modules/company" },
    [QUOTE_MODULE]: { resolve: "./modules/quote" },
    [APPROVAL_MODULE]: { resolve: "./modules/approval" },
    [Modules.CACHE]: { resolve: "@medusajs/medusa/cache-inmemory" },
    [Modules.WORKFLOW_ENGINE]: {
      resolve: "@medusajs/medusa/workflow-engine-inmemory",
    },
  },
});
