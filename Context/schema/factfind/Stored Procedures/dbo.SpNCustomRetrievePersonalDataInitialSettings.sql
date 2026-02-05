SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrievePersonalDataInitialSettings] 
(
  @IndigoClientId bigint,                                
  @UserId bigint,                                
  @FactFindId bigint ,  
  @ExcludePlanPurposes BIT = 0,
  @CRMContactId bigint OUTPUT,
  @CRMContactId2 bigint OUTPUT,
  @AdviserId bigint OUTPUT,
  @AdviserCRMId bigint OUTPUT,
  @AdviserName varchar(255) OUTPUT,
  @PreExistingAdviserId bigint OUTPUT,
  @PreExistingAdviserName varchar(255) OUTPUT,
  @PreExistingAdviserCRMId bigint OUTPUT, 
  @NewId bigint OUTPUT,
  @IncludeTopups bit OUTPUT,
  @TenantId bigint OUTPUT,  
  @AdviserUserId bigint OUTPUT, 
  @AdviserGroupId bigint OUTPUT, 
  @IncomeReplacementRate smallint OUTPUT, 
  @UserIncomeReplacementRate smallint OUTPUT
)
As
Begin
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	---------------------------------------------------------------------------------  
	-- Get some initial settings  
	---------------------------------------------------------------------------------  
	SET @TenantId = @IndigoClientId

	SELECT  
	 @PreExistingAdviserId = PractitionerId,      
	 @PreExistingAdviserName = PractitionerName   
	FROM   
	 Compliance..TPreExistingAdviser   
	WHERE   
	 IndigoClientId = @TenantId And isFactFind=1  
	  
	IF @PreExistingAdviserId IS NOT NULL  
	 SELECT @PreExistingAdviserCRMId = CRMContactId FROM CRM..TPractitioner WHERE PractitionerId = @PreExistingAdviserId  
	                                
	-- CRMContacts                           
	SELECT     
	  @CRMContactId = CrmContactId1,    
	  @CRMContactId2 = CrmContactId2                               
	FROM     
	 TFactFind WITH(NOLOCK)                              
	WHERE     
	  IndigoClientId = @TenantId                              
	  AND FactFindId = @FactFindId                                
	                                
	IF @CRMContactId2 = 0   
	 SELECT @CRMContactId2 = NULL                              
	                                
	-- Selling Adviser Details  
	SELECT                                 
	 @AdviserId = A.PractitionerId,                                
	 @AdviserCRMId = A.CRMContactId,                                
	 @AdviserName = C.CurrentAdviserName,  
	 @AdviserUserId = U.UserId,  
	 @AdviserGroupId = U.GroupId  
	FROM       
	 CRM..TCRMContact C -- The Client CRMContact record                                                          
	 JOIN CRM..TPractitioner A ON A.CRMContactId = C.CurrentAdviserCRMId  
	 JOIN Administration..TUser U ON U.CRMContactId = A.CRMContactId  
	WHERE                                
	 C.CRMContactId = @CRMContactId                                  
	 AND C.IndClientId = @TenantId                                  
	  
	-- Income replacement rate for user and group.  
	SET @IncomeReplacementRate = ISNULL(Administration.dbo.FnCustomGetGroupPreference(@AdviserGroupId, 'FactFindIncomeReplacementRate'), 10)  
	SET @UserIncomeReplacementRate = Administration.dbo.FnCustomGetUserPreference(@AdviserUserId, 'FactFindIncomeReplacementRate')  
	
	-- Allow user override?  
	IF Administration.dbo.FnCustomGetGroupPreference(@AdviserGroupId, 'FactFindAdviserOverride') = 'True' AND @UserIncomeReplacementRate IS NOT NULL  
	 SET @IncomeReplacementRate = @UserIncomeReplacementRate 

	-- Get the topup setting for the servicing adviser's group.
	SELECT @IncludeTopups = CAST(ISNULL(Administration.dbo.FnCustomGetGroupPreference(@AdviserGroupId, 'ShowTopupsInFactFind'), 0) AS bit)
End
GO
