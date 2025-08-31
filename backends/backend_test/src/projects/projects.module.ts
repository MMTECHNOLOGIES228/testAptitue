import { Module } from "@nestjs/common";
import { ProjectService } from "./projects.service";
import { ProjectController } from "./projects.controller";
import { PrismaService } from "../../prisma/prisma.service";

@Module({
  controllers: [ProjectController],
  providers: [ProjectService, PrismaService],
})
export class ProjectModule {}
