SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE nio_SpNCustomRetrievePolicyIdByOwner
	@CrmContactId1 bigint,
	@CrmContactId2 bigint
AS
BEGIN
	
	IF @CrmContactId2 IS NULL OR @CrmContactId2 = 0
		SELECT distinct pb.PolicyBusinessId
		FROM TPolicyBusiness pb 
		INNER JOIN TPolicyOwner po ON pb.PolicyDetailId = po.PolicyDetailId
		INNER JOIN TStatusHistory sh ON pb.PolicyBusinessId = sh.PolicyBusinessId AND sh.CurrentStatusFG = 1
		INNER JOIN TStatus st ON sh.StatusId = st.StatusId                      
		WHERE po.CRMContactId = @CrmContactId1 AND NOT st.Name = 'Deleted'
	ELSE
		SELECT distinct pb.PolicyBusinessId
		FROM TPolicyBusiness pb 
		INNER JOIN TPolicyOwner po ON pb.PolicyDetailId = po.PolicyDetailId
		INNER JOIN TStatusHistory sh ON pb.PolicyBusinessId = sh.PolicyBusinessId AND sh.CurrentStatusFG = 1
		INNER JOIN TStatus st ON sh.StatusId = st.StatusId                      
		WHERE po.CRMContactId IN (@CrmContactId1, @CrmContactId2) AND NOT st.Name = 'Deleted'
END
GO
