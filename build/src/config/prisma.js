var _a;
import { PrismaClient } from "../../generated/prisma/index.js";
const prisma = (_a = global.prisma) !== null && _a !== void 0 ? _a : new PrismaClient();
if (process.env.NODE_ENV !== "production") {
    global.prisma = prisma;
}
export default prisma;
//# sourceMappingURL=prisma.js.map