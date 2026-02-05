SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*************************************************************************************      
SP Name             : nio_spRetrieveUnAssocatedForPolicyBusinessId      
Reference           : IntelliFlo-PolicyBusinessRepository.cs      
Purpose             : Retrieve unlinked fees to relate to Plan       
LastModificationDesc: To return Fees with Fixed,FixedRange,Non chargeable,billingrate      
                      Fee charging type in any status* to be linked to plan         
***************************************************************************************/      
CREATE PROCEDURE [dbo].[nio_spRetrieveUnAssocatedForPolicyBusinessId] (      
 @IndigoClientId AS BIGINT      
 ,@PolicyBusinessId AS BIGINT      
 ,@PartyId AS BIGINT      
 )      
AS      
/*      
exec dbo.[nio_spRetrieveUnAssocatedForPolicyBusinessId] @PolicyBusinessId=37,@PartyId=4670731,@IndigoClientId=10155      
*/      
DECLARE @IsPaidByProvider AS BIGINT      
DECLARE @NoOfPolicyOwners AS TINYINT    
DECLARE @SecondaryOwnerId AS BIGINT    
DECLARE @PrimaryOwnerId AS BIGINT 
DECLARE @PrimaryCRMContactId AS BIGINT
DECLARE @SecondaryCRMContactId AS BIGINT 
      
SET @IsPaidByProvider = 2      
SELECT @NoOfPolicyOwners = Count(PolicyOwnerId),@SecondaryOwnerId = Max(PolicyOwnerId),@PrimaryOwnerId = Min(PolicyOwnerId) FROM PolicyManagement..TPolicyBusiness a    
JOIN PolicyManagement.dbo.TPolicyOwner c on a.PolicyDetailId = c.PolicyDetailId    
where a.PolicyBusinessId = @PolicyBusinessId    
     
      
--Declare temp table to store Fee        
DECLARE @TEMP_FEE TABLE (      
 FeeId BIGINT      
 ,SequentialRef VARCHAR(50)      
 ,NetAmount DECIMAL(18, 2)      
 ,InvoiceDate DATETIME      
 ,STATUS VARCHAR(50)      
 ,AdviseFeeTypeId BIGINT      
 ,AdviseFeeChargingDetailsId BIGINT      
 ,FeeModelTemplateId BIGINT      
 ,IsPaidByProvider BIT      
 ,AdvicePaymentTypeId BIGINT      
 ,FeePercentage DECIMAL(5, 2)      
 )      
      
-- Insert into @Temp_Fee  all the records which belong to a party and IndigoClientId      
SELECT @PrimaryCRMContactId = (SELECT crmcontactid 
                               FROM   policymanagement.dbo.tpolicyowner 
                               WHERE  policyownerid = @PrimaryOwnerId) 

SELECT @SecondaryCRMContactId = (SELECT crmcontactid 
                                 FROM   policymanagement.dbo.tpolicyowner 
                                 WHERE  policyownerid = @SecondaryOwnerId) 

INSERT INTO @TEMP_FEE 
SELECT
  Fee.feeid,
  Fee.sequentialref,
  Fee.netamount,
  Fee.invoicedate,
  '' AS STATUS,
  advisefeetypeid,
  advisefeechargingdetailsid,
  feemodeltemplateid,
  Fee.ispaidbyprovider,
  Fee.advisepaymenttypeid,
  Fee.feepercentage
FROM policymanagement.dbo.tfee Fee
INNER JOIN policymanagement.dbo.tfeeretainerowner FROwner
  ON Fee.feeid = FROwner.feeid
WHERE Fee.indigoclientid = @IndigoClientId
AND
(@NoOfPolicyOwners = 2
AND (
(FROwner.crmcontactid IN (@PrimaryCRMContactId, @SecondaryCRMContactId)AND FROwner.SecondaryOwnerId IS NULL)
OR (FROwner.CRMContactId IN (@PrimaryCRMContactId, @SecondaryCRMContactId)
AND FROwner.SecondaryOwnerId IN (@PrimaryCRMContactId, @SecondaryCRMContactId))
))
OR (@NoOfPolicyOwners = 1
AND (FROwner.crmcontactid = @PrimaryCRMContactId OR FROwner.SecondaryOwnerId = @PrimaryCRMContactId))



 
--Delete from @TEMP_FEE table, all the fees which are already linked to the PolicyBusiness      
DELETE      
FROM @TEMP_FEE      
FROM @TEMP_FEE x      
INNER JOIN PolicyManagement..TFee2Policy y ON x.FeeId = y.FeeId      
WHERE y.PolicyBusinessId = @PolicyBusinessId      
    
 -- Get the latest status of the Fees      
 ;      
      
WITH CTE_Latest_FeeStatus (      
 FeeId      
 ,STATUS      
 ,CountVersion      
 )      
AS (      
 SELECT Fee.FeeId      
  ,FeeStatus.STATUS      
  ,ROW_NUMBER() OVER (      
   PARTITION BY FeeStatus.FeeId ORDER BY FeeStatus.FeeStatusId DESC      
   )      
 FROM PolicyManagement.dbo.TFeeStatus FeeStatus      
 INNER JOIN @TEMP_FEE Fee ON Fee.FeeId = FeeStatus.FeeId      
 )      
       
UPDATE @TEMP_FEE      
SET STATUS = LFS.STATUS      
FROM @TEMP_FEE TF      
INNER JOIN CTE_Latest_FeeStatus LFS ON LFS.FeeId = TF.FeeId      
-- Pick the latest fee status        
WHERE CountVersion = 1    
      
      
-- Identify the Fees which are Paid by Provider and Feetype in 'Fixed Price' or 'Fixed Price Range' and has status as draft       
-- And has already been linked to any policy      
-- RDRIV-433 : % of Fee also added to this.
      

DECLARE @FixedPriceId BIGINT   
DECLARE @FixedPriceRangeId BIGINT
DECLARE @NonChargeableId BIGINT 
DECLARE @BillingRateTimeBasedId BIGINT 
DECLARE @BillingRateTaskBasedId BIGINT 

--Fixed Price fee charging type
SELECT @FixedPriceId = RefAdviseFeeChargingTypeId
FROM   PolicyManagement.dbo.TRefAdviseFeeChargingType WITH (nolock)
WHERE  Name = 'Fixed Price'

--Fixed Price Range fee charging type
SELECT @FixedPriceRangeId = RefAdviseFeeChargingTypeId
FROM   PolicyManagement.dbo.TRefAdviseFeeChargingType WITH (nolock)
WHERE  Name = 'Fixed price-Range'

--Non Chargeable fee charging type
SELECT @NonChargeableId = RefAdviseFeeChargingTypeId
FROM   PolicyManagement.dbo.TRefAdviseFeeChargingType WITH (nolock)
WHERE  Name = 'Non-chargeable'

--Billing Rate Time Based fee charging type
SELECT @BillingRateTimeBasedId = RefAdviseFeeChargingTypeId
FROM   PolicyManagement.dbo.TRefAdviseFeeChargingType WITH (nolock)
WHERE  Name = 'Billing rate fee - Time Based'

--Billing Rate Task Based fee charging type
SELECT @BillingRateTaskBasedId = RefAdviseFeeChargingTypeId
FROM   PolicyManagement.dbo.TRefAdviseFeeChargingType WITH (nolock)
WHERE  Name = 'Billing rate fee - Task Based';
      
      
WITH CTE_Fee (FeeId)      
AS (      
 SELECT Fee.FeeId      
 FROM @TEMP_FEE Fee      
 LEFT OUTER JOIN policymanagement.dbo.TAdviseFeeChargingDetails AFCD ON Fee.AdviseFeeChargingDetailsId = AFCD.AdviseFeeChargingDetailsId      
 LEFT OUTER JOIN PolicyManagement.dbo.TAdviseFeeChargingType AFCT ON AFCD.AdviseFeeChargingTypeId = AFCT.AdviseFeeChargingTypeId      
 LEFT OUTER JOIN PolicyManagement.dbo.TRefAdviseFeeChargingType RFAFCT ON AFCT.RefAdviseFeeChargingTypeId = RFAFCT.RefAdviseFeeChargingTypeId      
 LEFT OUTER JOIN policymanagement.dbo.TAdvisePaymentType APT ON APT.AdvisePaymentTypeId = FEE.AdvicePaymentTypeId      
 INNER JOIN policymanagement..TFee2Policy F2P ON F2P.FeeId = Fee.FeeId      
 WHERE APT.RefAdvisePaidById = @IsPaidByProvider      
  --AND Fee.STATUS = 'Draft'      
  AND (      
    RFAFCT.RefAdviseFeeChargingTypeId IN (	@FixedPriceId
											, @FixedPriceRangeId
										 )     
	  )      
 GROUP BY Fee.FeeId      
 HAVING COUNT(Fee.FeeId) > 0      
 )      
       
       
-- delete from @TEMP_FEE records, which are paid by provider and Feetype in 'Fixed Price' or 'Fixed Price Range' and has status as draft      
DELETE      
FROM @TEMP_FEE      
FROM CTE_Fee x      
INNER JOIN @TEMP_FEE y ON x.FeeId = y.FeeId      
     
--Fetch all fees if the status is draft and fetch fees of type Fixed price,Range,non chargeable irrespective of any status      
SELECT Fee.FeeId AS FeeId      
 ,Fee.SequentialRef AS SequentialRef      
 ,Fee.NetAmount AS NetAmount      
 ,Fee.InvoiceDate AS InvoiceDate      
 ,AFT.NAME AS FeeType      
 ,RAFC.NAME AS FeeChargingType      
 ,Fee.STATUS AS FeeStatus      
 ,FM.NAME AS FeeModelName        
    -- for all kind of Fee Charging type.      
    -- when FeePercentage has value in TFee table, then fetch Fee % from TFee table      
    -- else fetch Fee % from TFeeChargingDetails table      
    ,CASE WHEN Fee.FeePercentage IS NULL THEN CAST(AFCD.PercentageOfFee as varchar)       
   ELSE CAST(Fee.FeePercentage as varchar)      
    END As PercentageOfFee      
FROM @TEMP_FEE Fee      
LEFT OUTER JOIN policymanagement.dbo.TAdviseFeeType AFT ON Fee.AdviseFeeTypeId = AFT.AdviseFeeTypeId      
LEFT OUTER JOIN policymanagement.dbo.TAdviseFeeChargingDetails AFCD ON Fee.AdviseFeeChargingDetailsId = AFCD.AdviseFeeChargingDetailsId      
LEFT OUTER JOIN PolicyManagement.dbo.TAdviseFeeChargingType AFCT ON AFCD.AdviseFeeChargingTypeId = AFCT.AdviseFeeChargingTypeId      
LEFT OUTER JOIN PolicyManagement.dbo.TRefAdviseFeeChargingType RAFC ON AFCT.RefAdviseFeeChargingTypeId = RAFC.RefAdviseFeeChargingTypeId      
LEFT OUTER JOIN PolicyManagement.dbo.TFeeModelTemplate FMT ON Fee.FeeModelTemplateId = FMT.FeeModelTemplateId      
LEFT OUTER JOIN PolicyManagement.dbo.TFeeModel FM ON FMT.FeeModelId = FM.FeeModelId     
LEFT OUTER JOIN PolicyManagement.dbo.TRefAdviseFeeType RAFT ON AFT.RefAdviseFeeTypeId = RAFT.RefAdviseFeeTypeId
WHERE (Fee.STATUS = 'Draft')      
 OR (      
	   AFCT.RefAdviseFeeChargingTypeId IS NULL      
	   OR AFCT.RefAdviseFeeChargingTypeId IN ( SELECT RefAdviseFeeChargingTypeId      
											   FROM PolicyManagement.dbo.TRefAdviseFeeChargingType      
											   WHERE RefAdviseFeeChargingTypeId IN (@FixedPriceId
																					, @FixedPriceRangeId
																					, @NonChargeableId
																					, @BillingRateTimeBasedId     
																					, @BillingRateTaskBasedId
																					)      
											 )      
   ) 
  OR (  
	RAFT.Name = 'On-going Fee' AND (RAFC.Name IN ('% of FUM/AUM', '% of All Investment Contribution', '% of Regular Contribution', 
												  '% of Lump Sum Contribution','% of Transfer Contribution'))	
  )     
ORDER BY Fee.FeeId 
GO
