// import { NestFactory } from '@nestjs/core';
// import { AppModule } from './app.module';
// import { ValidationPipe } from "@nestjs/common";

// async function bootstrap() {
//   const app = await NestFactory.create(AppModule);
//   // 
//   app.enableCors({
//     origin: ["http://localhost:3000", "http://10.0.2.2:3000"],
//     credentials: true,
//   });
//   app.useGlobalPipes(new ValidationPipe({ whitelist: true, forbidNonWhitelisted: true }));
//   // 
//   await app.listen(process.env.PORT ?? 3000);
// }
// bootstrap();
// import { ValidationPipe } from "@nestjs/common";
// import { NestFactory } from "@nestjs/core";
// import { AppModule } from "./app.module";

// async function bootstrap() {
//   const app = await NestFactory.create(AppModule);

//   app.enableCors({
//     origin: ["http://localhost:3000", "http://10.0.2.2:3000"],
//     credentials: true,
//   });

//   app.useGlobalPipes(new ValidationPipe({ whitelist: true, forbidNonWhitelisted: true }));

//   await app.listen(9000);
// }
// bootstrap();

import { ValidationPipe } from "@nestjs/common";
import { NestFactory } from "@nestjs/core";
import { AppModule } from "./app.module";

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  const port = 9000;

  app.enableCors({
    origin: ["http://localhost:3000", "http://10.0.2.2:3000", "http://192.168.1.117:9000"],
    credentials: true,
  });

  app.useGlobalPipes(
    new ValidationPipe({ whitelist: true, forbidNonWhitelisted: true })
  );

  await app.listen(port);

  console.log(`Server is running at: http://localhost:${port}`);
}
bootstrap();

