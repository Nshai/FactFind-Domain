SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

  
CREATE VIEW [dbo].[VAdviceCaseUnAssociatedFees]  
AS  
SELECT      
 ACF.AdviceCaseFeeId,   
 ACF.AdviceCaseId,   
 T1.FeeId,  
 T2.CRMContactId AS PartyId,  
 PolicyManagement.dbo.FnCustomFFRetrieveFeeOwners(T1.FeeId) AS OwnerName,
 T1.SequentialRef,        
 T1.NetAmount AS [FeeNetAmount],        
 T1.VATAmount AS [FeeVATAmount],       
 T1.InvoiceDate,  
 ISNULL(T1.Description,'') AS FeeDescription,   
 ISNULL(T2.BandingTemplateId,0) AS [BandingTemplateId],  
 T3.FeeTypeName AS FeeType,  
 FeeModel.Name as FeeModelName,  
  --check if the Fe charging type is Fixed Price/Fixed price-Range/Non-chargeable/Waived
  --/Billing rate Task & time based the % is returned as 0.  
  --For these there is no % available so it should not be displayed. Hence use of CASE...WHEN...THEN statement  
  CASE WHEN (RefAdviseFeeChargingType.Name = 'Fixed Price' 
		OR RefAdviseFeeChargingType.Name = 'Non-chargeable'         
			OR RefAdviseFeeChargingType.Name = 'Fixed price-Range'
				-- IOD-181
				OR RefAdviseFeeChargingType.Name = 'Billing rate fee - Time Based' 
					
						OR RefAdviseFeeChargingType.Name = 'Billing rate fee - Task Based')   
  THEN '' 
  -- for '% FUM/AUM' & '% Investment Contribution' Fee Charging type.
  -- when FeePercentage has value in TFee table, then fetch Fee % from TFee table
  -- else fetch Fee % from TFeeChargingDetails table
  ELSE CASE WHEN T1.FeePercentage IS NULL THEN CAST(FeeChargingDetails.PercentageOfFee as varchar) 
	ELSE CAST(T1.FeePercentage as varchar) END
  END As PercentageOfFee,
  AdviseFeeType.Name as AdviseFeeType,        
    RefAdviseFeeChargingType.Name  as AdviseChargingType,
    RefAdvisePaidBy.Name as RefAdvisePaidByName,
     CASE   
  WHEN (AdviseFeeType.Name != NULL OR AdviseFeeType.Name != '')  
    THEN   
  CASE   
  WHEN (AdviseFeeType.IsRecurring = 1)   
   THEN  FeeRetFequency.PeriodName       
  WHEN (T1.IsRecurring = 1)   
   THEN FeeRetFequency.PeriodName   
  ELSE '' END   
    ELSE  
  ''    
 END  AS FrequencyName   
       
FROM PolicyManagement..TFee T1       
JOIN PolicyManagement..TFeeRetainerOwner T2   WITH(NOLOCK)  ON T1.FeeId=T2.FeeId  
JOIN PolicyManagement..TRefFeeType T3 WITH(NOLOCK) ON T1.RefFeeTypeId=T3.RefFeeTypeId  
LEFT JOIN CRM..TAdviceCaseFee ACF ON T1.FeeId=ACF.FeeId  
--RDRCHARGINGII-242: Join added for fetching fee model name  
LEFT JOIN PolicyManagement.dbo.TFeeModelTemplate ON TFeeModelTemplate.FeeModelTemplateId = T1.FeeModelTemplateId  
LEFT JOIN PolicyManagement.dbo.TFeeModel FeeModel ON FeeModel.FeeModelId = TFeeModelTemplate.FeeModelId  

LEFT JOIN PolicyManagement.dbo.TAdviseFeeType AdviseFeeType ON AdviseFeeType.AdviseFeeTypeId = T1.AdviseFeeTypeId
--RDRCHARGINGII-684: Add join to fetch the fee percentage         
LEFT JOIN PolicyManagement.dbo.TAdviseFeeChargingDetails FeeChargingDetails ON FeeChargingDetails.AdviseFeeChargingDetailsId = T1.AdviseFeeChargingDetailsId  
--Join to fetch the Ref fee charging type name  
LEFT JOIN PolicyManagement.dbo.TAdviseFeeChargingType FeeChargingType ON FeeChargingType.AdviseFeeChargingTypeId = FeeChargingDetails.AdviseFeeChargingTypeId  
LEFT JOIN PolicyManagement.dbo.TRefAdviseFeeChargingType RefAdviseFeeChargingType ON RefAdviseFeeChargingType.RefAdviseFeeChargingTypeId = FeeChargingType.RefAdviseFeeChargingTypeId  
  
 --Join to fetch Ref Paid By Name
 LEFT JOIN PolicyManagement.dbo.TAdvisePaymentType AdvisePaymentType ON AdvisePaymentType.AdvisePaymentTypeId = T1.AdvisePaymentTypeId
 LEFT JOIN PolicyManagement.dbo.TRefAdvisePaidBy RefAdvisePaidBy ON RefAdvisePaidBy.RefAdvisePaidById = AdvisePaymentType.RefAdvisePaidById            
  LEFT JOIN PolicyManagement.dbo.TRefFeeRetainerFrequency FeeRetFequency ON FeeRetFequency.RefFeeRetainerFrequencyId = T1.RefFeeRetainerFrequencyId                 



GO
