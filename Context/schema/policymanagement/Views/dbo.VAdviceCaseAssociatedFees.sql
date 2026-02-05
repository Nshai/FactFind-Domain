SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

      
      
CREATE VIEW [dbo].[VAdviceCaseAssociatedFees]      
AS      
SELECT     T1.AdviceCaseFeeId,         
   T1.AdviceCaseId,         
   T2.FeeId,         
   T2.SequentialRef, 
	(select distinct  PolicyBusiness.SequentialRef + ', '
       FROM TPolicyBusiness PolicyBusiness 
       INNER JOIN TFee2Policy
       ON PolicyBusiness.PolicyBusinessId = TFee2Policy.PolicyBusinessId
       AND T2.FeeId = TFee2Policy.FeeId            
       for xml path('')) as
       FeeLinkedPlanRefNums,        
   T2.NetAmount AS FeeNetAmount,         
   T2.VATAmount AS FeeVATAmount,         
            ISNULL(T2.Description, '') AS FeeDescription,         
            T2.InvoiceDate AS InvoiceDate,         
            T2.SentToClientDate AS SentToClientDate,         
            T3.FeeTypeName AS FeeType,        
            FeeModel.Name as FeeModelName,                    
    --check if the Fe charging type is Fixed Price/Fixed price-Range/Non-chargeable the % is returned as 0.        
    --For these there is no % available so it should not be displayed. Hence use of CASE...WHEN...THEN statement        
    CASE WHEN (RefAdviseFeeChargingType.Name = 'Fixed Price' OR RefAdviseFeeChargingType.Name = 'Non-chargeable'         
    OR RefAdviseFeeChargingType.Name = 'Fixed price-Range'
    -- IOD-181
    OR RefAdviseFeeChargingType.Name = 'Billing rate fee - Time Based' 
  OR RefAdviseFeeChargingType.Name = 'Billing rate fee - Task Based')         
    THEN '' 
    -- for '% FUM/AUM' & '% Investment Contribution' Fee Charging type.
    -- when FeePercentage has value in TFee table, then fetch Fee % from TFee table
    -- else fetch Fee % from TFeeChargingDetails table
    ELSE CASE WHEN T2.FeePercentage IS NULL THEN CAST(FeeChargingDetails.PercentageOfFee as varchar) 
	  ELSE CAST(T2.FeePercentage as varchar) END
    END As PercentageOfFee,          
    AdviseFeeType.Name as AdviseFeeType,        
    RefAdviseFeeChargingType.Name  as AdviseChargingType, CASE WHEN T2.InitialPeriod > 0 THEN T2.InitialPeriod ELSE NULL END AS InitialPeriod,  
    T2.IsPaidByProvider,
    --RDRCHARGINGIII-81: RefAdvise Paid By Name for client or provider values
    RefAdvisePaidBy.Name as RefAdvisePaidByName,    
    (SELECT COUNT(F2P.Fee2PolicyId) FROM policymanagement..TFee2Policy F2P WHERE F2P.FeeId = T2.FeeId) RelatedPoliciesCount,  
    CASE   
  WHEN (AdviseFeeType.Name != NULL OR AdviseFeeType.Name != '')  
    THEN   
  CASE   
  WHEN (AdviseFeeType.IsRecurring = 1)   
   THEN  FeeRetFequency.PeriodName       
  WHEN (T2.IsRecurring = 1)   
   THEN FeeRetFequency.PeriodName   
  ELSE '' END   
    ELSE  
  ''    
 END  AS FrequencyName  
            
FROM         CRM.dbo.TAdviceCaseFee AS T1 INNER JOIN        
                      PolicyManagement.dbo.TFee AS T2 ON T1.FeeId = T2.FeeId INNER JOIN        
                      PolicyManagement.dbo.TRefFeeType AS T3 ON T2.RefFeeTypeId = T3.RefFeeTypeId        
                      --RDRCHARGINGII-242: Join added for fetching fee model name        
                      LEFT JOIN PolicyManagement.dbo.TFeeModelTemplate ON TFeeModelTemplate.FeeModelTemplateId = T2.FeeModelTemplateId        
       LEFT JOIN PolicyManagement.dbo.TFeeModel FeeModel ON FeeModel.FeeModelId = TFeeModelTemplate.FeeModelId         
               
       LEFT JOIN PolicyManagement.dbo.TAdviseFeeType AdviseFeeType ON AdviseFeeType.AdviseFeeTypeId = T2.AdviseFeeTypeId  
       --RDRCHARGINGII-1016: join added to fetch Frequency Name  
       LEFT JOIN PolicyManagement.dbo.TRefFeeRetainerFrequency FeeRetFequency ON FeeRetFequency.RefFeeRetainerFrequencyId = T2.RefFeeRetainerFrequencyId                 
               
       --RDRCHARGINGII-684: Add join to fetch the fee percentage               
       LEFT JOIN PolicyManagement.dbo.TAdviseFeeChargingDetails FeeChargingDetails ON FeeChargingDetails.AdviseFeeChargingDetailsId = T2.AdviseFeeChargingDetailsId        
       --Join to fetch the Ref fee charging type name        
       LEFT JOIN PolicyManagement.dbo.TAdviseFeeChargingType FeeChargingType ON FeeChargingType.AdviseFeeChargingTypeId = FeeChargingDetails.AdviseFeeChargingTypeId        
       LEFT JOIN PolicyManagement.dbo.TRefAdviseFeeChargingType RefAdviseFeeChargingType ON RefAdviseFeeChargingType.RefAdviseFeeChargingTypeId = FeeChargingType.RefAdviseFeeChargingTypeId
       --RDRCHARGINGIII-81: Join to fetch Ref Paid By Name
       LEFT JOIN PolicyManagement.dbo.TAdvisePaymentType AdvisePaymentType ON AdvisePaymentType.AdvisePaymentTypeId = T2.AdvisePaymentTypeId
       LEFT JOIN PolicyManagement.dbo.TRefAdvisePaidBy RefAdvisePaidBy ON RefAdvisePaidBy.RefAdvisePaidById = AdvisePaymentType.RefAdvisePaidById            
      
      
  
  






GO
