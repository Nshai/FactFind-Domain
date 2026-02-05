SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_Lead_Custom_Create]  
 @CurrentAdviserCRMId BIGINT = 0,   -- @p1       
 @OriginalAdviserCRMId BIGINT = 0,   -- @p2       
 @CampaignDataId BIGINT = NULL,    -- @p3      
 @AdviserAssignedByUserId BIGINT = 0,-- @p4
 @CurrentAdviserName VARCHAR(50) = NULL, -- @p5        
 @IndClientId BIGINT,      -- @p6      
 @PartyCRMContactId BIGINT,     -- @p7      
 @ConcurrencyId BIGINT = 1,     -- @p8    
 @IntroducerBranchId BIGINT=NULL,
 @IntroducerEmployeeId BIGINT=NULL,
 @IndividualName varchar(255)='',  
 @BoobyTrap int = -999       
      
AS        
        
BEGIN        


      
DECLARE @RefCRMContactStatusClientId BIGINT  
DECLARE @LeadId bigint
DECLARE @StampUser varchar(1) = '0'
      
SELECT @RefCRMContactStatusClientId = RefCRMContactStatusId FROM CRM..TRefCRMContactStatus WHERE StatusName = 'Prospect'        
        
IF(@RefCRMContactStatusClientId IS NULL) BEGIN        
 RAISERROR('RefCRMContactStatusId for lead not found. Add Lead Operation aborted.', 16, 1)        
 GOTO EndProcedure        
END        
          
If IsNull(@BoobyTrap,0) <> -999            
 Begin            
  Raiserror('Incorrect number of parameters', 16, 1)  Return 100            
 End            
            
     EXEC dbo.SpNAuditCRMContact @StampUser, @PartyCRMContactId, 'U'
     
	-- Update the the TCRMContact Table
	UPDATE dbo.TCRMContact          
	SET         
		RefCRMContactStatusId = 2,         
		CurrentAdviserCRMId = COALESCE(@CurrentAdviserCRMId, CurrentAdviserCRMId),          
		OriginalAdviserCRMId = COALESCE(@OriginalAdviserCRMId, OriginalAdviserCRMId),          
		CampaignDataId = COALESCE(@CampaignDataId, CampaignDataId ),        
		AdviserAssignedByUserId = @AdviserAssignedByUserId,
		CurrentAdviserName = COALESCE(@CurrentAdviserName, CurrentAdviserName),        
		IndClientId = @IndClientId,        
		ConcurrencyId = @ConcurrencyId        
	WHERE          
		CRMContactId = @PartyCRMContactId          

	-- Insert into TLead
	INSERT INTO TLead (CRMContactId, LeadSourceId, IndigoClientId, ConcurrencyId, 
					   IntroducerEmployeeId, IntroducerBranchId, IndividualName)
	VALUES (@PartyCRMContactId, NULL, @IndClientId, @ConcurrencyId,
			@IntroducerEmployeeId, @IntroducerBranchId, @IndividualName)  

	-- Select the latest added LeadId
	SELECT @LeadId = SCOPE_IDENTITY()

	
	INSERT INTO TLeadAudit 
	( CRMContactId, LeadSourceId, IndigoClientId, ConcurrencyId, LeadId, StampAction, StampDateTime, StampUser) 
	Select CRMContactId, LeadSourceId, IndigoClientId, ConcurrencyId, LeadId, 'C', GetDate(), @StampUser
	FROM TLead with(nolock)
	WHERE LeadId = @LeadId

END        
        
Select @PartyCRMContactId         
  EndProcedure:
GO


