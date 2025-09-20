var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
import AdminJS from 'adminjs';
import AdminJSExpress from '@adminjs/express';
import express from 'express';
import Connect from 'connect-pg-simple';
import session from 'express-session';
import prisma from '../config/prisma.js';
import { Database, Resource, getModelByName } from '@adminjs/prisma';
AdminJS.registerAdapter({ Database, Resource });
const PORT = 3000;
const DEFAULT_ADMIN = {
    email: 'admin@example.com',
    password: 'password',
};
const authenticate = (email, password) => __awaiter(void 0, void 0, void 0, function* () {
    if (email === DEFAULT_ADMIN.email && password === DEFAULT_ADMIN.password) {
        return Promise.resolve(DEFAULT_ADMIN);
    }
    return null;
});
const adminOptions = {
    resources: [{
            resource: { model: getModelByName('Post'), client: prisma },
            options: {},
        }, {
            resource: { model: getModelByName('Profile'), client: prisma },
            options: {},
        }, {
            resource: { model: getModelByName('Publisher'), client: prisma },
            options: {},
        }],
};
export const buildAdminRouter = (app) => __awaiter(void 0, void 0, void 0, function* () {
    const admin = new AdminJS({});
    const ConnectSession = Connect(session);
    const sessionStore = new ConnectSession({
        conObject: {
            connectionString: 'postgres://adminjs:@localhost:5432/adminjs',
            ssl: process.env.NODE_ENV === 'production',
        },
        tableName: 'session',
        createTableIfMissing: true,
    });
    const adminRouter = AdminJSExpress.buildAuthenticatedRouter(admin, {
        authenticate,
        cookieName: 'adminjs',
        cookiePassword: 'sessionsecret',
    }, null, {
        store: sessionStore,
        resave: true,
        saveUninitialized: true,
        secret: 'sessionsecret',
        cookie: {
            httpOnly: process.env.NODE_ENV === 'production',
            secure: process.env.NODE_ENV === 'production',
        },
        name: 'adminjs',
    });
    app.use(admin.options.rootPath, adminRouter);
    app.listen(PORT, () => {
        console.log(`AdminJS started on http://localhost:${PORT}${admin.options.rootPath}`);
    });
});
//# sourceMappingURL=setup.js.map