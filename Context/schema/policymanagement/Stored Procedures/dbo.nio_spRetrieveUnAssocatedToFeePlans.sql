SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[nio_spRetrieveUnAssocatedToFeePlans]
(
@TenantId as BIGINT,
@FeeId AS BIGINT,
@PartyId as BIGINT,
@AdviceCaseId as BIGINT
)
AS

-- declare temp table to store PolicyBusinessId's already linked to the fee
DECLARE @Fee2Policy TABLE (PolicyBusinessId BIGINT)

-- from TFee2Policy find all the policybusinessId's linked to the given fee
INSERT INTO @Fee2Policy 
SELECT FP.PolicyBusinessId 
FROM TFee2Policy FP 
WHERE FeeId=@FeeId

-- declare temp table to store policybusiness related data
DECLARE @PolicyBusiness TABLE (PolicyDetailId BIGINT,PolicyBusinessId BIGINT,PolicyNumber varchar(50),SequentialRef varchar(50),AdviceTypeId BIGINT)

-- insert into temp table all the records from TPolicyBusiness belonging to the given AdviceCaseId and IndigoClientId 
INSERT INTO @PolicyBusiness
	SELECT PB.PolicyDetailId,
	PB.PolicyBusinessId,
	PB.PolicyNumber,
	PB.SequentialRef,
	PB.AdviceTypeId
FROM   PolicyManagement.dbo.TPolicyBusiness PB
INNER JOIN CRM.dbo.TAdviceCasePlan ACPL
         ON PB.PolicyBusinessId = ACPL.PolicyBusinessId
WHERE  PB.IndigoClientId = @TenantId
AND ACPL.AdviceCaseId=@AdviceCaseId

-- delete the policybusiness records from temp table, that are already linked to the given fee
DELETE FROM @PolicyBusiness 
FROM @PolicyBusiness PB
	INNER JOIN @Fee2Policy FP 
ON PB.PolicyBusinessId=FP.PolicyBusinessId


SELECT 
PB.PolicyBusinessId AS PolicyBusinessId,
PB.PolicyNumber AS PolicyNumber, 
PB.SequentialRef AS SequentialRef,
CRMP.CorporateName AS ProviderName, 
RPT.PlanTypeName AS PlanTypeName,
AT.IntelligentOfficeAdviceType AS IntelligentOfficeAdviceType,
STAT.Name AS CurrentStatus
FROM @PolicyBusiness PB
INNER JOIN PolicyManagement.dbo.[TPolicyDetail] PD
         ON PB.PolicyDetailId = PD.PolicyDetailId
INNER JOIN PolicyManagement.dbo.TPlanDescription PDesc
	    ON PD.PlanDescriptionId = PDesc.PlanDescriptionId
INNER JOIN PolicyManagement.dbo.TRefPlanType2ProdSubType RPTP
        ON PDesc.RefPlanType2ProdSubTypeId = RPTP.RefPlanType2ProdSubTypeId	 
INNER JOIN PolicyManagement.dbo.TRefPlanType RPT
        ON RPTP.RefPlanTypeId = RPT.RefPlanTypeId
INNER JOIN PolicyManagement.dbo.[TAdviceType] AT
        ON PB.AdviceTypeId = AT.AdviceTypeId
INNER JOIN PolicyManagement.dbo.TStatusHistory SH
		ON SH.PolicyBusinessId=PB.PolicyBusinessId AND SH.CurrentStatusFG=1
INNER JOIN PolicyManagement.dbo.[TStatus] STAT
        ON SH.StatusId = STAT.StatusId		
INNER JOIN PolicyManagement.dbo.TPolicyOwner POW
        ON PB.PolicyDetailId = POW.PolicyDetailId		
LEFT OUTER JOIN PolicyManagement.dbo.TRefProdProvider RPP
        ON PDesc.RefProdProviderId = RPP.RefProdProviderId
INNER JOIN CRM..TCRMContact CRMP
	    ON RPP.CRMCONTACTID = CRMP.CRMCONTACTID                  
WHERE  
POW.CRMContactId=@PartyId
AND STAT.IntelligentOfficeStatusType !='Deleted'

GO
