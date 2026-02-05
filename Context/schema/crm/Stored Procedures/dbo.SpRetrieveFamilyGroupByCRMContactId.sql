SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SpRetrieveFamilyGroupByCRMContactId]
@CRMContactId INT, @TenantId INT
AS

	SELECT CRMContactId, ClientName, IsHeadOfFamilyGroup 
	 FROM CRM..FnRetrieveFamilyGroupByCRMContactId(@CRMContactId, @TenantId)

RETURN (0)