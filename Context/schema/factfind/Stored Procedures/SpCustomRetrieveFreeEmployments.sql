USE [factfind]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SpCustomRetrieveFreeEmployments]
@CRMContactId bigint = 0,
@CurrentUserDate datetime
AS
SELECT
	ED.EmploymentDetailId AS [EmploymentDetailId], 
	ED.EmploymentStatus,
	ED.[Role] AS Occupation,
	ED.Employer,
	ED.EmploymentStatus + CASE WHEN ED.[Role] IS NOT NULL THEN (' - ' + ED.[Role]) ELSE '' END
						+ CASE WHEN ED.Employer IS NOT NULL THEN (' - ' + ED.Employer) ELSE '' END AS [FreeEmploymentName]
FROM TEmploymentDetail ED 
WHERE CRMContactId = @CRMContactId 
AND EmploymentDetailId not in (SELECT EmploymentDetailIdValue FROM TDetailedincomebreakdown WHERE CRMContactId = @CRMContactId AND EmploymentDetailIdValue IS NOT NULL)
AND (EndDate IS NULL OR EndDate >= @CurrentUserDate) AND ED.EmploymentStatus not in ('Student','Unemployed')
ORDER BY EmploymentStatus, Occupation, Employer

FOR XML RAW('FreeEmployment')




