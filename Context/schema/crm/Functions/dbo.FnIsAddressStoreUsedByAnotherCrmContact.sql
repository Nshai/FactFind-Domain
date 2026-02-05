SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Description: This function checks if the address is used by other users
-- =============================================
CREATE FUNCTION [dbo].[FnIsAddressStoreUsedByAnotherCrmContact]
(
	@IndigoClientId bigint,
	@CRMContactId	bigint,
	@AddressStoreId bigint
)  
RETURNS bit
AS  
BEGIN
DECLARE @ResultCount int
DECLARE @temp_addresses TABLE(CRMContactId INT NOT NULL);
BEGIN
	INSERT INTO @temp_addresses 
	SELECT TOP 2 CRMContactId FROM CRM..TAddress WHERE @IndigoClientId = IndClientId AND AddressStoreId = @AddressStoreId 
	
	SELECT @ResultCount = @@ROWCOUNT
	
	IF(@ResultCount > 1)
		RETURN 1

	/*	in case of only 1 linked TAddress we should ensure that this address belongs 
		to another CrmContactId to avoid deletion of AddressStore during two simultaneous requests
		when a first request has already relinked current client and a second concurrent 
		request trying to get updated TAddress using obsolete 
		(taken before 1st request transaction has been commited) AddressStoreId
	*/
	IF(@ResultCount = 1)
		IF(EXISTS(SELECT 1 FROM @temp_addresses WHERE CRMContactId = @CRMContactId))
			RETURN 0
		ELSE
			RETURN 1
	
	IF(EXISTS(SELECT 1
			  FROM policymanagement..TMortgage m
			  JOIN policymanagement..TPolicyBusiness b ON m.PolicyBusinessId = b.PolicyBusinessId
			  WHERE m.IndigoClientId = @IndigoClientId 
			  AND m.AddressStoreId = @AddressStoreId
			  AND NOT EXISTS(SELECT 1 
							 FROM policymanagement..TPolicyOwner
							 WHERE CRMContactId = @CRMContactId
							 AND PolicyDetailId = B.PolicyDetailId)))
	RETURN 1
	
	IF(EXISTS(SELECT 1 
			  FROM policymanagement..TEquityRelease e
			  JOIN policymanagement..TPolicyBusiness b ON e.PolicyBusinessId = b.PolicyBusinessId
			  WHERE e.IndigoClientId = @IndigoClientId
			  AND e.AddressStoreId = @AddressStoreId
			  AND NOT EXISTS(SELECT 1 
							 FROM policymanagement..TPolicyOwner
							 WHERE CRMContactId = @CRMContactId
							 AND PolicyDetailId = B.PolicyDetailId)))	
											   
	RETURN 1

END

RETURN 0

END
GO