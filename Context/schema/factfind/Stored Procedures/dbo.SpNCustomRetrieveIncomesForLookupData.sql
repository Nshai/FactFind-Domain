USE [factfind]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveIncomesForLookupData]
	@CRMContactId bigint = 0,    
	@CRMContactId2 bigint = 0
AS
DECLARE @TodayDate date = GETDATE()

SELECT 
	DetailedincomebreakdownId as IncomeId,
	IncomeType + " – " 
	+ IIF(Description is NULL or Description = '', '', Description + " – ") 
	+ IIF(NetAmount is NULL, '', convert(varchar(30), NetAmount, 0) + " – ")
	+ Frequency as LongName
INTO #Incomes
FROM 
	TDetailedincomebreakdown
where
	((@CRMContactId = CRMContactId and @CRMContactId2 = ISNULL(CRMContactId2, 0))
	or (@CRMContactId2 = CRMContactId and @CRMContactId = ISNULL(CRMContactId2, 0)))
	and ((StartDate IS NULL and EndDate IS NULL) OR (StartDate IS NULL and GETDATE() < EndDate) OR (GETDATE() >= StartDate and EndDate is NULL) OR (GETDATE() >= StartDate and GETDATE() < EndDate))
	and DetailedincomebreakdownId not in 
	(select IncomeId from TAssets where IncomeId is not null)
order by 
	IncomeType, Description

SELECT
	0 as IncomeId,
	'Add New Income' as [LongName]
UNION
SELECT 
	IncomeId, [LongName]
FROM 
	#Incomes

FOR XML RAW ('Income')

