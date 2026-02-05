SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE VIEW [dbo].[VClientFeeSection]
AS
SELECT [RowId],
 [RecordId],
 [OwnerId],
 [SecondaryOwnerId],
 [RecordType],
 [SequentialReference],
 [FeeLinkedPlanRefNums],
 [PlanProviderName],
 [PlanTypeName],
 [PolicyNumber],
 [Description],
 [ReportName],
 [NetAmount],
 [Period],
 [InvoiceDate],
 [VATExempt],
 [SentToClientDate],
 [ConcurrencyId],
 [FeeModelName],
 [PercentageOfFee],
 [InitialPeriod],
 [FeeChargingTypeName],
 [FeeTypeName],
 [PaidBy],
 [FeeChargingDetailsName],
 [FeeChargingDetailsId],
 [RefAdviseFeeChargingTypeId]

FROM (
 SELECT
 Fee.FeeId+100000000 AS RowId,
 Fee.FeeId AS RecordId,
 FeeRetainerOwner.CRMContactId AS OwnerId,
 FeeRetainerOwner.SecondaryOwnerId AS SecondaryOwnerId,
 'Fee' AS RecordType,
 Fee.SequentialRef AS SequentialReference,
 aggregatedPlanProperties.FeeLinkedPlanRefNums AS FeeLinkedPlanRefNums,
 aggregatedPlanProperties.ProviderName AS PlanProviderName,
 aggregatedPlanProperties.PlanType AS PlanTypeName,
 aggregatedPlanProperties.PolicyNumber AS PolicyNumber,
 CASE Fee.IsRecurring
  WHEN 1 THEN 'Fee (I)'
  ELSE 'Fee'
 END AS [Description],
 'Fee' AS ReportName,
 CASE
  WHEN Fee.RefFeeTypeId = 3 AND (Fee.NetAmount = 0 OR Fee.NetAmount IS NULL)
           THEN 'In progress or pending valuation.'
  ELSE CAST(Fee.NetAmount AS varchar)
 END AS NetAmount,
 CASE  Fee.IsRecurring
  WHEN 1 THEN CAST(FeeRetFequency.PeriodName AS varchar)
  WHEN 0 THEN CAST(RecurringFrequency.PeriodName AS varchar)
  ELSE ''
 END AS Period,
 Fee.InvoiceDate AS InvoiceDate,
 CAST(Fee.VATExempt AS varchar) AS VATExempt,
 NULL AS SentToClientDate,
 Fee.ConcurrencyId AS ConcurrencyId,
 FeeModel.Name AS FeeModelName,
  --check if the Fee charging type is Fixed Price/Fixed price-Range/Non-chargeable the % is returned as 0.
  --For these there is no % available so it should not be displayed. Hence use of CASE...WHEN...THEN statement
  CASE WHEN (RefAdviseFeeChargingType.Name = 'Fixed Price' OR RefAdviseFeeChargingType.Name = 'Non-chargeable'
  OR RefAdviseFeeChargingType.Name = 'Fixed price-Range'
  OR RefAdviseFeeChargingType.Name = 'Billing rate fee - Time Based'
  OR RefAdviseFeeChargingType.Name = 'Billing rate fee - Task Based')
  THEN ''
  -- for '% FUM/AUM' & '% Investment Contribution' Fee Charging type.
  -- when FeePercentage has value in TFee table, then fetch Fee % from TFee table
  -- else fetch Fee % from TFeeChargingDetails table
  ELSE CASE WHEN Fee.FeePercentage IS NULL THEN CAST(FeeChargingDetails.PercentageOfFee AS varchar)
	ELSE CAST(Fee.FeePercentage AS varchar) END
  END AS PercentageOfFee,
  CASE WHEN Fee.InitialPeriod > 0 THEN  Fee.InitialPeriod ELSE NULL END AS InitialPeriod,
  -- added for RDRCHARGINGII-1016
  CASE WHEN (RefAdviseFeeChargingType.Name != '' OR RefAdviseFeeChargingType.Name != null)
  THEN CAST (RefAdviseFeeChargingType.Name AS varchar(max))
  ELSE ''
  END AS FeeChargingTypeName,

  CASE WHEN (FeeType.Name != '' OR FeeType.Name != null)
  THEN CAST (FeeType.Name AS varchar(MAX))
  ELSE ''
  END AS FeeTypeName,

  CASE WHEN (RefAdvisePaidBy.Name != '' OR RefAdvisePaidBy.Name != NULL)
  THEN CAST (RefAdvisePaidBy.Name AS varchar(MAX))
  ELSE ''
  END AS PaidBy,
  FeeChargingDetails.Name AS FeeChargingDetailsName,
  FeeChargingDetails.AdviseFeeChargingDetailsId AS FeeChargingDetailsId,
  RefAdviseFeeChargingType.RefAdviseFeeChargingTypeId AS RefAdviseFeeChargingTypeId
FROM
 TFeeRetainerOwner FeeRetainerOwner
 INNER JOIN TFee Fee
  ON Fee.FeeId = FeeRetainerOwner.FeeId
 LEFT JOIN TRefFeeRetainerFrequency FeeRetFequency
  ON FeeRetFequency.RefFeeRetainerFrequencyId = Fee.RefFeeRetainerFrequencyId
 LEFT JOIN TRefFeeRetainerFrequency RecurringFrequency
  ON RecurringFrequency.RefFeeRetainerFrequencyId = Fee.RecurringFrequencyId
  --RDRCHARGINGII-242: Join added for fetching fee model name
  LEFT JOIN TFeeModelTemplate ON TFeeModelTemplate.FeeModelTemplateId = Fee.FeeModelTemplateId
  LEFT JOIN TFeeModel FeeModel ON FeeModel.FeeModelId = TFeeModelTemplate.FeeModelId
  --RDRCHARGINGII-1016: join added for fetching fee Type name
  LEFT JOIN TAdviseFeeType FeeType ON FeeType.AdviseFeeTypeId = Fee.AdviseFeeTypeId

  --RDRCHARGINGII-684: Add join to fetch the fee percentage
  LEFT JOIN TAdviseFeeChargingDetails FeeChargingDetails ON FeeChargingDetails.AdviseFeeChargingDetailsId = Fee.AdviseFeeChargingDetailsId
  --Join to fetch the Ref fee charging type name
  LEFT JOIN TAdviseFeeChargingType FeeChargingType ON FeeChargingType.AdviseFeeChargingTypeId = FeeChargingDetails.AdviseFeeChargingTypeId
  LEFT JOIN TRefAdviseFeeChargingType RefAdviseFeeChargingType ON RefAdviseFeeChargingType.RefAdviseFeeChargingTypeId = FeeChargingType.RefAdviseFeeChargingTypeId
  LEFT JOIN TAdvisePaymentType AdvisePaymentType ON AdvisePaymentType.AdvisePaymentTypeId = Fee.AdvisePaymentTypeId
  LEFT JOIN TRefAdvisePaidBy RefAdvisePaidBy ON RefAdvisePaidBy.RefAdvisePaidById = AdvisePaymentType.RefAdvisePaidById

  LEFT JOIN (SELECT
  STRING_AGG(ISNULL(planTypeAndProvider.PlanType, ''), ' | ') AS PlanType,
  STRING_AGG(ISNULL(planTypeAndProvider.ProviderName, ''), ' | ') AS ProviderName,
  STRING_AGG(ISNULL(policyBusiness.PolicyNumber, ''), ' | ') AS PolicyNumber,
  STRING_AGG(policyBusiness.SequentialRef, ', ') AS FeeLinkedPlanRefNums,
  fee2Policy.FeeId AS FeeId
FROM TFee2Policy fee2Policy
INNER JOIN VwPlanTypeAndProvider planTypeAndProvider
  ON planTypeAndProvider.PolicyBusinessId = fee2Policy.PolicyBusinessId
INNER JOIN TPolicyBusiness policyBusiness
  ON policyBusiness.PolicyBusinessId = planTypeAndProvider.PolicyBusinessId
GROUP BY fee2Policy.FeeId) aggregatedPlanProperties
  ON aggregatedPlanProperties.FeeId = Fee.FeeId

UNION ALL

SELECT
 CreditNote.CreditNoteId+200000000 AS RowId,
 CreditNote.CreditNoteId AS RecordId,
 FeeRetainerOwner.CRMContactId AS OwnerId,
 FeeRetainerOwner.SecondaryOwnerId AS SecondaryOwnerId,
 'Credit Note Fees' AS RecordType,
 CreditNote.SequentialRef AS SequentialReference,
 NULL AS FeeLinkedPlanRefNums,
 NULL AS PlanProviderName,
 NULL AS PlanTypeName,
 NULL AS PolicyNumber,
 CASE
  WHEN CreditNote.ProvBreakId > 0 THEN 'Commission Rebate'
  ELSE 'Credit Note'
 END AS [Description],
 'CreditNote' AS ReportName,
 CAST(-(CreditNote.NetAmount) AS varchar) AS NetAmount,
 '' AS Period,
 NULL AS InvoiceDate,
 Fee.VATExempt AS VATExempt,
 NULL AS SentToClientDate,
 CreditNote.ConcurrencyId AS ConcurrencyId,
 '' AS FeeModelName,
 --Return the fee % AS null for Credit Note Fees
 '' AS PercentageOfFee, NULL AS InitialPeriod,
 '' AS FeeChargingTypeName, '' AS FeeTypeName,
 '' AS PaidBy,
  '' AS FeeChargingDetailsName,
  '' AS FeeChargingDetailsId,
  '' AS RefAdviseFeeChargingTypeId
FROM
 TFeeRetainerOwner FeeRetainerOwner
 INNER JOIN TFee Fee
  ON Fee.FeeId = FeeRetainerOwner.FeeId
 INNER JOIN TCreditNote CreditNote
  ON CreditNote.FeeId = Fee.FeeId

UNION ALL

SELECT
 CreditNote.CreditNoteId+300000000 AS RowId,
 CreditNote.CreditNoteId AS RecordId,
 FeeRetainerOwner.CRMContactId AS OwnerId,
 FeeRetainerOwner.SecondaryOwnerId AS SecondaryOwnerId,
    'Credit Note Retainer' AS RecordType,
 CreditNote.SequentialRef AS SequentialReference,
 NULL AS FeeLinkedPlanRefNums,
 NULL AS PlanProviderName,
 NULL AS PlanTypeName,
 NULL AS PolicyNumber,
 CASE
  WHEN CreditNote.ProvBreakId > 0 THEN 'Commission Rebate'
  ELSE 'Credit Note'
 END AS [Description],
 'CreditNote' AS ReportName,
 CAST(-(CreditNote.NetAmount) AS varchar) AS NetAmount,
 '' AS [PaymentItem!1!Period],
 NULL AS [PaymentItem!1!InvoiceDate],
 Retainer.IsVatExempt AS VATExempt,
 Retainer.SentToClientDate AS SentToClientDate,
 CreditNote.ConcurrencyId AS ConcurrencyId,
 '' AS FeeModelName,
 --Return the fee % AS null for Credit Note Retainer
 '' AS PercentageOfFee, NULL AS InitialPeriod,
 '' AS FeeChargingTypeName, '' AS FeeTypeName,
 '' AS PaidBy,
  '' AS FeeChargingDetailsName,
  '' AS FeeChargingDetailsId,
  '' AS RefAdviseFeeChargingTypeId
FROM
 TFeeRetainerOwner FeeRetainerOwner
 INNER JOIN TRetainer Retainer
  ON Retainer.RetainerId = FeeRetainerOwner.RetainerId
 INNER JOIN TCreditNote CreditNote
  ON CreditNote.RetainerId = FeeRetainerOwner.RetainerId

UNION ALL

SELECT
 Retainer.RetainerId+400000000 AS RowId,
 Retainer.RetainerId AS RecordId,
 FeeRetainerOwner.CRMContactId AS OwnerId,
 FeeRetainerOwner.SecondaryOwnerId AS SecondaryOwnerId,
 'Retainer' AS RecordType,
 Retainer.SequentialRef AS SequentialReference,
 NULL AS FeeLinkedPlanRefNums,
 NULL AS PlanProviderName,
 NULL AS PlanTypeName,
 NULL AS PolicyNumber,
 'Retainer' AS [Description],
 'Retainer' AS ReportName,
 CAST(Retainer.NetAmount AS varchar) AS NetAmount,
 RefFeeRetFrequency.PeriodName AS Period,
    NULL AS [PaymentItem!1!InvoiceDate],
 Retainer.IsVatExempt AS VATExempt,
 Retainer.SentToClientDate AS SentToClientDate,
 Retainer.ConcurrencyId AS ConcurrencyId,
 '' AS FeeModelName,
 '' AS PercentageOfFee,
  NULL AS InitialPeriod,
 '' AS FeeChargingTypeName,
 '' AS FeeTypeName,
 '' AS PaidBy,
  '' AS FeeChargingDetailsName,
  '' AS FeeChargingDetailsId,
  '' AS RefAdviseFeeChargingTypeId

FROM
 TFeeRetainerOwner FeeRetainerOwner
 INNER JOIN TRetainer Retainer
  ON Retainer.RetainerId = FeeRetainerOwner.RetainerId
 LEFT JOIN TRefFeeRetainerFrequency RefFeeRetFrequency
  ON RefFeeRetFrequency.RefFeeRetainerFrequencyId = Retainer.RefFeeRetainerFrequencyId

) SUB

GO
