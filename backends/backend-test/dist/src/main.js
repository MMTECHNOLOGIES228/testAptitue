"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const common_1 = require("@nestjs/common");
const core_1 = require("@nestjs/core");
const app_module_1 = require("./app.module");
async function bootstrap() {
    const app = await core_1.NestFactory.create(app_module_1.AppModule);
    const port = 9000;
    app.enableCors({
        origin: ["http://localhost:3000", "http://10.0.2.2:3000", "http://192.168.1.117:9000"],
        credentials: true,
    });
    app.useGlobalPipes(new common_1.ValidationPipe({ whitelist: true, forbidNonWhitelisted: true }));
    await app.listen(port);
    console.log(`🚀 Server is running at: http://localhost:${port}`);
}
bootstrap();
//# sourceMappingURL=main.js.map