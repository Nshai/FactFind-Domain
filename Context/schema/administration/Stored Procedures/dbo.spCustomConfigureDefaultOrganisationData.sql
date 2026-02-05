SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   PROCEDURE [dbo].[spCustomConfigureDefaultOrganisationData]   
 @IndigoClientId bigint, @SourceIndigoClientId bigint, @SourceIndigoClientServer varchar(50)  
AS  
  
  
  
/******************************************************************************************************************************************************************************************************************  
This is used to configure default set up scripts for IO modules.  Typically scripts which cannot be represented by an updategram are contained in here.  
  
Scripts included  
  
 1:> PM + system & report keys  
 2:> Commissions Setup  
 3:> Campaign Management & Opportunity Management  
  
******************************************************************************************************************************************************************************************************************/  
-- lets do policymanagement first  
declare @Sql varchar(255)  
  
  
-- Roles, Keys, Lifecycles and stuff  
IF @SourceIndigoClientServer = ''  
 EXEC Administration..SpCustomConfigureNewOrganisation @IndigoClientId, @SourceIndigoClientId  
ELSE  
 EXEC Administration..SpCustomConfigureNewOrganisationFromRemote @IndigoClientId, @SourceIndigoClientId, @sourceIndigoclientServer  
  
-- Commissions  
 EXEC commissions..spCustomCommissionsConfig @IndigoClientId  
  
-- Campaign Management & Opportunity Management  
  
 EXEC CRM..SpCustomInsertDefaultDataForIndigoClient @IndigoClientId  
  
  
  
GO
