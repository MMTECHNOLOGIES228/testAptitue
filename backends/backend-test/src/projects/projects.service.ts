import { Injectable, NotFoundException } from "@nestjs/common";
import { PrismaService } from "../../prisma/prisma.service";
import { CreateProjectDto } from "./dto/create-project.dto";
import { UpdateProjectDto } from "./dto/update-project.dto";

@Injectable()
export class ProjectService {
  constructor(private prisma: PrismaService) {}

  async findAll(status?: string, q?: string, page = 1, pageSize = 10) {
    const where: any = {};
    if (status) where.status = status;
    if (q) where.name = { contains: q, mode: "insensitive" };

    return this.prisma.project.findMany({
      where,
      skip: (page - 1) * pageSize,
      take: pageSize,
    });
  }

  async create(dto: CreateProjectDto) {
    return this.prisma.project.create({ data: dto });
  }

  async update(id: string, dto: UpdateProjectDto) {
    const exists = await this.prisma.project.findUnique({ where: { id } });
    if (!exists) throw new NotFoundException("Project not found");

    return this.prisma.project.update({ where: { id }, data: dto });
  }

  async remove(id: string) {
    const exists = await this.prisma.project.findUnique({ where: { id } });
    if (!exists) throw new NotFoundException("Project not found");

    return this.prisma.project.delete({ where: { id } });
  }
}
