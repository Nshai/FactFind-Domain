SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveCorporateContactsByCRMContactIdsForContactDetails]
	@CRMContactId bigint
AS
	SELECT ContactId AS CorpContactsId,
       CRMContactId,
       RefContactType, 
       Cast(DefaultFg As bit) AS DefaultFg,
       Value,
       ConcurrencyId       
FROM CRM..TContact
WHERE CRMContactId IN (@CRMContactId)
	
GO
