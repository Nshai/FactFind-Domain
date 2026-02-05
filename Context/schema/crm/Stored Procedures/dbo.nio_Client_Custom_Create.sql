SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_Client_Custom_Create]        
@CurrentAdviserCRMId BIGINT = 0,  -- @P1          
@OriginalAdviserCRMId BIGINT = 0,  -- @P2    
@CampaignDataId BIGINT = NULL,   -- @P3   
@AdviserAssignedByUserId BIGINT = 0, --@P4
@CurrentAdviserName VARCHAR(50) = NULL, -- @P5    
@IndClientId BIGINT,     -- @P6    
@PartyCRMContactId BIGINT,    -- @P7    
@ConcurrencyId BIGINT = 1,    -- @P8    
@RefServiceStatusId BIGINT = NULL,  -- @P9    
@ServiceStatusStartDate datetime = NULL,  -- @P10 
@AdvisorRef VARCHAR(50) = NULL,   -- @P11
@Postcode VARCHAR(10) = NULL  ,   -- @P12    
@RefClientSegmentId BIGINT = NULL,  -- @P14    
@ClientSegmentStartDate datetime = NULL,  -- @P15
@BoobyTrap int = -999     -- @P13
        
AS        
        
BEGIN    
    
DECLARE @RefCRMContactStatusClientId BIGINT    
SELECT @RefCRMContactStatusClientId = RefCRMContactStatusId FROM CRM..TRefCRMContactStatus WHERE StatusName = 'Client'    
    
IF(@RefCRMContactStatusClientId IS NULL) BEGIN    
 RAISERROR('RefCRMContactStatusId for client not found. Add Client Operation aborted.', 16, 1)    
 GOTO EndProcedure    
END    
      
If IsNull(@BoobyTrap,0) <> -999        
 Begin        
  Raiserror('Incorrect number of parameters', 16, 1)  Return 100        
 End        
        
        
 UPDATE        
  dbo.TCRMContact        
 SET       
  CurrentAdviserCRMId = @CurrentAdviserCRMId,        
  OriginalAdviserCRMId = @OriginalAdviserCRMId,        
  RefCRMContactStatusId = @RefCRMContactStatusClientId,        
  RefServiceStatusId = @RefServiceStatusId,
  ServiceStatusStartDate = @ServiceStatusStartDate,      
  CampaignDataId = @CampaignDataId,  
  AdviserAssignedByUserId = @AdviserAssignedByUserId,
  AdvisorRef = @AdvisorRef,        
  CurrentAdviserName = @CurrentAdviserName,        
  Postcode = @Postcode,
  RefClientSegmentId = @RefClientSegmentId,
  ClientSegmentStartDate = @ClientSegmentStartDate
 WHERE        
  CRMContactId = @PartyCRMContactId        
        
END        
      
SELECT @PartyCRMContactId      
        
EndProcedure:
GO
