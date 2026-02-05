SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditAdvisePaymentType]   
			@StampUser varchar (255)
			,@AdvisePaymentTypeId bigint
			,@StampAction char(1)  
AS    
INSERT INTO 
	TAdvisePaymentTypeAudit   
	(TenantId
	, IsArchived
	, ConcurrencyId
	, AdvisePaymentTypeId
	, StampAction
	, StampDateTime
	, StampUser
	, Name
	, IsSystemDefined
	, GroupId
	, RefAdvisePaidById
	, PaymentProviderId)   
SELECT 
	TenantId
	, IsArchived
	, ConcurrencyId
	, AdvisePaymentTypeId
	, @StampAction
	, GetDate()
	, @StampUser
	, Name
	, IsSystemDefined
	, GroupId
	, RefAdvisePaidById
	, PaymentProviderId
FROM 
	TAdvisePaymentType  
WHERE 
	AdvisePaymentTypeId = @AdvisePaymentTypeId    
	
IF @@ERROR != 0 GOTO errh    
RETURN (0)    

errh:  RETURN (100)
GO
