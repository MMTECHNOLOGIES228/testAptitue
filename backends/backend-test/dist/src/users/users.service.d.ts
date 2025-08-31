import { PrismaService } from "../../prisma/prisma.service";
export declare class UsersService {
    private prisma;
    constructor(prisma: PrismaService);
    create(email: string, password: string): Promise<{
        email: string;
        id: string;
        password: string;
        createdAt: Date;
    }>;
    findByEmail(email: string): Promise<{
        email: string;
        id: string;
        password: string;
        createdAt: Date;
    } | null>;
}
