SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE dbo.SpBulkValuationReport
    @ValScheduleItemId bigint
AS

BEGIN

      SELECT DISTINCT C.Corporatename ProviderName
      ,ISNULL(H.AdviserFirstName,'') + ' ' + ISNULL(H.AdviserLastName,'') AdviserName
      ,ISNULL(H.FirstName,'') + ' ' + ISNULL(H.LastName,'') ClientName
      ,ISNULL(H.Corporatename,'') CorporateClientName
      ,H.PortfolioType PlanType
      ,H.CustomerReference
      ,H.PortfolioReference
      ,CASE When R.PlanMatched = 1 Then 'Plan Matched' ELSE
            CASE
            WHEN VBHR.InEligibilityReasons IS NOT NULL THEN VBHR.InEligibilityReasons
            ELSE 'No Plan Match' END END AS StatusReason
      ,CASE
      WHEN S.ScheduledLevel = 'firm' THEN I.LastOccurrence
      WHEN S.ScheduledLevel = 'bulkmanual' THEN S.StartDate
      END AS [UploadProcessDate]
      FROM MIRDB..TValBulkHoldingResult R
      JOIN MIRDB..TValSchedule S ON R.ValScheduleId = S.ValScheduleId
      JOIN MIRDB..TValScheduleItem I ON S.ValScheduleId = I.ValScheduleId
      JOIN MIRDB..TValBulkHolding H ON R.ValBulkHoldingID = H.ValBulkHoldingId
      JOIN MIRDB..TRefProdProvider RP ON RP.RefProdProviderId = S.RefProdProviderId
      JOIN MIRDB..TCrmcontact C ON C.CrmContactID = RP.CrmContactID
      JOIN
      ( SELECT ValBulkHoldingResultId,
      STUFF(
      COALESCE(','+ [New valuation date must be after current plan valuation date],'')
      + COALESCE(','+ [Duplicate fund grouping error],'')
      ,1
      ,1
      ,'') InEligibilityReasons
      FROM
      (SELECT
      R.ValBulkHoldingResultId, F.InEligibilityDescription
      FROM
      TValRefBulkHoldingInEligibilityFlag F
      INNER JOIN TValBulkHoldingResult R ON F.InEligibilityFlag & R.PlanInEligibilityMask <> 0
      ) Src
      PIVOT
      (
      Max(InEligibilityDescription)
      FOR InEligibilityDescription
      IN ([New valuation date must be after current plan valuation date], [Duplicate fund grouping error] )
      ) Pvt
      ) VBHR
      ON VBHR.ValBulkHoldingResultId = R.ValBulkHoldingID
      WHERE  I.ValScheduleItemId = @ValScheduleItemId

END
GO
