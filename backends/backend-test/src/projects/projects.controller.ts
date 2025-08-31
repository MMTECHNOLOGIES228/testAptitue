import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Param,
  Body,
  Query,
  ParseUUIDPipe,
  UseGuards,
} from "@nestjs/common";
import { ProjectService } from "./projects.service";
import { CreateProjectDto } from "./dto/create-project.dto";
import { UpdateProjectDto } from "./dto/update-project.dto";
import { JwtAuthGuard } from "../auth/jwt-auth.guard";

@Controller("projects")
export class ProjectController {
  constructor(private readonly projectService: ProjectService) {}

  @Get()
  findAll(
    @Query("status") status?: string,
    @Query("q") q?: string,
    @Query("page") page = 1,
    @Query("pageSize") pageSize = 10,
  ) {
    return this.projectService.findAll(status, q, Number(page), Number(pageSize));
  }

  @UseGuards(JwtAuthGuard)
  @Post()
  create(@Body() dto: CreateProjectDto) {
    return this.projectService.create(dto);
  }

  @UseGuards(JwtAuthGuard)
  @Put(":id")
  update(@Param("id", ParseUUIDPipe) id: string, @Body() dto: UpdateProjectDto) {
    return this.projectService.update(id, dto);
  }

  @UseGuards(JwtAuthGuard)
  @Delete(":id")
  remove(@Param("id", ParseUUIDPipe) id: string) {
    return this.projectService.remove(id);
  }
}
