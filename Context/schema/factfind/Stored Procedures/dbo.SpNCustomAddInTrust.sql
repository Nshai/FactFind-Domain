SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomAddInTrust]    
 @StampUser varchar(255),    
 @TenantId bigint,    
 @PolicyBusinessId bigint,    
 @InTrust bit = null ,   
 @ToWhom varchar(250) = null  
AS    
-------------------------------------------------------------------------------          
-- Declarations    
-------------------------------------------------------------------------------    
DECLARE @ProtectionId bigint, @Discriminator bigint    
    
-------------------------------------------------------------------------------          
-- Get Protection Id    
-------------------------------------------------------------------------------    
SELECT @ProtectionId = ProtectionId    
FROM PolicyManagement..TProtection    
WHERE PolicyBusinessId = @PolicyBusinessId    
    
SET @Discriminator = 51 -- Means Payment Protection, no idea if this is right though.    
    
-------------------------------------------------------------------------------          
-- Create/Update  TProtection record with InTrust setting.    
-------------------------------------------------------------------------------    
IF @ProtectionId IS NULL BEGIN    
 -- Create    
 INSERT INTO PolicyManagement..TProtection (IndigoClientId, PolicyBusinessId, RefPlanSubCategoryId, InTrust ,ToWhom)           
 VALUES (@TenantId, @PolicyBusinessId, @Discriminator, @InTrust, @ToWhom)          
 -- Audit    
 SET @ProtectionId = SCOPE_IDENTITY()    
 EXEC PolicyManagement..SpNAuditProtection @StampUser, @ProtectionId, 'C'    
END     
ELSE BEGIN    
 -- Audit    
 EXEC PolicyManagement..SpNAuditProtection @StampUser, @ProtectionId, 'U'                 
 -- Update    
 UPDATE PolicyManagement..TProtection    
 SET InTrust = @InTrust,ToWhom = @ToWhom, ConcurrencyId = ConcurrencyId + 1    
 WHERE ProtectionId = @ProtectionId    
END
GO
