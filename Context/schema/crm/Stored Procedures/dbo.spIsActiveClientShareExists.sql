SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spIsActiveClientShareExists]   
(    
  @CRMContactIds VARCHAR(8000)    
  ,@TenantId BIGINT    
  ,@EntityType VARCHAR(25)    
  ,@IsIncludeRelationship BIT    
  ,@IsActiveShareExist BIT = 0 OUTPUT -- define the default value for output param [no shares]      
)    
AS    
BEGIN    
   
 IF (UPPER(@EntityType) = 'CLIENT')    
 BEGIN    
   -- check open share for selected clients      
   IF EXISTS ( SELECT cs.ClientPartyId FROM TClientShare cs WITH (NOLOCK)    
            INNER JOIN policymanagement.dbo.FnSplit(@CRMContactIds, ',') parslist   
            ON cs.ClientPartyId = parslist.Value    
            WHERE cs.IsShareActive = 1 AND cs.TenantId = @TenantId )    
   BEGIN    
	SET @IsActiveShareExist = 1    
   END    
    
   -- check open share for related clients (from relationship table),   
   --in case the @IsIncludeRelationship flag set as true.                    
   IF ( @IsIncludeRelationship = 1  AND @IsActiveShareExist = 0  )    
   BEGIN    
    IF EXISTS ( SELECT cs.ClientPartyId  FROM TClientShare cs WITH (NOLOCK)    
           INNER JOIN TRelationship Relation WITH (NOLOCK)   
           ON Relation.CRMContactToId = cs.ClientPartyId    
           INNER JOIN policymanagement.dbo.FnSplit(@CRMContactIds, ',') parsList   
           ON Relation.CRMContactFromId = parsList.Value   
           WHERE cs.IsShareActive = 1 AND cs.TenantId = @TenantId )    
		BEGIN    
			SET @IsActiveShareExist = 1    
		END    
   END  -- end of client relationship   
     
     SELECT @IsActiveShareExist AS [IsActiveShareExist]  
        
 END   -- end of client(s)   
END    
GO
