"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
const client_1 = require("@prisma/client");
const bcrypt = __importStar(require("bcrypt"));
const prisma = new client_1.PrismaClient();
async function main() {
    await prisma.project.deleteMany();
    await prisma.user.deleteMany();
    await prisma.project.createMany({
        data: [
            {
                id: "1",
                name: "Residence A",
                status: "PUBLISHED",
                amount: 120000,
                createdAt: new Date("2024-01-10T10:00:00Z"),
            },
            {
                id: "2",
                name: "Loft B",
                status: "DRAFT",
                amount: 85000,
                createdAt: new Date("2024-02-05T12:30:00Z"),
            },
            {
                id: "3",
                name: "Villa C",
                status: "ARCHIVED",
                amount: 240000,
                createdAt: new Date("2023-11-20T09:15:00Z"),
            },
            {
                id: "4",
                name: "Immeuble D",
                status: "PUBLISHED",
                amount: 410000,
                createdAt: new Date("2024-03-01T08:00:00Z"),
            },
            {
                id: "5",
                name: "Studio E",
                status: "DRAFT",
                amount: 60000,
                createdAt: new Date("2024-04-18T14:45:00Z"),
            },
        ],
    });
    await prisma.user.deleteMany({ where: { email: "admin@mail.com" } });
    const hashedPassword = await bcrypt.hash('123456789', 10);
    await prisma.user.create({
        data: {
            email: "admin@mail.com",
            password: hashedPassword,
        },
    });
    console.log(" Seed terminé !");
}
main()
    .catch((e) => {
    console.error(e);
    process.exit(1);
})
    .finally(async () => {
    await prisma.$disconnect();
});
//# sourceMappingURL=seed.js.map