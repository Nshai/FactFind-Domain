SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomCreateProtectionPlans] 
@CRMContactId bigint,
@CRMContactId2 bigint = null,
@PlanType varchar(255),
@Provider varchar(255),
@MaturityDate datetime = null,
@RegularContribution money=null,
@LifeAssured varchar(255)=null,
@PhiDeferredPeriod int = null,
@BenefitAmount money=null,
@CriticalIllnessAmount money=null,
@PhiBenefitPeriod int = null,
@AssignedInTrust bit=null,
@Owner varchar(255),
@Frequency varchar(50),
@SellingAdviser bigint,
@PolicyNumber varchar(50)=null,
@StampUser varchar(255)

AS

BEGIN


--1. Get the indigoClientId, use the CRMContactId to get it
	DECLARE @IndigoClientId bigint, @PolicyBusinessId bigint
	
	SET @IndigoClientId = (
		SELECT IndClientId FROM CRM..TCRMContact WHERE CRMContactId = @CRMContactId
	)

--AJF - no longer passing in CRMContactId2.
	SET @CRMContactId2 = (Select CRMContactId2 FROM TFactFind WHERE CRMContactId1 = @CRMContactId)

-- create the basic plan data, this will return a PolicyBusinessId
exec SpNCustomCreatePlan @CRMContactId, @CRMContactId2, @PlanType, @Provider, @Owner, @RegularContribution, @Frequency, @MaturityDate, @IndigoClientId, null, @StampUser, null, @SellingAdviser,@PolicyNumber, @PolicyBusinessId OUTPUT


-- Create a TProtection record
	DECLARE @ProtectionId bigint

	INSERT INTO PolicyManagement..TProtection (PolicyBusinessId, IndigoClientId, ConcurrencyId) 
	VALUES (@PolicyBusinessId, @IndigoClientId, 1)

	SET @ProtectionId = SCOPE_IDENTITY()

	INSERT INTO PolicyManagement..TProtectionAudit (PolicyBusinessId, IndigoClientId, ConcurrencyId, ProtectionId, StampAction, StampDateTime, StampUser) 
	VALUES (@PolicyBusinessId, @IndigoClientId, 1, @ProtectionId, 'C', getdate(), @StampUser)
	

-- Add benefits


	IF @PlanType = 'Term Protection (Family Income Benefit)'
		exec SpNCustomAddFamilyBenefit @CRMContactId, @CRMContactId2, @PolicyBusinessId, @LifeAssured, @BenefitAmount, @MaturityDate, @StampUser

	IF @PlanType IN ('Permanent Health Insurance','Accident Sickness & Unemployment Insurance', 'Group PHI')
		exec SpNCustomAddPhi @CRMContactId, @CRMContactId2, @PolicyBusinessId, @LifeAssured, @PhiDeferredPeriod, @BenefitAmount, @PhiBenefitPeriod, @StampUser
			
	IF @PlanType IN ('Term Protection', 'Term Protection (Convertible)', 'Term Protection (Decreasing Term)', 'Term Protection (Level)', 'Term Protection (Mortgage Protection)', 'Term Protection (Renewable)', 'Term Protection (Key Person Assurance)', 'Term Protection (Directors Share Protection)', 'Term Protection (Partnership Protection)', 'Whole Of Life', 'Endowment')
		exec SpNCustomAddLifeCover @CRMContactId, @CRMContactId2, @PolicyBusinessId, @PlanType, @LifeAssured, @BenefitAmount, @StampUser

	IF @AssignedInTrust is not null
		exec SpNCustomAddInTrust @CRMContactId, @CRMContactId2, @PolicyBusinessId, @LifeAssured, @AssignedInTrust, @StampUser

	IF @CriticalIllnessAmount is not null
		exec SpNCustomAddCriticalIllness @CRMContactId, @CRMContactId2, @PolicyBusinessId, @LifeAssured, @CriticalIllnessAmount, @StampUser


SELECT @PolicyBusinessId as ProtectionPlansId
END
GO
