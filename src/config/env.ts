

import dotenv from "dotenv";

dotenv.config();

export const PORT = process.env.PORT || 3000;
export const DATABASE_URL = process.env.DATABASE_URL;
export const ACCESS_TOKEN_SECRET = process.env.ACCESS_TOKEN_SECRET;
export const REFRESH_TOKEN_SECRET = process.env.REFRESH_TOKEN_SECRET;
export const COOKIE_PASSWORD = process.env.COOKIE_PASSWORD;
export const ADMIN_LOGIN_EMAIL = process.env.ADMIN_LOGIN_EMAIL;
export const ADMIN_LOGIN_PASSWORD = process.env.ADMIN_LOGIN_PASSWORD;