SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
CREATE PROCEDURE [dbo].[SpNioCanUserChangeTheProviderForGroupSchemePolicies]    
	@GroupSchemeId BIGINT,    
	@UserId BIGINT,
	@TenantId BIGINT ,
	@HasAccess bit = 0 OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 DECLARE @GroupSchemePolicies TABLE
(
 PolicyBusinessId bigint,
 TenantId bigint,
 RoleId bigint null 
)

--Insert the group scheme policies into the table variable
INSERT INTO @GroupSchemePolicies (PolicyBusinessId, TenantId)
SELECT PolicyBusinessId, TenantId 
FROM TGroupScheme 
WHERE GroupSchemeId = @GroupSchemeId

--Insert the group scheme member policies into the table variable
INSERT INTO @GroupSchemePolicies (PolicyBusinessId, TenantId)
SELECT PolicyBusinessId, TenantId 
FROM TGroupSchemeMember
WHERE GroupSchemeId = @GroupSchemeId AND IsLeaver = 0

UPDATE gsp
		SET gsp.RoleId = rpasr.RoleId 		
FROM @GroupSchemePolicies gsp
INNER JOIN TPolicyBusiness pb
	ON pb.PolicyBusinessId = gsp.PolicyBusinessId
INNER JOIN TStatusHistory sh
	ON sh.PolicyBusinessId = pb.PolicyBusinessId 
	AND sh.CurrentStatusFG = 1
INNER JOIN TLifeCycleStep lcs
	ON lcs.StatusId =  sh.StatusId AND pb.LifeCycleId  = lcs.LifeCycleId
INNER JOIN TRefPlanActionStatusRole rpasr
	ON rpasr.LifeCycleStepId = lcs.LifeCycleStepId	
INNER JOIN TRefPlanAction rpa
	ON rpa.RefPlanActionId = rpasr.RefPlanActionId
	AND rpa.[Description]= 'Change Provider'
INNER JOIN administration..TMembership mem
	ON mem.RoleId = rpasr.RoleId and mem.UserId = @UserId
WHERE       gsp.TenantId = @TenantId 
	
IF EXISTS(SELECT * FROM @GroupSchemePolicies WHERE RoleId IS NULL)
	SET @HasAccess = 0
ELSE
    SET @HasAccess =1
	    
SELECT @HasAccess AS HasAccess
	
END
GO
