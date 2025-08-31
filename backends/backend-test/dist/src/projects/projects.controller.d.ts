import { ProjectService } from "./projects.service";
import { CreateProjectDto } from "./dto/create-project.dto";
import { UpdateProjectDto } from "./dto/update-project.dto";
export declare class ProjectController {
    private readonly projectService;
    constructor(projectService: ProjectService);
    findAll(status?: string, q?: string, page?: number, pageSize?: number): Promise<{
        id: string;
        createdAt: Date;
        name: string;
        status: import("@prisma/client").$Enums.Status;
        amount: number;
    }[]>;
    create(dto: CreateProjectDto): Promise<{
        id: string;
        createdAt: Date;
        name: string;
        status: import("@prisma/client").$Enums.Status;
        amount: number;
    }>;
    update(id: string, dto: UpdateProjectDto): Promise<{
        id: string;
        createdAt: Date;
        name: string;
        status: import("@prisma/client").$Enums.Status;
        amount: number;
    }>;
    remove(id: string): Promise<{
        id: string;
        createdAt: Date;
        name: string;
        status: import("@prisma/client").$Enums.Status;
        amount: number;
    }>;
}
