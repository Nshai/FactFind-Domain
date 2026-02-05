SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:        Siarhei Salokha
-- Create date:   14/07/2022
-- Description:   Stored procedure for getting count of clients by partyId
-- =============================================
CREATE PROCEDURE [dbo].[spGetCountClientsByPartyIdQuery]
    @partyId INT,
    @tenantId INT
AS
BEGIN
    SELECT COUNT(TC.CRMContactId) AS CountClients FROM
    (
        SELECT TOP 5001 CRMContactId
        FROM crm.dbo.TCRMContact 
        WHERE IndClientId = @tenantId AND CurrentAdviserCRMId = @partyId AND IsDeleted <> 1 AND 'Undefined' NOT IN (ISNULL(LastName, ''), ISNULL(CorporateName, ''))
    ) AS TC
END
GO