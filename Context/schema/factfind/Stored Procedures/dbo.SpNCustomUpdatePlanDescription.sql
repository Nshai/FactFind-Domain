SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomUpdatePlanDescription]  
 @StampUser varchar(50),    
 @PolicyBusinessId bigint,  
 @RefPlanType2ProdSubTypeId bigint = null  
AS   
DECLARE @PlanDescription bigint  

------------------------------------------------------  
-- Update any changes  
------------------------------------------------------  
IF NOT EXISTS (SELECT 1 FROM PolicyManagement..TPolicyBusiness WHERE PolicyBusinessId = @PolicyBusinessId)
RETURN;
  
UPDATE PolicyManagement..TPlanDescription       
SET  RefPlanType2ProdSubTypeId = @RefPlanType2ProdSubTypeId
FROM policymanagement..TPlanDescription as PDS
	 INNER JOIN policymanagement..TPolicyDetail as PD
		ON PDS.PlanDescriptionId = PD.PlanDescriptionId
	 INNER JOIN policymanagement..TPolicyBusiness as PB
		ON PD.PolicyDetailId = PB.PolicyDetailId
WHERE   
 PolicyBusinessId = @PolicyBusinessId  

 SELECT @PlanDescription = SCOPE_IDENTITY()

 EXEC PolicyManagement..SpNAuditPlanDescription @StampUser, @PlanDescription, 'U'
GO
