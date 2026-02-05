-- =============================================
-- Rollback Migration: 001_Rollback_Employment_Classification_And_SelfEmployed_Accounts
-- Description: Rollback script to remove the 15 columns added in migration 001
--              WARNING: This will permanently delete data in these columns
-- Date: 2026-01-27
-- Epic: Epic 1 - Database Schema Changes
-- Task: 1.1 - Create Database Migration Scripts
-- =============================================

USE [FactFind]
GO

PRINT '========================================='
PRINT 'ROLLBACK WARNING'
PRINT '========================================='
PRINT 'This script will DROP 14 columns from TEmploymentDetail table.'
PRINT 'All data in these columns will be PERMANENTLY LOST.'
PRINT 'Ensure you have a database backup before proceeding.'
PRINT ''
GO

-- Drop computed column first (has dependencies)
IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.TEmploymentDetail') AND name = 'IsCurrentEmployment')
BEGIN
    PRINT 'Dropping computed column: IsCurrentEmployment'
    ALTER TABLE [dbo].[TEmploymentDetail]
    DROP COLUMN [IsCurrentEmployment]
END
ELSE
BEGIN
    PRINT 'Column IsCurrentEmployment does not exist'
END
GO

-- Drop classification columns
IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.TEmploymentDetail') AND name = 'EmploymentType')
BEGIN
    PRINT 'Dropping column: EmploymentType'
    ALTER TABLE [dbo].[TEmploymentDetail]
    DROP COLUMN [EmploymentType]
END
ELSE
BEGIN
    PRINT 'Column EmploymentType does not exist'
END
GO

IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.TEmploymentDetail') AND name = 'OccupationType')
BEGIN
    PRINT 'Dropping column: OccupationType'
    ALTER TABLE [dbo].[TEmploymentDetail]
    DROP COLUMN [OccupationType]
END
ELSE
BEGIN
    PRINT 'Column OccupationType does not exist'
END
GO

IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.TEmploymentDetail') AND name = 'EmployedType')
BEGIN
    PRINT 'Dropping column: EmployedType'
    ALTER TABLE [dbo].[TEmploymentDetail]
    DROP COLUMN [EmployedType]
END
ELSE
BEGIN
    PRINT 'Column EmployedType does not exist'
END
GO

IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.TEmploymentDetail') AND name = 'EmployedBasis')
BEGIN
    PRINT 'Dropping column: EmployedBasis'
    ALTER TABLE [dbo].[TEmploymentDetail]
    DROP COLUMN [EmployedBasis]
END
ELSE
BEGIN
    PRINT 'Column EmployedBasis does not exist'
END
GO

-- Drop self-employed account columns (Year 1)
IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.TEmploymentDetail') AND name = 'PreviousShareOfCompanyProfit')
BEGIN
    PRINT 'Dropping column: PreviousShareOfCompanyProfit'
    ALTER TABLE [dbo].[TEmploymentDetail]
    DROP COLUMN [PreviousShareOfCompanyProfit]
END
ELSE
BEGIN
    PRINT 'Column PreviousShareOfCompanyProfit does not exist'
END
GO

IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.TEmploymentDetail') AND name = 'PreviousGrossSalary')
BEGIN
    PRINT 'Dropping column: PreviousGrossSalary'
    ALTER TABLE [dbo].[TEmploymentDetail]
    DROP COLUMN [PreviousGrossSalary]
END
ELSE
BEGIN
    PRINT 'Column PreviousGrossSalary does not exist'
END
GO

IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.TEmploymentDetail') AND name = 'PreviousGrossDividend')
BEGIN
    PRINT 'Dropping column: PreviousGrossDividend'
    ALTER TABLE [dbo].[TEmploymentDetail]
    DROP COLUMN [PreviousGrossDividend]
END
ELSE
BEGIN
    PRINT 'Column PreviousGrossDividend does not exist'
END
GO

-- Drop self-employed account columns (Year 2)
IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.TEmploymentDetail') AND name = 'SecondPreviousShareOfCompanyProfit')
BEGIN
    PRINT 'Dropping column: SecondPreviousShareOfCompanyProfit'
    ALTER TABLE [dbo].[TEmploymentDetail]
    DROP COLUMN [SecondPreviousShareOfCompanyProfit]
END
ELSE
BEGIN
    PRINT 'Column SecondPreviousShareOfCompanyProfit does not exist'
END
GO

IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.TEmploymentDetail') AND name = 'SecondPreviousGrossSalary')
BEGIN
    PRINT 'Dropping column: SecondPreviousGrossSalary'
    ALTER TABLE [dbo].[TEmploymentDetail]
    DROP COLUMN [SecondPreviousGrossSalary]
END
ELSE
BEGIN
    PRINT 'Column SecondPreviousGrossSalary does not exist'
END
GO

IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.TEmploymentDetail') AND name = 'SecondPreviousGrossDividend')
BEGIN
    PRINT 'Dropping column: SecondPreviousGrossDividend'
    ALTER TABLE [dbo].[TEmploymentDetail]
    DROP COLUMN [SecondPreviousGrossDividend]
END
ELSE
BEGIN
    PRINT 'Column SecondPreviousGrossDividend does not exist'
END
GO

-- Drop self-employed account columns (Year 3)
IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.TEmploymentDetail') AND name = 'ThirdPreviousShareOfCompanyProfit')
BEGIN
    PRINT 'Dropping column: ThirdPreviousShareOfCompanyProfit'
    ALTER TABLE [dbo].[TEmploymentDetail]
    DROP COLUMN [ThirdPreviousShareOfCompanyProfit]
END
ELSE
BEGIN
    PRINT 'Column ThirdPreviousShareOfCompanyProfit does not exist'
END
GO

IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.TEmploymentDetail') AND name = 'ThirdPreviousGrossSalary')
BEGIN
    PRINT 'Dropping column: ThirdPreviousGrossSalary'
    ALTER TABLE [dbo].[TEmploymentDetail]
    DROP COLUMN [ThirdPreviousGrossSalary]
END
ELSE
BEGIN
    PRINT 'Column ThirdPreviousGrossSalary does not exist'
END
GO

IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.TEmploymentDetail') AND name = 'ThirdPreviousGrossDividend')
BEGIN
    PRINT 'Dropping column: ThirdPreviousGrossDividend'
    ALTER TABLE [dbo].[TEmploymentDetail]
    DROP COLUMN [ThirdPreviousGrossDividend]
END
ELSE
BEGIN
    PRINT 'Column ThirdPreviousGrossDividend does not exist'
END
GO

-- Verify all columns were removed successfully
PRINT ''
PRINT '========================================='
PRINT 'Rollback Complete: Verification'
PRINT '========================================='
PRINT 'The following columns should NOT appear in the results:'

SELECT
    COLUMN_NAME,
    DATA_TYPE
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
PRINT 'Rollback script completed.'
PRINT 'If no columns appear above, rollback was successful.'
GO
