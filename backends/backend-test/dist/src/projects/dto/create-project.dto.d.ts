import { Status } from "@prisma/client";
export declare class CreateProjectDto {
    name: string;
    status: Status;
    amount: number;
}
