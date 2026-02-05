-- =============================================
-- Migration: 001_Add_Employment_Classification_And_SelfEmployed_Accounts
-- Description: Adds 15 new columns to TEmploymentDetail table for Employment API v2.1
--              - 4 classification fields (EmploymentType, OccupationType, EmployedType, EmployedBasis)
--              - 12 self-employed account fields (3 years x 4 fields each)
--              - 1 computed column (IsCurrentEmployment)
-- Date: 2026-01-27
-- Epic: Epic 1 - Database Schema Changes
-- Task: 1.1 - Create Database Migration Scripts
-- =============================================

USE [FactFind]
GO

-- Check if columns already exist before adding
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.TEmploymentDetail') AND name = 'EmploymentType')
BEGIN
    PRINT 'Adding column: EmploymentType'
    ALTER TABLE [dbo].[TEmploymentDetail]
    ADD [EmploymentType] VARCHAR(100) NULL
END
ELSE
BEGIN
    PRINT 'Column EmploymentType already exists'
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.TEmploymentDetail') AND name = 'OccupationType')
BEGIN
    PRINT 'Adding column: OccupationType'
    ALTER TABLE [dbo].[TEmploymentDetail]
    ADD [OccupationType] VARCHAR(100) NULL
END
ELSE
BEGIN
    PRINT 'Column OccupationType already exists'
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.TEmploymentDetail') AND name = 'EmployedType')
BEGIN
    PRINT 'Adding column: EmployedType'
    ALTER TABLE [dbo].[TEmploymentDetail]
    ADD [EmployedType] VARCHAR(100) NULL
END
ELSE
BEGIN
    PRINT 'Column EmployedType already exists'
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.TEmploymentDetail') AND name = 'EmployedBasis')
BEGIN
    PRINT 'Adding column: EmployedBasis'
    ALTER TABLE [dbo].[TEmploymentDetail]
    ADD [EmployedBasis] VARCHAR(100) NULL
END
ELSE
BEGIN
    PRINT 'Column EmployedBasis already exists'
END
GO

-- Self-Employed Accounts: Previous Year (Year 1)
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.TEmploymentDetail') AND name = 'PreviousShareOfCompanyProfit')
BEGIN
    PRINT 'Adding column: PreviousShareOfCompanyProfit'
    ALTER TABLE [dbo].[TEmploymentDetail]
    ADD [PreviousShareOfCompanyProfit] MONEY NULL
END
ELSE
BEGIN
    PRINT 'Column PreviousShareOfCompanyProfit already exists'
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.TEmploymentDetail') AND name = 'PreviousGrossSalary')
BEGIN
    PRINT 'Adding column: PreviousGrossSalary'
    ALTER TABLE [dbo].[TEmploymentDetail]
    ADD [PreviousGrossSalary] MONEY NULL
END
ELSE
BEGIN
    PRINT 'Column PreviousGrossSalary already exists'
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.TEmploymentDetail') AND name = 'PreviousGrossDividend')
BEGIN
    PRINT 'Adding column: PreviousGrossDividend'
    ALTER TABLE [dbo].[TEmploymentDetail]
    ADD [PreviousGrossDividend] MONEY NULL
END
ELSE
BEGIN
    PRINT 'Column PreviousGrossDividend already exists'
END
GO

-- Self-Employed Accounts: Second Previous Year (Year 2)
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.TEmploymentDetail') AND name = 'SecondPreviousShareOfCompanyProfit')
BEGIN
    PRINT 'Adding column: SecondPreviousShareOfCompanyProfit'
    ALTER TABLE [dbo].[TEmploymentDetail]
    ADD [SecondPreviousShareOfCompanyProfit] MONEY NULL
END
ELSE
BEGIN
    PRINT 'Column SecondPreviousShareOfCompanyProfit already exists'
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.TEmploymentDetail') AND name = 'SecondPreviousGrossSalary')
BEGIN
    PRINT 'Adding column: SecondPreviousGrossSalary'
    ALTER TABLE [dbo].[TEmploymentDetail]
    ADD [SecondPreviousGrossSalary] MONEY NULL
END
ELSE
BEGIN
    PRINT 'Column SecondPreviousGrossSalary already exists'
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.TEmploymentDetail') AND name = 'SecondPreviousGrossDividend')
BEGIN
    PRINT 'Adding column: SecondPreviousGrossDividend'
    ALTER TABLE [dbo].[TEmploymentDetail]
    ADD [SecondPreviousGrossDividend] MONEY NULL
END
ELSE
BEGIN
    PRINT 'Column SecondPreviousGrossDividend already exists'
END
GO

-- Self-Employed Accounts: Third Previous Year (Year 3)
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.TEmploymentDetail') AND name = 'ThirdPreviousShareOfCompanyProfit')
BEGIN
    PRINT 'Adding column: ThirdPreviousShareOfCompanyProfit'
    ALTER TABLE [dbo].[TEmploymentDetail]
    ADD [ThirdPreviousShareOfCompanyProfit] MONEY NULL
END
ELSE
BEGIN
    PRINT 'Column ThirdPreviousShareOfCompanyProfit already exists'
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.TEmploymentDetail') AND name = 'ThirdPreviousGrossSalary')
BEGIN
    PRINT 'Adding column: ThirdPreviousGrossSalary'
    ALTER TABLE [dbo].[TEmploymentDetail]
    ADD [ThirdPreviousGrossSalary] MONEY NULL
END
ELSE
BEGIN
    PRINT 'Column ThirdPreviousGrossSalary already exists'
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.TEmploymentDetail') AND name = 'ThirdPreviousGrossDividend')
BEGIN
    PRINT 'Adding column: ThirdPreviousGrossDividend'
    ALTER TABLE [dbo].[TEmploymentDetail]
    ADD [ThirdPreviousGrossDividend] MONEY NULL
END
ELSE
BEGIN
    PRINT 'Column ThirdPreviousGrossDividend already exists'
END
GO

-- Computed Column: IsCurrentEmployment
-- This is calculated as: EndDate IS NULL OR EndDate >= GETDATE()
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.TEmploymentDetail') AND name = 'IsCurrentEmployment')
BEGIN
    PRINT 'Adding computed column: IsCurrentEmployment'
    ALTER TABLE [dbo].[TEmploymentDetail]
    ADD [IsCurrentEmployment] AS (CASE
        WHEN [EndDate] IS NULL THEN CAST(1 AS BIT)
        WHEN [EndDate] >= CAST(GETDATE() AS DATE) THEN CAST(1 AS BIT)
        ELSE CAST(0 AS BIT)
    END) PERSISTED
END
ELSE
BEGIN
    PRINT 'Computed column IsCurrentEmployment already exists'
END
GO

-- Verify all columns were added successfully
PRINT ''
PRINT '========================================='
PRINT 'Migration Complete: Verification'
PRINT '========================================='
SELECT
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    COLUMNPROPERTY(OBJECT_ID('dbo.TEmploymentDetail'), COLUMN_NAME, 'IsComputed') AS IS_COMPUTED
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'TEmploymentDetail'
AND COLUMN_NAME IN (
    'EmploymentType',
    'OccupationType',
    'EmployedType',
    'EmployedBasis',
    'PreviousShareOfCompanyProfit',
    'PreviousGrossSalary',
    'PreviousGrossDividend',
    'SecondPreviousShareOfCompanyProfit',
    'SecondPreviousGrossSalary',
    'SecondPreviousGrossDividend',
    'ThirdPreviousShareOfCompanyProfit',
    'ThirdPreviousGrossSalary',
    'ThirdPreviousGrossDividend',
    'IsCurrentEmployment'
)
ORDER BY COLUMN_NAME
GO

PRINT ''
PRINT 'Migration script completed successfully.'
PRINT 'Total columns added: 14 (13 regular + 1 computed)'
GO
