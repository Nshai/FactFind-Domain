SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrievePolicyBusinessExtById]  
 @PolicyBusinessExtId bigint  
AS  
  
BEGIN  
 SELECT  
 1 AS Tag,  
 NULL AS Parent,  
 T1.PolicyBusinessExtId AS [PolicyBusinessExt!1!PolicyBusinessExtId],   
 T1.PolicyBusinessId AS [PolicyBusinessExt!1!PolicyBusinessId],   
 T1.BandingTemplateId AS [PolicyBusinessExt!1!BandingTemplateId],   
 ISNULL(T1.MigrationRef, '') AS [PolicyBusinessExt!1!MigrationRef],   
 ISNULL(T1.PortalReference, '') AS [PolicyBusinessExt!1!PortalReference], 
 ISNULL(T1.ReportNotes, '') AS [PolicyBusinessExt!1!ReportNotes], 
 T1.ConcurrencyId AS [PolicyBusinessExt!1!ConcurrencyId]  
 FROM TPolicyBusinessExt T1  
   
 WHERE T1.PolicyBusinessExtId = @PolicyBusinessExtId  
 ORDER BY [PolicyBusinessExt!1!PolicyBusinessExtId]  
  
  FOR XML EXPLICIT  
  
END  
RETURN (0)
GO
