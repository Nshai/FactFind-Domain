SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[nio_spRetrieveUnAssociatedToPlansFee]  
(  
@IndigoClientId as BIGINT,  
@PolicyBusinessId AS BIGINT,  
@PartyId as BIGINT,  
@AdviceCaseId as BIGINT   
)  
AS  
  
  

--Declare temp table to store Fee    
DECLARE @TEMP_FEE TABLE(FeeId BIGINT,SequentialRef VARCHAR(50),NetAmount DECIMAL(18,2),InvoiceDate DATETIME, Status VARCHAR(50),    
AdviseFeeTypeId BIGINT,AdviseFeeChargingDetailsId BIGINT,FeeModelTemplateId BIGINT,IsPaidByProvider BIT )    
    
-- Insert into @Temp_Fee  all the records which belong to an Advice Case  
INSERT INTO @TEMP_FEE    
SELECT Fee.FeeId AS FeeId,  
 Fee.SequentialRef AS SequentialRef,  
 Fee.NetAmount AS NetAmount,  
 Fee.InvoiceDate AS InvoiceDate,  
 '' AS Status,   
 AdviseFeeTypeId,  
 AdviseFeeChargingDetailsId,  
 FeeModelTemplateId,
 ISNULL(RefAdvisePaidBy.IsPaidByProvider,0)
 FROM   PolicyManagement.dbo.TFee Fee    
 INNER JOIN CRM.dbo.TAdviceCaseFee ACF    
         ON Fee.FeeId = ACF.FeeId
 LEFT JOIN TAdvisePaymentType AdvisePaymentType ON AdvisePaymentType.AdvisePaymentTypeId = Fee.AdvisePaymentTypeId  
 LEFT JOIN TRefAdvisePaidBy RefAdvisePaidBy ON RefAdvisePaidBy.RefAdvisePaidById = AdvisePaymentType.RefAdvisePaidById    
 WHERE  Fee.IndigoClientId=@IndigoClientId    
 AND ACF.AdviceCaseId = @AdviceCaseId   
  
   
 --Delete from @TEMP_FEE table, all the fees which are already linked to the PolicyBusiness  
DELETE from @TEMP_FEE  
FROM @TEMP_FEE x   
INNER JOIN PolicyManagement..TFee2Policy y  
 ON x.FeeId=y.FeeId  
WHERE y.PolicyBusinessId=@PolicyBusinessId  
  
   
 -- Get the latest status of the Fees  
 ;WITH CTE_Latest_FeeStatus(FeeId, status,CountVersion) AS     
(    
  SELECT Fee.FeeId as FeeId,   
  FS.status as status,    
  ROW_NUMBER() OVER(PARTITION BY FS.FeeId ORDER BY FS.FeeStatusId desc )  as CountVersion  
  FROM PolicyManagement.dbo.TFeeStatus FS    
  INNER JOIN  @TEMP_FEE Fee    
  ON Fee.FeeId=FS.FeeId     
)     
UPDATE @TEMP_FEE SET Status= LFS.status  
FROM @TEMP_FEE TF  
INNER JOIN CTE_Latest_FeeStatus  LFS  
 ON LFS.FeeId=TF.FeeId  
-- Pick the latest fee status    
 WHERE CountVersion =1   
    
    
-- Identify the Fees which are Paid by Provider and Feetype in 'Fixed Price' or 'Fixed Price Range' and has status as draft 
-- And has already been linked to any policy
;WITH CTE_Fee_Temp(FeeId) as 
(
select Fee.FeeId 
FROM   @TEMP_FEE Fee     
left outer join policymanagement.dbo.TAdviseFeeChargingDetails AFCD
         on Fee.AdviseFeeChargingDetailsId = AFCD.AdviseFeeChargingDetailsId       
       left outer join PolicyManagement.dbo.TAdviseFeeChargingType AFCT
         on AFCD.AdviseFeeChargingTypeId = AFCT.AdviseFeeChargingTypeId
       left outer join PolicyManagement.dbo.TRefAdviseFeeChargingType RFAFCT
         on AFCT.RefAdviseFeeChargingTypeId = RFAFCT.RefAdviseFeeChargingTypeId
         inner join policymanagement..TFee2Policy F2P 
         On F2P.FeeId= Fee.FeeId
WHERE Fee.IsPaidByProvider = 1 
	AND Fee.Status = 'Draft'
	AND (RFAFCT.Name = 'Fixed Price' OR RFAFCT.Name = 'Fixed price-Range')
	GROUP BY Fee.FeeId HAVING COUNT(Fee.FeeId) >0
	)
	-- delete from @TEMP_FEE records, which are paid by provider and Feetype in 'Fixed Price' or 'Fixed Price Range' and has status as draft
	DELETE from @TEMP_FEE	
	FROM CTE_Fee_Temp x 
		INNER JOIN @TEMP_FEE y 
	ON x.FeeId= y.FeeId
    
    
SELECT Fee.FeeId                  as FeeId,    
       Fee.SequentialRef          as SequentialRef,           
       AFT.Name            as AdviseFeeType,    
       RAFCT.Name           as FeeChargingType,    
       Fee.NetAmount              as NetAmount,    
       Fee.InvoiceDate            as InvoiceDate,    
       Fee.Status     as FeeStatus,    
       FeeModel.Name             as FeeModelName,    
       AFCD.PercentageOfFee as PercentageOfFee    
    
FROM   @TEMP_FEE Fee    
INNER JOIN PolicyManagement.dbo.TFeeRetainerOwner FROwner    
         ON Fee.FeeId = FROwner.FeeId    
       INNER JOIN CRM.dbo.TCRMContact CRMContact    
          ON FROwner.CRMContactId = CRMContact.CRMContactId    
    LEFT OUTER JOIN policymanagement.dbo.TAdviseFeeType AFT    
          ON Fee.AdviseFeeTypeId = AFT.AdviseFeeTypeId    
       LEFT OUTER JOIN policymanagement.dbo.TAdviseFeeChargingDetails AFCD    
          ON Fee.AdviseFeeChargingDetailsId = AFCD.AdviseFeeChargingDetailsId    
       LEFT OUTER JOIN PolicyManagement.dbo.TAdviseFeeChargingType AFCT    
          ON AFCD.AdviseFeeChargingTypeId = AFCT.AdviseFeeChargingTypeId    
       LEFT OUTER JOIN PolicyManagement.dbo.TRefAdviseFeeChargingType RAFCT    
         ON AFCT.RefAdviseFeeChargingTypeId = RAFCT.RefAdviseFeeChargingTypeId    
       LEFT OUTER JOIN PolicyManagement.dbo.TFeeModelTemplate FMT    
         ON Fee.FeeModelTemplateId = FMT.FeeModelTemplateId    
       LEFT OUTER JOIN PolicyManagement.dbo.TFeeModel FeeModel    
         ON FMT.FeeModelId = FeeModel.FeeModelId             
WHERE      
CRMContact.CRMContactId = @PartyId /* @p1 */    
AND Fee.status='Draft'   
GO
