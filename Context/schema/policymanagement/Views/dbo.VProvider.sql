SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW dbo.VProvider
AS
SELECT        
	 A.RefProdProviderId
	,A.CRMContactId AS PartyId
	,B.CorporateName AS Name
	,A.RetireFg
	,A.IsConsumerFriendly
	,A.IsTransactionFeedSupported
	,A.IsBankAccountTransactionFeed
	,A.RegionCode
	,A.DTCCIdentifier
FROM
	dbo.TRefProdProvider AS A 
	INNER JOIN crm.dbo.TCRMContact AS B 
		ON A.CRMContactId = B.CRMContactId
GO
