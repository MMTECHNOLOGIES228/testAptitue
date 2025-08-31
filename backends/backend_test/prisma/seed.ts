import { PrismaClient } from "@prisma/client";
import * as bcrypt from 'bcrypt';

const prisma = new PrismaClient();


async function main() {
    //  On vide les données existantes (optionnel si tu veux repartir à zéro)
    await prisma.project.deleteMany();
    await prisma.user.deleteMany();

    //  Seed des projets
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


    //  Optionnel : seed d’un utilisateur test pour login
    await prisma.user.deleteMany({ where: { email: "admin@mail.com" } });
    const hashedPassword = await bcrypt.hash('123456789', 10);// "123456" hashé en bcrypt
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
