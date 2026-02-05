SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomAtrClient2Agrees]  
 @IndigoClientId bigint,  
 @CRMContactId bigint,   
 @ObjectiveTypeId bigint = 1 -- Investment or retirement  
AS  
DECLARE   
 @TemplateGuid uniqueidentifier,  
 @ProfilePreference tinyint,  
 @ClientAgrees bit
  
-- Get the active template for this indigo client  
SELECT   
 @TemplateGuid = AtrTemplateGuid,  
 @ProfilePreference = AtrRefProfilePreferenceId  
FROM  
 dbo.FnAtrGetActiveTemplateDetails(@IndigoClientId)  
  
-- if profile is only shown once then use Investment  
IF @ProfilePreference = 1   
 SET @ObjectiveTypeId = 1  
  
-- See whether the client agrees with the profile  
IF @ObjectiveTypeId = 1  
 SELECT   
  @ClientAgrees = Client2AgreesWithAnswers
 FROM   
  TAtrInvestmentGeneral   
 WHERE   
  CRMContactId = @CRMContactId  
ELSE  
 SELECT   
    @ClientAgrees = Client2AgreesWithAnswers 
 FROM   
  TAtrRetirementGeneral   
 WHERE   
  CRMContactId = @CRMContactId  
  
select isnull(@ClientAgrees,0)
GO
