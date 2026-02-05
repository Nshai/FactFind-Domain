SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefProdProvider]
	@StampUser varchar (255),
	@RefProdProviderId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefProdProviderAudit 
( 
	CRMContactId
	,FundProviderId
	,NewProdProviderId
	,RetireFg
	,ConcurrencyId
	,IsTransactionFeedSupported
	,RefProdProviderId
	,IsBankAccountTransactionFeed
	,IsConsumerFriendly
	,RegionCode
	,StampAction
	,StampDateTime
	,StampUser
	,DTCCIdentifier) 
Select 
	CRMContactId
	,FundProviderId
	,NewProdProviderId
	,RetireFg
	,ConcurrencyId
	,IsTransactionFeedSupported
	,RefProdProviderId
	,IsBankAccountTransactionFeed
	,IsConsumerFriendly
	,RegionCode
	,@StampAction
	,GetDate()
	,@StampUser
	,DTCCIdentifier
FROM TRefProdProvider
WHERE RefProdProviderId = @RefProdProviderId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
