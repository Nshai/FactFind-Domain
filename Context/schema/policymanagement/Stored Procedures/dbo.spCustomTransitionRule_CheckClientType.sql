SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

  
CREATE PROCEDURE [dbo].[spCustomTransitionRule_CheckClientType]  
  @PolicyBusinessId bigint,  
  @ErrorMessage varchar(512) output  
AS  
  
BEGIN   
	DECLARE @planClientCategoryId varchar(255)
	DECLARE @clientClientCategoryId varchar(255)
	
	
	--first, get the owner (always client 1)
	DECLARE @CRMContactId bigint

	SELECT @CRMContactId = po.CRMContactId 
	FROM tpolicybusiness pb
	INNER JOIN TPolicyOwner po ON po.PolicyDetailId = pb.PolicyDetailId
	INNER JOIN
		(
			select min(PolicyOwnerId) as PolicyOwnerId
			FROM TPolicyOwner po
			INNER JOIN TPolicyBusiness pb ON pb.PolicyDetailId = po.PolicyDetailId
			WHERE pb.PolicyBusinessId = @PolicyBusinessId
		) client1 ON client1.PolicyOwnerId = po.PolicyOwnerId
	where pb.policyBusinessid = @PolicyBusinessId
	
	-- find the client type for the client
	
	
	SELECT @clientClientCategoryId = ClientTypeId
	FROM CRM..TCRMContact WHERE CRMContactId = @CRMContactId

	
	SELECT @planClientCategoryId = ClientTypeId 
	FROM TPolicyBusiness
	WHERE PolicyBusinessId = @PolicyBusinessId
	
	IF(ISNULL(@clientClientCategoryId,'')= '' AND ISNULL(@planClientCategoryId,'')= '')
	BEGIN
		SELECT @ErrorMessage = 'CLIENTANDPLANCATEGORY'
	END
	ELSE
	BEGIN
		IF(ISNULL(@clientClientCategoryId,'')= '')
		BEGIN
			SELECT @ErrorMessage = 'CLIENTCATEGORY'
		END
		ELSE
		BEGIN
			IF(ISNULL(@planClientCategoryId,'')= '')
			BEGIN
				SELECT @ErrorMessage = 'PLANCLIENTCATEGORY'
			END
		END
	END
	
	
	
	
	
	 
END  
  
  
GO
