SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrievePolicyDetailById]
@PolicyDetailId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.PolicyDetailId AS [PolicyDetail!1!PolicyDetailId], 
    T1.PlanDescriptionId AS [PolicyDetail!1!PlanDescriptionId], 
    ISNULL(T1.TermYears, '') AS [PolicyDetail!1!TermYears], 
    ISNULL(T1.WholeOfLifeFg, '') AS [PolicyDetail!1!WholeOfLifeFg], 
    ISNULL(T1.LetterOfAuthorityFg, '') AS [PolicyDetail!1!LetterOfAuthorityFg], 
    ISNULL(T1.ContractOutOfSERPSFg, '') AS [PolicyDetail!1!ContractOutOfSERPSFg], 
    ISNULL(CONVERT(varchar(24), T1.ContractOutStartDate, 120),'') AS [PolicyDetail!1!ContractOutStartDate], 
    ISNULL(CONVERT(varchar(24), T1.ContractOutStopDate, 120),'') AS [PolicyDetail!1!ContractOutStopDate], 
    ISNULL(T1.AssignedCRMContactId, '') AS [PolicyDetail!1!AssignedCRMContactId], 
    ISNULL(CONVERT(varchar(24), T1.JoiningDate, 120),'') AS [PolicyDetail!1!JoiningDate], 
    ISNULL(CONVERT(varchar(24), T1.LeavingDate, 120),'') AS [PolicyDetail!1!LeavingDate], 
    T1.IndigoClientId AS [PolicyDetail!1!IndigoClientId], 
    T1.ConcurrencyId AS [PolicyDetail!1!ConcurrencyId]
  FROM TPolicyDetail T1

  WHERE (T1.PolicyDetailId = @PolicyDetailId)

  ORDER BY [PolicyDetail!1!PolicyDetailId]

  FOR XML EXPLICIT

END
RETURN (0)




GO
