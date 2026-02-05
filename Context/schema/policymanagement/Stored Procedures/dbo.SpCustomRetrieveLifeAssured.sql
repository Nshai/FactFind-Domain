SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE dbo.SpCustomRetrieveLifeAssured
    @PolicyBusinessIds  VARCHAR(8000),
    @TenantId bigint
AS
    IF OBJECT_ID('tempdb..#pbs') IS NOT NULL
        DROP TABLE  #pbs

SELECT pb.PolicyBusinessId
INTO #pbs
FROM policymanagement..TPolicyBusiness pb
JOIN policymanagement..FnSplit(@PolicyBusinessIds, ',') parslist ON pb.PolicyBusinessId = parslist.Value
WHERE pb.IndigoClientId = @TenantId


SELECT al.[AssuredLifeId]
     ,al.[ProtectionId]
     ,al.[PartyId]
     ,al.[IndigoClientId]
     ,IIF(al.[PartyId] IS NULL, al.[Title], per.[Title]) AS Title
     ,IIF(al.[PartyId] IS NULL, al.[FirstName], per.[FirstName]) AS FirstName
     ,IIF(al.[PartyId] IS NULL, al.[LastName], per.[LastName]) AS LastName
     ,IIF(al.[PartyId] IS NULL, al.[DOB], per.[DOB]) AS DOB
     ,IIF(al.[PartyId] IS NULL, al.[GenderType], per.[GenderType]) AS GenderType
     ,p.[PolicyBusinessId]
FROM #pbs pbs
JOIN [policymanagement]..[TProtection] p ON p.PolicyBusinessId = pbs.PolicyBusinessId
JOIN [policymanagement]..[TAssuredLife] al ON al.[ProtectionId] = p.[ProtectionId]
LEFT JOIN [crm]..[TCRMContact] c ON al.PartyId = c.CRMContactId
LEFT JOIN [crm]..[TPerson] per ON per.PersonId = c.PersonId
