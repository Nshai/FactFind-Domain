CREATE PROCEDURE [dbo].[spRetrieveOrgPartyCallbackDTO]
	@tenantId INT, 
	@organiserActivityIds VARCHAR(MAX)
AS
BEGIN
	SELECT 
		[TOA].[OrganiserActivityId],
		[PartyId] = [TOA].[CRMContactId],
		[CallbackType] = 
			CASE 
				WHEN [TOA].[CRMContactId] IS NULL THEN 1		-- None
				WHEN [TC].[RefCRMContactStatusId] = 1 THEN 2	-- Client
				WHEN [TC].[RefCRMContactStatusId] = 2 THEN 3	-- Lead
				WHEN [TA].[CRMContactId] IS NOT NULL THEN 4		-- Account
				WHEN [TP].[CRMContactId] IS NOT NULL THEN 5		-- Adviser
				ELSE 0											-- Undefined
			END
	FROM 
		[crm].[dbo].[TOrganiserActivity] TOA
		JOIN STRING_SPLIT(@organiserActivityIds, ',') Ids ON [Ids].[Value] = [TOA].[OrganiserActivityId] 
		LEFT JOIN [crm].[dbo].[TCrmContact] TC ON [TC].[IndClientId] = [TOA].[IndigoClientId] AND [TC].[CRMContactId] = [TOA].[CRMContactId]
		LEFT JOIN [crm].[dbo].[TPractitioner] TP ON [TP].[IndClientId] = [TOA].[IndigoClientId] AND [TP].[CRMContactId] = [TOA].[CRMContactId]
		LEFT JOIN [crm].[dbo].[TAccount] TA ON [TA].[IndigoClientId] = [TOA].[IndigoClientId] AND [TA].[CRMContactId] = [TOA].[CRMContactId]
	WHERE
		[TOA].[IndigoClientId] = @tenantId
END