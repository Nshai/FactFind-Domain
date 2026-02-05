SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- CAMPAIGNS  
  
  
CREATE Procedure [dbo].[spCustomConfigureCampaigns] @CampaignType varchar(255), @ArchiveType bit, @CampaignSource varchar(255), @ArchiveSource bit, @TenantId bigint  
as  
  
Declare @CampaignTypeId bigint, @CampaignId bigint  
  
Select @CampaignTypeId = CampaignTypeId from CRM..TCampaignType where IndigoClientId=@TenantId and CAmpaignType=@CampaignType  
  
-- Camapign Type  
IF ISNULL(@CampaignTypeId,0)=0  
BEGIN  
  
 INSERT INTO CRM..TCampaignType(indigoClientId, CampaignType, ArchiveFg)  
 VALUES (@TenantId, @CampaignType, @ArchiveType)  
  
 SELECT @CampaignTypeId =SCOPE_IDENTITY()  
END  
  
-- campaign source  
  
SELECT @CampaignId=CampaignId FROM CRM..TCampaign   
WHERE IndigoClientId=@TenantId AND CampaignName=@CampaignSource AND CampaignTypeId=@CampaignTypeId  
  
  
-- Camapign Type  
IF ISNULL(@CampaignId,0)=0  
BEGIN  
  
 INSERT INTO CRM..TCampaign(CampaignTypeId, IndigoClientId, GroupId, CampaignName, ArchiveFG, IsOrganisational)  
 VALUES (@CampaignTypeId,@TenantId, NULL,@CampaignSource , @ArchiveSource,1)  
  
 SELECT @CampaignId =SCOPE_IDENTITY()  
END  
  
GO
