SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
/*
	Custom SP for retrieving the portal details.
	LIO Procedure: SpRetrieveValPortalSetupById
*/  

CREATE PROCEDURE [dbo].[nio_ContractEnquiry_RetrieveValPortalSetupById]
	@ValPortalSetupId bigint
AS

exec dbo.SpNioCustomOpenSymmetricKeyForPasswordEncryption

BEGIN
	SELECT
	T1.ValPortalSetupId AS [ValPortalSetupId], 
	T1.CRMContactId AS [CRMContactId], 
	T1.RefProdProviderId AS [RefProdProviderId], 
    IsNull(T3.CorporateName,'') AS [ProviderName],   
	ISNULL(T1.UserName, '') AS [UserName], 
	dbo.FnCustomDecryptPortalPassword(Password2) AS [Password],
	isnull(T1.Passcode, '') as [Passcode],
	ISNULL(CONVERT(varchar(24), T1.CreatedDate, 120), '') AS [CreatedDate], 
	T1.ConcurrencyId AS [ConcurrencyId]

	FROM TValPortalSetup T1

	Inner Join PolicyManagement.dbo.TRefProdProvider T2 WITH(NOLOCK)       
		On T1.RefProdProviderId = T2.RefProdProviderId  

	Inner Join CRM.dbo.TCRMContact T3 WITH(NOLOCK)     
		On T2.CRMContactId = T3.CRMContactId    

	Left Join PolicyManagement.dbo.TValSchedule TSch WITH(NOLOCK)     
		On TSch.RefProdProviderId = T1.RefProdProviderId
		--And TSch.ScheduledLevel = 'adviser'              
		And TSch.PortalCRMContactId = T1.CRMContactId -- Added this on 31/08/2006 

	WHERE T1.ValPortalSetupId = @ValPortalSetupId

END
RETURN (0)

GO



