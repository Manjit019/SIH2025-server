
import prisma from "./prisma"

const connectDB = async () => {
    try {
        await prisma.$connect();
        console.log("Database connected successfully ✅ ");
    } catch (error) {
        console.log("Database connection failed ❌");
        console.log(error);
    }
};

export default connectDB;