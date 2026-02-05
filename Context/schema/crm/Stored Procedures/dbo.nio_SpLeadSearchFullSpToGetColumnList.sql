SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE dbo.nio_SpLeadSearchFullSpToGetColumnList  
  
AS  
  
SELECT    
 0  AS [LeadId],
 0  AS [PartyId],
 0  AS [TenantId],  
 '' AS [LeadFullName],     
 '' AS [LeadTypeName],     
 '' AS [AdviserName],     
 '' AS [SecondaryRef],
 '' AS [LeadStatus],
 '' AS [CampaignType],
 '' AS [CampaignSource],
 '' AS [Description],
 0  AS [_RightMask],    
 0  AS [_AdvancedMask],
 0  AS [IsDeleted]   
GO
