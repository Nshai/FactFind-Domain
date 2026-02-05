SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [dbo].[VAdviceCaseUnAssociatedRetainers]
As

SELECT
	ACR.AdviceCaseRetainerId, 
	ACR.AdviceCaseId, 
	T2.CRMContactId AS PartyId,
	PolicyManagement.dbo.FnCustomFFRetrieveRetainerOwners(T1.RetainerId) AS OwnerName,
	T1.SequentialRef,  
	T1.RetainerId,     
	T1.NetAmount AS [RetainerNetAmount],      
	T1.VATAmount AS [RetainerVATAmount],     
	T1.StartDate,     
	ISNULL(T1.Description,'') AS [RetainerDescription], 
	ISNULL(T2.BandingTemplateId,0) AS [BandingTemplateId]
	 
FROM PolicyManagement..TRetainer T1  WITH(NOLOCK) 
	JOIN  PolicyManagement..TFeeRetainerOwner T2   WITH(NOLOCK)  ON T1.RetainerId=T2.RetainerId
	LEFT JOIN CRM..TAdviceCaseRetainer ACR   WITH(NOLOCK) ON T1.RetainerId=ACR.RetainerId


GO
