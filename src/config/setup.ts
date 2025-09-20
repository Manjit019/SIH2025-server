import { PrismaClient, Prisma } from "@prisma/client";
import AdminJS from "adminjs";
import AdminJSExpress from "@adminjs/express";
import express from "express";
import Connect from "connect-pg-simple";
import session from "express-session";
import { Database, Resource, getModelByName } from "@adminjs/prisma";
import { ADMIN_LOGIN_EMAIL, ADMIN_LOGIN_PASSWORD, COOKIE_PASSWORD, DATABASE_URL, PORT } from "./env";

const prisma = new PrismaClient();
AdminJS.registerAdapter({ Database, Resource });

const DEFAULT_ADMIN = {
  email: ADMIN_LOGIN_EMAIL || "admin@example.com",
  password: ADMIN_LOGIN_PASSWORD || "password",
};

const authenticate = async (email: string, password: string) => {
  if (email === DEFAULT_ADMIN.email && password === DEFAULT_ADMIN.password) {
    return Promise.resolve(DEFAULT_ADMIN);
  }
  return null;
};

const adminOptions = {
  resources: [
    {
      resource: {
        model: getModelByName("MigrantWorker", { Prisma }),
        client: prisma,
      },
      options: {},
    },
    {
      resource: {
        model: getModelByName("HealthRecord", { Prisma }),
        client: prisma,
      },
      options: {},
    },
    {
      resource: {
        model: getModelByName("Vaccination", { Prisma }),
        client: prisma,
      },
      options: {},
    },
    {
      resource: {
        model: getModelByName("HealthPass", { Prisma }),
        client: prisma,
      },
      options: {},
    },
    {
      resource: {
        model: getModelByName("Employement", { Prisma }),
        client: prisma,
      },
      options: {},
    },
    {
      resource: { model: getModelByName("Admin", { Prisma }), client: prisma },
      options: {},
    },
    {
      resource: {
        model: getModelByName("AuditLog", { Prisma }),
        client: prisma,
      },
      options: {},
    },
    {
      resource: { model: getModelByName("Doctor", { Prisma }), client: prisma },
      options: {},
    },
    {
      resource: {
        model: getModelByName("Hospital", { Prisma }),
        client: prisma,
      },
      options: {},
    },
  ],
};

const admin = new AdminJS({
  resources: adminOptions.resources,
  rootPath: "/admin",
  branding: {
    companyName: "Care Hackers",
    withMadeWithLove: false,
    theme: {
      colors: {
        primary100: "#e58b1eff",
        primary80: "#f5a442ff",
        primary60: "#f69564ff",
        primary40: "#f9c490ff",
        primary20: "#fbd7bbff",
      },
    },
  },
});

export const buildAdminRouter = async (app: express.Application) => {

  const ConnectSession = Connect(session);
  const sessionStore = new ConnectSession({
    conObject: {
      connectionString: DATABASE_URL,
      ssl: process.env.NODE_ENV === "production",
    },
    tableName: "session",
    createTableIfMissing: true,
  });

  const adminRouter = AdminJSExpress.buildAuthenticatedRouter(
    admin,
    {
      authenticate,
      cookieName: "adminjs",
      cookiePassword: COOKIE_PASSWORD || "sessionsecret",
    },
    null,
    {
      store: sessionStore,
      resave: false,
      saveUninitialized: true,
      secret: COOKIE_PASSWORD || "sessionsecret",
      cookie: {
        httpOnly: process.env.NODE_ENV === "production",
        secure: process.env.NODE_ENV === "production",
        sameSite: "lax",
        maxAge: 1000 * 60 * 60 * 24,
      },
      name: "adminjs",
    }
  );
  app.use(admin.options.rootPath, adminRouter);

  app.listen(PORT, () => {
    console.log(
      `AdminJS started on http://localhost:${PORT}${admin.options.rootPath}`
    );
  });
};
