-- CreateEnum
CREATE TYPE "public"."Gender" AS ENUM ('MALE', 'FEMALE', 'OTHER');

-- CreateEnum
CREATE TYPE "public"."BloodGroup" AS ENUM ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-');

-- CreateEnum
CREATE TYPE "public"."FitnessStatus" AS ENUM ('FIT', 'UNFIT', 'UNDER_TREATMENT', 'REQUIRES_FOLLOWUP');

-- CreateEnum
CREATE TYPE "public"."VaccinType" AS ENUM ('COVID19', 'HEPATITIS_B', 'TYPHOID', 'TETANUS', 'INFLUENZA', 'OTHER');

-- CreateEnum
CREATE TYPE "public"."VaccinStatus" AS ENUM ('NOT_VACCINATED', 'PARTIALLY_VACCINATED', 'FULLY_VACCINATED');

-- CreateEnum
CREATE TYPE "public"."HealthPassStatus" AS ENUM ('PENDING', 'APPROVED', 'REJECTED', 'EXPIRED', 'SUSPENDED');

-- CreateEnum
CREATE TYPE "public"."AdminRole" AS ENUM ('SUPER_ADMIN', 'ADMIN', 'OPERATOR', 'VIEWER');

-- CreateTable
CREATE TABLE "public"."migrant_workers" (
    "id" TEXT NOT NULL,
    "worker_id" TEXT NOT NULL,
    "aadhar_number" BIGINT NOT NULL,
    "full_name" TEXT NOT NULL,
    "phone_number" BIGINT NOT NULL,
    "email" TEXT,
    "date_of_birth" DATE NOT NULL,
    "address" JSONB NOT NULL,
    "gender" "public"."Gender" NOT NULL,
    "occupation" TEXT NOT NULL,
    "state_of_origin" TEXT NOT NULL,
    "emergency_contact" TEXT,
    "profile_photo" TEXT,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "registered_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "migrant_workers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."health_records" (
    "id" TEXT NOT NULL,
    "worker_id" TEXT NOT NULL,
    "checkup_date" TIMESTAMP(3) NOT NULL,
    "hospital_id" TEXT NOT NULL,
    "doctor_id" TEXT NOT NULL,
    "blood_pressure" TEXT,
    "temperature" TEXT,
    "weight" TEXT,
    "height" TEXT,
    "blood_group" TEXT,
    "allergies" TEXT,
    "medical_conditions" TEXT,
    "medications" TEXT,
    "fitness_status" "public"."FitnessStatus" NOT NULL,
    "remarks" TEXT,
    "certificate_path" TEXT,
    "is_verified" BOOLEAN NOT NULL DEFAULT false,
    "verified_by" TEXT,
    "verified_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "health_records_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."vaccinations" (
    "id" TEXT NOT NULL,
    "worker_id" TEXT NOT NULL,
    "vaccine_name" "public"."VaccinType" NOT NULL,
    "vaccine_type" "public"."VaccinType" NOT NULL,
    "adminstered_date" DATE NOT NULL,
    "next_due_date" DATE NOT NULL,
    "batch_number" TEXT NOT NULL,
    "manufacturer" TEXT NOT NULL,
    "adminstered_by" TEXT NOT NULL,
    "hospital_name" TEXT NOT NULL,
    "certificate_number" TEXT NOT NULL,
    "certificate_path" TEXT,
    "is_verified" BOOLEAN NOT NULL DEFAULT false,
    "verified_by" TEXT,
    "verified_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "vaccinations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."health_passes" (
    "id" TEXT NOT NULL,
    "worker_id" TEXT NOT NULL,
    "pass_number" TEXT NOT NULL,
    "qr_code" TEXT NOT NULL,
    "status" "public"."HealthPassStatus" NOT NULL DEFAULT 'PENDING',
    "issued_date" TIMESTAMP(3),
    "expiry_date" TIMESTAMP(3),
    "issued_by" TEXT,
    "certificate_path" TEXT,
    "last_verified_at" TIMESTAMP(3),
    "verification_count" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "health_passes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."employements" (
    "id" TEXT NOT NULL,
    "worker_id" TEXT NOT NULL,
    "employer_name" TEXT NOT NULL,
    "employer_contact" TEXT NOT NULL,
    "company_name" TEXT NOT NULL,
    "job_title" TEXT NOT NULL,
    "work_location" TEXT NOT NULL,
    "start_date" DATE NOT NULL,
    "end_date" DATE,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "employements_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."admins" (
    "id" TEXT NOT NULL,
    "username" TEXT NOT NULL,
    "full_name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "role" "public"."AdminRole" NOT NULL DEFAULT 'OPERATOR',
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "last_login" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "admins_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."audit_logs" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "action" TEXT NOT NULL,
    "resources" TEXT NOT NULL,
    "details" JSONB,
    "ip_address" TEXT,
    "user_agent" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "audit_logs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Doctor" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "phone" BIGINT NOT NULL,
    "email" TEXT NOT NULL,
    "specialization" TEXT NOT NULL,
    "departmentId" TEXT NOT NULL,
    "hospitalId" TEXT NOT NULL,
    "joinedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Doctor_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Hospital" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "address" JSONB NOT NULL,
    "phone" BIGINT NOT NULL,
    "established" TIMESTAMP(3) NOT NULL,
    "capacity" INTEGER NOT NULL,

    CONSTRAINT "Hospital_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "migrant_workers_worker_id_key" ON "public"."migrant_workers"("worker_id");

-- CreateIndex
CREATE UNIQUE INDEX "migrant_workers_aadhar_number_key" ON "public"."migrant_workers"("aadhar_number");

-- CreateIndex
CREATE INDEX "health_records_worker_id_idx" ON "public"."health_records"("worker_id");

-- CreateIndex
CREATE INDEX "health_records_hospital_id_idx" ON "public"."health_records"("hospital_id");

-- CreateIndex
CREATE INDEX "health_records_doctor_id_idx" ON "public"."health_records"("doctor_id");

-- CreateIndex
CREATE UNIQUE INDEX "vaccinations_certificate_number_key" ON "public"."vaccinations"("certificate_number");

-- CreateIndex
CREATE INDEX "vaccinations_worker_id_idx" ON "public"."vaccinations"("worker_id");

-- CreateIndex
CREATE UNIQUE INDEX "health_passes_worker_id_key" ON "public"."health_passes"("worker_id");

-- CreateIndex
CREATE UNIQUE INDEX "health_passes_pass_number_key" ON "public"."health_passes"("pass_number");

-- CreateIndex
CREATE UNIQUE INDEX "health_passes_qr_code_key" ON "public"."health_passes"("qr_code");

-- CreateIndex
CREATE UNIQUE INDEX "employements_worker_id_key" ON "public"."employements"("worker_id");

-- CreateIndex
CREATE UNIQUE INDEX "admins_username_key" ON "public"."admins"("username");

-- CreateIndex
CREATE UNIQUE INDEX "admins_email_key" ON "public"."admins"("email");

-- CreateIndex
CREATE UNIQUE INDEX "Doctor_email_key" ON "public"."Doctor"("email");

-- CreateIndex
CREATE INDEX "Doctor_hospitalId_idx" ON "public"."Doctor"("hospitalId");
