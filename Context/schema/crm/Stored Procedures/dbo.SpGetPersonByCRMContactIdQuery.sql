SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =================================================================
-- Description: Stored procedure for getting Person by CRMContactId
-- =================================================================
CREATE PROCEDURE [dbo].[spGetPersonByCRMContactIdQuery]
    @CrmContactId INT
AS
BEGIN
   SELECT
	P.PersonId,
	P.FirstName,
	P.MiddleName,
	P.LastName,
	P.Salary,
	C.CRMContactId
   FROM
	CRM..TPerson P
	JOIN CRM..TCRMContact C ON C.PersonId = P.PersonId
   WHERE C.CRMContactId = @CrmContactId
END
GO