USE [crm]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VwEmailDocumentDetails]
AS
SELECT 
	ROW_NUMBER() OVER (ORDER BY [e].[EmailId]) AS AutoIncrementColumn,[e].[EmailId] AS [Id]
	,[oa].[IndigoClientId] AS [TenantId]
	,[e].[Subject]
	,[e].[SentDate]
	,[e].[FromAddress]
	,[e].[EmailSize]
	,[e].[AttachmentCount]
	,[e].[HasHtmlBody] AS [HasHtml]
	,[e].[Source]
	,[e].[MessageDocId]
	,[oa].[PropertiesJson] AS [Properties]
	,IIF([eoa].[EntityOrganiserActivityId] IS NULL, 1, 0) AS [IsOrphan]
	,[u].[UserId]
	,[u].[Identifier] AS [UserName]
	,[ea].[EmailAddressId]
	,[ea].[Address]
	,[ea].[IsCCAddress]
	,CASE 
		WHEN [ccrmc].[CRMContactId] IS NOT NULL
			AND [ccrmc].[CRMContactId] <> 0
			THEN [ccrmc].[CRMContactId]
		WHEN [l].[LeadId] IS NOT NULL
			AND [l].[LeadId] <> 0
			THEN [l].[LeadId]
		WHEN [p].[PractitionerId] IS NOT NULL
			AND [p].[PractitionerId] <> 0
			THEN [p].[PractitionerId]
		WHEN [a].[AccountId] IS NOT NULL
			AND [a].[AccountId] <> 0
			THEN [a].[AccountId]
		END AS [RelatedToId]
	,CASE 
		WHEN [ccrmc].[CRMContactId] IS NOT NULL
			AND [ccrmc].[CRMContactId] <> 0
			THEN 'Client'
		WHEN [l].[LeadId] IS NOT NULL
			AND [l].[LeadId] <> 0
			THEN 'Lead'
		WHEN [p].[PractitionerId] IS NOT NULL
			AND [p].[PractitionerId] <> 0
			THEN 'Adviser'
		WHEN [a].[AccountId] IS NOT NULL
			AND [a].[AccountId] <> 0
			THEN 'Account'
		END AS [RelatedToType]
	,CASE 
		WHEN [ccrmc].[CRMContactId] IS NOT NULL
			AND [ccrmc].[CRMContactId] <> 0
			THEN ISNULL([ccrmc].[FirstName], '') + ' ' + ISNULL([ccrmc].[LastName], '') + ISNULL([ccrmc].[CorporateName], '')
		WHEN [l].[LeadId] IS NOT NULL
			AND [l].[LeadId] <> 0
			THEN ISNULL([lcrmc].[FirstName], '') + ' ' + ISNULL([lcrmc].[LastName], '') + ISNULL([lcrmc].[CorporateName], '')
		WHEN [p].[PractitionerId] IS NOT NULL
			AND [p].[PractitionerId] <> 0
			THEN ISNULL([pcrmc].[FirstName], '') + ' ' + ISNULL([pcrmc].[LastName], '') + ISNULL([pcrmc].[CorporateName], '')
		WHEN [a].[AccountId] IS NOT NULL
			AND [a].[AccountId] <> 0
			THEN ISNULL([acrmc].[FirstName], '') + ' ' + ISNULL([acrmc].[LastName], '') + ISNULL([acrmc].[CorporateName], '')
		END AS [CorporateName]
	,[at].[AttachmentDocId]
	,[at].[AttachmentName]
	,[at].[AttachmentSize]
FROM [TEmail] [e]
INNER JOIN [TOrganiserActivity] [oa] ON [oa].[OrganiserActivityId] = [e].[OrganiserActivityId]
LEFT JOIN [TEmailAddress] [ea] ON [e].[EmailId] = [ea].[EmailId]
LEFT JOIN [TEntityOrganiserActivity] [eoa] ON [eoa].[OrganiserActivityId] = [e].[OrganiserActivityId]
LEFT JOIN [TActivityEntityType] [aet] ON [aet].[ActivityEntityTypeId] = [eoa].[ActivityEntityTypeId]
LEFT JOIN [TAttachment] [at] ON [at].[EmailId] = [e].[EmailId]
LEFT JOIN [administration]..[TUser] [u] ON [u].[CRMContactId] = [e].[OwnerPartyId]
	AND [u].[IndigoClientId] = [oa].[IndigoClientId]
LEFT JOIN [TLead] [l] ON [l].[CRMContactId] = [eoa].[EntityId]
LEFT JOIN [TCRMContact] [lcrmc] ON [lcrmc].[CRMContactId] = [l].[CRMContactId]
	AND [lcrmc].[RefCRMContactStatusId] = 2
LEFT JOIN [TPractitioner] [p] ON [p].[CRMContactId] = [eoa].[EntityId]
LEFT JOIN [TCRMContact] [pcrmc] ON [pcrmc].[CRMContactId] = [p].[CRMContactId]
LEFT JOIN [TAccount] [a] ON [a].[CRMContactId] = [eoa].[EntityId]
LEFT JOIN [TCRMContact] [acrmc] ON [acrmc].[CRMContactId] = [a].[CRMContactId]
LEFT JOIN [TCRMContact] [ccrmc] ON [ccrmc].[CRMContactId] = [eoa].[EntityId]
	AND [ccrmc].[RefCRMContactStatusId] = 1
GO