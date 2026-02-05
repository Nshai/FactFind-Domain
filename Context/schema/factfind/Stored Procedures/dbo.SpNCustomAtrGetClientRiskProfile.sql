SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomAtrGetClientRiskProfile]    
 @IndigoClientId bigint,    
 @CRMContactId bigint,     
 @ObjectiveTypeId bigint = 1 -- Investment or retirement    
AS    
DECLARE     
 @TemplateGuid uniqueidentifier,    
 @BaseTemplateGuid uniqueidentifier,
 @ProfilePreference tinyint,    
 @ClientAgrees bit,    
 @ChosenProfile uniqueidentifier    
    
-- Get the active template for this indigo client    
/*SELECT     
 @TemplateGuid = AtrTemplateGuid,    
 @ProfilePreference = AtrRefProfilePreferenceId    
FROM    
 dbo.FnAtrGetActiveTemplateDetails(@IndigoClientId)*/

SELECT   
 @TemplateGuid = Guid,   
 @BaseTemplateGuid = BaseAtrTemplate,
 @ProfilePreference = AtrRefProfilePreferenceId  
FROM  
 TAtrTemplate T  
 JOIN TAtrTemplateSetting S ON S.AtrTemplateId = T.AtrTemplateId  
WHERE   
 IndigoClientId = @IndigoClientId  
 AND Active = 1      
       
if @BaseTemplateGuid is null
	SET @BaseTemplateGuid =  @TemplateGuid
        
-- if profile is only shown once then use Investment    
IF @ProfilePreference = 1     
 SET @ObjectiveTypeId = 1    
    
-- See whether the client agrees with the profile    
IF @ObjectiveTypeId = 1    
 SELECT     
  @ClientAgrees = Client1AgreesWithProfile,    
  @ChosenProfile = Client1ChosenProfileGuid    
 FROM     
  TAtrInvestmentGeneral     
 WHERE     
  CRMContactId = @CRMContactId    
ELSE    
 SELECT     
  @ClientAgrees = Client1AgreesWithProfile,    
  @ChosenProfile = Client1ChosenProfileGuid    
 FROM     
  TAtrRetirementGeneral     
 WHERE     
  CRMContactId = @CRMContactId    
    
IF @ClientAgrees = 0    
 EXEC SpNCustomRetrieveRiskProfileCombinedByTemplateAndGuid @BaseTemplateGuid, @ChosenProfile    
ELSE    
 EXEC SpNCustomAtrCalculateRiskProfile @TemplateGuid, @CRMContactId, @ObjectiveTypeId    
   
GO
