SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
  
CREATE PROCEDURE [dbo].[SpNCreateSplitTemplatesForPlans]   
(  
  @IndigoClientId int,                                  
  @CRMContactId int,                                  
  @PolicyBusinessId int,
  @SellingAdviserId int,
  @SplitTemplateGroupId int = null, 
  @TemplateGroupType varchar(255) = null  
)  
AS  
BEGIN  
  
DECLARE @ServicingAdviserId bigint = null

SELECT @ServicingAdviserId = p.PractitionerId
FROM   CRM..TCRMContact TC
	   INNER JOIN CRM..TPractitioner P
		ON TC.CurrentAdviserCRMId = p.CRMContactId
WHERE TC.CRMContactId = @CRMContactId
		AND TC.IndClientId = @IndigoClientId

DECLARE @SplitTemplates TABLE
(
	SplitTemplateId bigint null
)

IF (@TemplateGroupType IS NOT NULL)
BEGIN
	IF(@TemplateGroupType = 'Servicing')
	BEGIN
		INSERT INTO @SplitTemplates(SplitTemplateId)
		SELECT ST.SplitTemplateId
		FROM   commissions..TSplitTemplate ST
			   INNER JOIN commissions..TSplitTemplateGroup STG
				ON ST.SplitTemplateGroupId = STG.SplitTemplateGroupId
		WHERE  ST.ClientCRMContactId IS NULL
				AND STG.PractitionerId = @ServicingAdviserId
				 AND STG.SplitTemplateGroupId = @SplitTemplateGroupId
					AND ST.IndClientId = @IndigoClientId
	END
	ELSE IF(@TemplateGroupType = 'Selling')
	BEGIN
		INSERT INTO @SplitTemplates(SplitTemplateId)
		SELECT ST.SplitTemplateId
		FROM   commissions..TSplitTemplate ST
			   INNER JOIN commissions..TSplitTemplateGroup STG
				ON ST.SplitTemplateGroupId = STG.SplitTemplateGroupId
		WHERE  ST.ClientCRMContactId IS NULL
				AND STG.PractitionerId = @SellingAdviserId
				  AND STG.SplitTemplateGroupId = @SplitTemplateGroupId
					AND ST.IndClientId = @IndigoClientId
	END
	ELSE
	BEGIN
		INSERT INTO @SplitTemplates(SplitTemplateId)
		SELECT ST.SplitTemplateId
		FROM   commissions..TSplitTemplate ST			   
		WHERE  ST.ClientCRMContactId IS NOT NULL
				AND ST.ClientCRMContactId = @CRMContactId
				 AND ST.SplitTemplateGroupId = @SplitTemplateGroupId
					AND ST.IndClientId = @IndigoClientId
	END
END

INSERT INTO commissions..TSplit 
			(PractitionerId,
			PolicyId,
			[Description],
			PrivateFG,
			PartnershipType,
			InitialFG,
			RenewalsFG,
			PaymentEntityId,
			PaymentEntityCRMId,
			SplitPercent,
			FCITransferFG,
			SplitTemplateGroupId,
			IndClientId)
OUTPUT  INSERTED.SplitTemplateGroupId
			  , INSERTED.IndClientId
			  , INSERTED.PractitionerId
			  , INSERTED.PolicyId
			  , INSERTED.FeeId
			  , INSERTED.RetainerId
			  , INSERTED.PaymentEntityId
			  , INSERTED.PaymentEntityCRMId
			  , INSERTED.SplitPercent
			  , INSERTED.PartnershipType
			  , INSERTED.RenewalsFG
			  , INSERTED.InitialFG
			  , INSERTED.FCITransferFG
			  , INSERTED.[Description]
			  , INSERTED.PrivateFG
			  , INSERTED.ConcurrencyId
			  , INSERTED.SplitId
			  , 'C'
			  , GetDate()
			  , 0
			  , INSERTED.PractitionerId
INTO  commissions..TSplitAudit 
			  (SplitTemplateGroupId, 
			  IndClientId, 
			  PractitionerId, 
			  PolicyId, 
			  FeeId,
			  RetainerId,
			  PaymentEntityId,
			  PaymentEntityCRMId,
			  SplitPercent,
			  PartnershipType,
			  RenewalsFG,
			  InitialFG,
			  FCITransferFG,
			  [Description],
			  PrivateFG,
			  ConcurrencyId,
			  SplitId,
			  StampAction, 
			  StampDateTime, 
			  StampUser, 
			  MigrationRef)	
SELECT @SellingAdviserId,
	   @PolicyBusinessId,
	   TST.Description,
	   TST.PrivateFG,
	   TST.PartnershipType,
	   TST.InitialFG,
	   TST.RenewalsFG,
	   TST.PaymentEntityId,
	   TST.PaymentEntityCRMId,
	   TST.SplitPercent,
	   TST.FCITransferFG,
	   TST.SplitTemplateGroupId,
	   @IndigoClientId
FROM   commissions..TSplitTemplate TST
	   INNER JOIN @SplitTemplates ST
		ON TST.SplitTemplateId = ST.SplitTemplateId
WHERE  TST.IndClientId = @IndigoClientId

END  
GO
