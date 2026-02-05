SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[nio_SpRetrieveOutstandingPlansForAdviserSpToGetColumnList]
	(		
		@AdviserCRMContactId bigint	
	)
as      
      
SELECT  
    0 AS [PlanId],
    '' AS [Number], 
    '' AS [Status], 
    0 AS [StatusId], 
    0 as [RefPlanTypeId],
    '' AS [Name],  
    '' AS [Provider], 
    0 AS [PolicyBusinessId], 
    0 AS [PolicyDetailId] ,
    0 AS [IsTopUp],
    '' AS [ProdSubTypeName],
    '' AS [ChangedToDate],
    0 AS [CRMContactId],
    0 AS [CRMContactType],
    '' AS [ClientName],
    '' AS [ClientLastName], 
    '' AS [ClientFirstName], 
    '' AS [CorporateName], 
    '' AS [ClientRef]
GO
