-- AlterTable
ALTER TABLE "Room" ADD COLUMN     "ipUser1" TEXT,
ADD COLUMN     "ipUser2" TEXT;

-- CreateTable
CREATE TABLE "ReportUser" (
    "reportId" SERIAL NOT NULL,
    "reporter" TEXT NOT NULL,
    "reportedUser" TEXT,
    "reportedIP" TEXT,
    "reason" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ReportUser_pkey" PRIMARY KEY ("reportId")
);
