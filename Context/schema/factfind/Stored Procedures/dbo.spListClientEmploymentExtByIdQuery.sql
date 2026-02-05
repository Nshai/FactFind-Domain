SET QUOTED_IDENTIFIER OFF
GO

SET ANSI_NULLS ON
GO

-- ==================================================================================
-- Description: Stored procedure for getting extra fields of Employment by ClientIds
-- ==================================================================================
CREATE PROCEDURE [dbo].[spListClientEmploymentExtByIdQuery] 
	@ClientId BIGINT,
	@ClientId2 BIGINT = null
AS

SELECT
	ed.EmploymentDetailId AS Id,
	ed.CRMContactId AS ClientId,
	ed.EndDate,
	ed.PreviousFinancialYearEndDate
FROM TEmploymentDetail ed
WHERE ed.CRMContactId = @ClientId OR (@ClientId2 IS NOT NULL AND ed.CRMContactId = @ClientId2)

GO