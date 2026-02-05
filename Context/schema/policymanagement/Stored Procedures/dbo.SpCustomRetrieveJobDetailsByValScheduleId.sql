SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SpCustomRetrieveJobDetailsByValScheduleId] @ValScheduleId bigint
AS        
          
SELECT 
	1 as Tag,
	NULL as Parent, 
	isnull(S.ValScheduleId,0) AS [Job!1!ScheduleId],
	isnull(I.ValScheduleItemId,0) AS [Job!1!ScheduleItemId],
	isnull(S.IndigoClientId,0) AS [Job!1!ICId],
	isnull(C.Identifier,'') AS [Job!1!ICName],
	isnull(S.RefProdProviderId,0) AS [Job!1!ProviderId],
	isnull(CR.CorporateName,'') AS [Job!1!ProviderName],
	isnull(S.UserNameForFileAccess,'')  AS [Job!1!JobUser],
    isnull(G.Identifier,'')  AS [Job!1!Group],
    isnull(S.RefGroupId,'')  AS [Job!1!GroupId],
	isnull(I.DocversionId,'')  AS [Job!1!DocVersionId]
FROM
	TValschedule S 
		join TValScheduleItem I WITH (NOLOCK) ON s.ValScheduleId = i.ValScheduleId
		join administration..TIndigoClient C WITH (NOLOCK) on S.IndigoClientId = c.IndigoClientId
		join TRefProdProvider RP WITH (NOLOCK) on S.RefProdProviderId = RP.RefProdProviderId
		join CRM..TCRMContact CR WITH (NOLOCK) on RP.CRMContactId = CR.CRMContactId				
        left join Administration..TGroup g WITH (NOLOCK) on g.GroupId = s.RefGroupId
WHERE s.ValScheduleId = @ValScheduleId
FOR XML EXPLICIT

GO

