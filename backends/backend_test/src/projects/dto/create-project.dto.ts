import { IsEnum, IsNotEmpty, IsNumber, IsString } from "class-validator";
import { Status } from "@prisma/client";

export class CreateProjectDto {
  @IsString()
  @IsNotEmpty()
  name: string;

  @IsEnum(Status)
  status: Status;

  @IsNumber()
  amount: number;
}
