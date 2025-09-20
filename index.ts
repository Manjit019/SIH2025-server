
import express from "express";
import cors from "cors";
import { buildAdminRouter } from "./src/config/setup";
import { connectDB } from "./src/config/connectDB";
import { PORT } from "./src/config/env";
import bodyParser from "body-parser";

const app = express();

app.use(
  cors({
    origin: `http://localhost:${PORT}`,
    credentials: true,
  })
);
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(bodyParser.json({ limit: "50mb" }));


async function start() {

  await connectDB();

  await buildAdminRouter(app);
  

  app.get("/", (req, res) => {
    res.send("Hello World! Server is running🎉");
  });


  app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
  });
}

start();
