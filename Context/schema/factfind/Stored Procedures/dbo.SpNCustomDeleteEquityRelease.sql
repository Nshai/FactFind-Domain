SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNCustomDeleteEquityRelease]
@ConcurrencyId bigint,  
@EquityReleaseId bigint,  
@StampUser varchar(50),
@CurrentUserDate datetime
AS

DECLARE @MortgageEquityReleaseId bigint, @PolicyBusinessAttributeId bigint
SELECT @MortgageEquityReleaseId=EquityReleaseId FROM PolicyManagement..TEquityRelease WHERE PolicyBusinessId=@EquityReleaseId

BEGIN	
	--Delete Amount Released amount for the plan from the TPolicyBusinessAttribute table
	SELECT @PolicyBusinessAttributeId = PBA.PolicyBusinessAttributeId 
	FROM   PolicyManagement..TPolicyBusinessAttribute PBA WITH(NOLOCK) 			
		   INNER JOIN PolicyManagement..TAttributeList2Attribute ALA WITH(NOLOCK)
			  ON PBA.AttributeList2AttributeId = ALA.AttributeList2AttributeId 
	       INNER JOIN PolicyManagement..TAttributeList A WITH(NOLOCK)  
			  ON ALA.AttributeListId = A.AttributeListId 
	WHERE  PBA.PolicyBusinessId = @EquityReleaseId
			AND A.[Name] = 'Amount Released'

    IF ISNULL(@PolicyBusinessAttributeId,0)!= 0
	BEGIN
		DELETE FROM PolicyManagement..TPolicyBusinessAttribute
		WHERE  PolicyBusinessAttributeId = @PolicyBusinessAttributeId
	
		EXEC PolicyManagement..SpNAuditPolicyBusinessAttribute @StampUser,@PolicyBusinessAttributeId,'D'
	END

	--Record delete operation in the Equity Release Audit table
	EXEC PolicyManagement..SpNAuditEquityRelease @StampUser,@MortgageEquityReleaseId,'D'

	--Delete the Equity Release table record 
	DELETE FROM PolicyManagement..TEquityRelease WHERE EquityReleaseId = @MortgageEquityReleaseId
	
	IF @@ERROR!=0 GOTO errh
	
	--Delete the Policy Business information
	EXEC SpNCustomDeletePlan @EquityReleaseId, @StampUser, @CurrentUserDate
	  
	IF @@ERROR!=0 GOTO errh
	
	RETURN(0)

END

errh:
RETURN(100)
GO
