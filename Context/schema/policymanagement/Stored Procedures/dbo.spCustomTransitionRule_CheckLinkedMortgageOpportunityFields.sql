SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[spCustomTransitionRule_CheckLinkedMortgageOpportunityFields]
  @PolicyBusinessId bigint,
  @ErrorMessage varchar(max) output
AS
	
	Declare @ClientCount tinyint
	Declare @ClientType varchar(10)
	Declare @Owner1Id Bigint 
	Declare @Owner2Id Bigint 
	Declare @Owner1Name Varchar(255) 
	Declare @Owner2Name Varchar(255)  

	EXEC spCustomTansitionRuleGetOwners @PolicyBusinessId, 
										@ClientCount OUTPUT, @ClientType OUTPUT,
										@Owner1Id OUTPUT, @Owner1Name OUTPUT, 
										@Owner2Id OUTPUT, @Owner2Name OUTPUT
										
	--Only applies to person clients
	if @ClientType != 'PERSON'
		return(0)	
	
	--Check Fack Find 
	declare @FactFindId bigint = null
	declare @FactFindPrimaryOwnerId bigint	= null
	
	EXEC spCustomTansitionRule_CheckFactFind @Owner1Id, @Owner2Id, @Owner1Name, @Owner2Name, @ClientCount, 
		@FactFindId OUTPUT, @FactFindPrimaryOwnerId OUTPUT, @ErrorMessage OUTPUT
	
	if ISNULL(@ErrorMessage, '') != ''
		return 	
											
	declare @Opportunities TABLE (OpportunityId Bigint, OwnerId bigint, OwnerName Varchar(200), SequentialRef varchar(20),
		MortgageRepaymentMethod varchar(3), MortgageType varchar(3), PlanPurpose varchar(3), RelatedProperty varchar(3), SourceOfDeposit varchar(3), 
		Term varchar(3), Deposit varchar(3), Price varchar(3)
	)
	
	
	INSERT INTO @Opportunities
	
		SELECT DISTINCT mo.MortgageOpportunityId, @Owner1Id, @Owner1Name, o.SequentialRef,
		
		CASE WHEN mo.RefMortgageRepaymentMethodId IS NULL THEN 'NO' ELSE 'YES' END,						--Repayment Method
		CASE WHEN mo.RefOpportunityType2ProdSubTypeId IS NULL THEN 'NO' ELSE 'YES' END,						--MortgageType
		CASE WHEN mo.PlanPurpose IS NULL THEN 'NO' ELSE 'YES' END,										--Plan Purpose -- only in fact find
		CASE WHEN mo.RelatedAddressStoreId IS NULL THEN 'NO' ELSE 'YES' END,							--Property - only in fact find
		CASE WHEN ISNULL(LTRIM(RTRIM(mo.SourceOfDeposit)),'')='' THEN 'NO' ELSE 'YES' END,				--Source of Deposit
		CASE WHEN ISNULL(mo.Term, 0) = 0 THEN 'NO' ELSE 'YES' END,										--Term
		CASE WHEN ISNULL(mo.Deposit, 0) = 0 THEN 'NO' ELSE 'YES' END,									--Deposit
		CASE WHEN ISNULL(mo.Price, 0) = 0 THEN 'NO' ELSE 'YES' END									    --Price	
		
		FROM CRM..TOpportunity o
		--INNER JOIN CRM..TOpportunityPolicyBusiness op ON o.OpportunityId = op.OpportunityId				-- Linked opportunity
		INNER JOIN CRM..TOpportunityType ot ON o.OpportunityTypeId = ot.OpportunityTypeId
		INNER JOIN CRM..TMortgageOpportunity mo ON o.OpportunityId = mo.OpportunityId
		INNER JOIN CRM..TOpportunityCustomer oc ON oc.Opportunityid = o.OpportunityId
		WHERE oc.PartyId = @Owner1Id
		AND ot.OpportunityTypeName = 'Mortgage'
		AND o.IsClosed=0
		
	UNION
		
		SELECT Distinct mo.MortgageOpportunityId, @Owner2Id, @Owner2Name, o.SequentialRef,						--Owner 2
		
		CASE WHEN mo.RefMortgageRepaymentMethodId IS NULL THEN 'NO' ELSE 'YES' END,						--Repayment Method
		CASE WHEN mo.RefOpportunityType2ProdSubTypeId IS NULL THEN 'NO' ELSE 'YES' END,						--MortgageType
		CASE WHEN mo.PlanPurpose IS NULL THEN 'NO' ELSE 'YES' END,										--Plan Purpose -- only in fact find
		CASE WHEN mo.RelatedAddressStoreId IS NULL THEN 'NO' ELSE 'YES' END,							--Property - only in fact find
		CASE WHEN ISNULL(LTRIM(RTRIM(mo.SourceOfDeposit)),'')='' THEN 'NO' ELSE 'YES' END,				--Source of Deposit
		CASE WHEN ISNULL(mo.Term, 0) = 0 THEN 'NO' ELSE 'YES' END,										--Term
		CASE WHEN ISNULL(mo.Deposit, 0) = 0 THEN 'NO' ELSE 'YES' END,									--Deposit
		CASE WHEN ISNULL(mo.Price, 0) = 0 THEN 'NO' ELSE 'YES' END									    --Price	
		
		FROM CRM..TOpportunity o
		--INNER JOIN CRM..TOpportunityPolicyBusiness op ON o.OpportunityId = op.OpportunityId				-- Linked opportunity
		INNER JOIN CRM..TOpportunityType ot ON o.OpportunityTypeId = ot.OpportunityTypeId
		INNER JOIN CRM..TMortgageOpportunity mo ON o.OpportunityId = mo.OpportunityId
		INNER JOIN CRM..TOpportunityCustomer oc ON oc.Opportunityid = o.OpportunityId
		WHERE @Owner2Id IS NOT NULL 		
		AND oc.PartyId = @Owner2Id
		AND ot.OpportunityTypeName = 'Mortgage'
		AND o.IsClosed=0

	
	--Return if none found
	IF (SELECT COUNT(1) FROM @Opportunities) = 0 
		RETURN(0)
	
	
	--Remove Positive hits
	DELETE FROM @Opportunities 
	WHERE MortgageRepaymentMethod = 'YES'
	AND MortgageType = 'YES'
	AND PlanPurpose = 'YES'
	AND RelatedProperty = 'YES'
	AND SourceOfDeposit = 'YES'
	AND Term = 'YES'
	AND Deposit = 'YES'
	AND Price = 'YES'
	
	--Return if none found
	IF (SELECT COUNT(1) FROM @Opportunities) = 0 
		RETURN(0)
	
	

	DECLARE @Ids VARCHAR(max)  
		SELECT @Ids = COALESCE(@Ids + '&&', '') + 
			'OpportunityId=' + convert(varchar(50),OpportunityId) + '::' +  
			'SequentialRef=' + SequentialRef  + '::' + 
			'FactFindId=' + convert(varchar(20),@FactFindId) + '::'+  
			'FactFindPrimaryOwnerId=' + convert(varchar(20),@FactFindPrimaryOwnerId) + '::'+  
			'OwnerId=' + convert(varchar(20),OwnerId) + '::'+  
			'OwnerName=' + convert(varchar(20),OwnerName) + '::'+  			 
			'MortgageRepaymentMethod='+ MortgageRepaymentMethod + '::' +  
			'MortgageType='+ MortgageType + '::' +  
			'PlanPurpose='+ PlanPurpose + '::' +  
			'RelatedProperty='+ RelatedProperty + '::' +  
			'SourceOfDeposit='+ SourceOfDeposit + '::' +  
			'Term='+ Term + '::' +  
			'Deposit='+ Deposit + '::' +  
			'Price='+ Price 		
			
		FROM @Opportunities
				
		SELECT @ErrorMessage = 'LINKEDMORTGAGEOPPORTUNITYFIELDS_' + @Ids

	

GO
