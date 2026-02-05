USE PolicyManagement
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SpNRetrieveClientFeeTemplatesByServiceCaseIds]
    @AdviceCaseIds VARCHAR(8000)	
AS
BEGIN

    SET NOCOUNT ON;
	
    SELECT
     acas.[AdviceCaseId] as ServiceCaseId
    ,fmt.FeeModelTemplateId as FeeModelTemplateId
    ,raft.[Name] as FeeCategory
    ,aft.[Name] as FeeType
    ,rafct.[Name] as FeeChargingType
    ,fmt.[FeePercentage]
    ,fmt.[FeeAmount] as NetDefaultAmount
    ,rfrf.[PeriodName] as Frequency
    ,fmt.[InitialPeriod]  
    ,fmt.[IsVATExcempt]      
    FROM            [policymanagement].[dbo].[TFeeModelTemplate] fmt
    LEFT OUTER JOIN [policymanagement].[dbo].[TFeeModel] fm ON fmt.FeeModelId = fm.FeeModelId
    LEFT OUTER JOIN [crm].[dbo].[TAdviseCategoryToFeeModel] ac2fm ON fm.FeeModelId = ac2fm.FeeModelId
    LEFT OUTER JOIN [policymanagement].[dbo].[TAdviseCategory] acat ON ac2fm.AdviseCategoryId = acat.AdviseCategoryId
    LEFT OUTER JOIN [crm].[dbo].[TAdviceCase] acas ON acas.AdviseCategoryId = acat.AdviseCategoryId
    LEFT OUTER JOIN [policymanagement].[dbo].[TAdviseFeeType] aft	ON fmt.AdviseFeeTypeId = aft.AdviseFeeTypeId
    LEFT OUTER JOIN [policymanagement].[dbo].[TAdviseFeeChargingDetails] afcd ON fmt.AdviseFeeChargingDetailsId = afcd.AdviseFeeChargingDetailsId
    LEFT OUTER JOIN [policymanagement].[dbo].[TAdviseFeeChargingType] afct ON afcd.AdviseFeeChargingTypeId = afct.AdviseFeeChargingTypeId
    INNER JOIN      [policymanagement].[dbo].[TRefAdviseFeeChargingType] rafct ON afct.RefAdviseFeeChargingTypeId = rafct.RefAdviseFeeChargingTypeId
    LEFT OUTER JOIN [policymanagement].[dbo].[TRefAdviseFeeType] raft ON aft.RefAdviseFeeTypeId = raft.RefAdviseFeeTypeId
    LEFT OUTER JOIN [policymanagement].[dbo].[TRefFeeRetainerFrequency] rfrf ON rfrf.RefFeeRetainerFrequencyId = (
		CASE WHEN fmt.InstalmentsFrequencyId IS NULL THEN fmt.RecurringFrequencyId ELSE fmt.InstalmentsFrequencyId END
	)
    WHERE
     acas.AdviceCaseId in (SELECT DISTINCT Value AS Id FROM policymanagement.dbo.FnSplit(@AdviceCaseIds, ','))

END
GO