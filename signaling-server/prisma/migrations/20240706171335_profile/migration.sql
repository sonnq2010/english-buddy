-- CreateTable
CREATE TABLE "Profile" (
    "userId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "gender" TEXT,
    "filterGender" TEXT,
    "englishLevel" TEXT,
    "filterEnglishLevel" TEXT,

    CONSTRAINT "Profile_pkey" PRIMARY KEY ("userId")
);
