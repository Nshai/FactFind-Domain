SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[nio_SpContactSearchFullSpToGetColumnList]

as      
      
SELECT  
	0 AS [PartyId], 
    0 AS [RefCRMContactStatusId], 
    '' AS [LastName], 
    '' AS [FirstName], 
    '' AS [CorporateName], 
    '' AS [FullName],
    '' AS [Postcode],     
    0 AS [CRMContactType], 
    0 AS [TenantId], 
    '' AS [MigrationRef], 
    '' AS [ExternalReference],     
    '' AS [TrustName]
GO
