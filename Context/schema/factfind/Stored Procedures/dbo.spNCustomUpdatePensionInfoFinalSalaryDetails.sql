SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[spNCustomUpdatePensionInfoFinalSalaryDetails]

@StampUser varchar(255),
@PolicyBusinessId bigint,
@PensionableSalary money = null,
@ExpectedYearsOfService tinyint = null,
@AccrualRate int = null

as

declare @PensionInfoId bigint


select	@PensionInfoId = PensionInfoId from PolicyManagement..TPensionInfo where Policybusinessid = @PolicyBusinessId

if @PensionInfoId > 0 begin

	insert into PolicyManagement..TPensionInfoAudit
	(PolicyBusinessId,
	SRA,
	PensionableSalary,
	RefReturnDeathTypeId,
	ReturnOnDeathRate,
	ProtectedRightsOnly,
	QualifiesDSSIncentive,
	RefLifeCoverId,
	RebatePaid,
	ContributionUpdated,
	IsCurrent,
	RefSchemeSetUpId,
	HasWidowsPension,
	HasProtectionAgainstInflation,
	ProvidesTaxFreeLumpSum,
	ContractedOutOfS2P,
	ExpectedYearsOfService,
	NumberOfYearsCompleted,
	IsIndexed,
	RefSchemeBasisId,
	FinalSalary,
	RefContributionPercentageId,
	SpousePensionPayableOnDeath,
	ServiceBenefitSpouseEntitled,
	BenefitsPayableOnDeath,
	DeathBenefit,
	IsInTrust,
	IsNRADeffered,
	ConcurrencyId,
	AccrualRate,
	PensionInfoId,
	StampAction,
	StampDateTime,
	StampUser)
	select PolicyBusinessId,
	SRA,
	PensionableSalary,
	RefReturnDeathTypeId,
	ReturnOnDeathRate,
	ProtectedRightsOnly,
	QualifiesDSSIncentive,
	RefLifeCoverId,
	RebatePaid,
	ContributionUpdated,
	IsCurrent,
	RefSchemeSetUpId,
	HasWidowsPension,
	HasProtectionAgainstInflation,
	ProvidesTaxFreeLumpSum,
	ContractedOutOfS2P,
	ExpectedYearsOfService,
	NumberOfYearsCompleted,
	IsIndexed,
	RefSchemeBasisId,
	FinalSalary,
	RefContributionPercentageId,
	SpousePensionPayableOnDeath,
	ServiceBenefitSpouseEntitled,
	BenefitsPayableOnDeath,
	DeathBenefit,
	IsInTrust,
	IsNRADeffered,
	ConcurrencyId,
	AccrualRate,
	PensionInfoId,
	'U',
	getdate(),
	@stampuser
	from PolicyManagement..TPensionInfo p
	where	p.pensioninfoid = @pensioninfoid

	update	p
	set		PensionableSalary = @PensionableSalary,
			ExpectedYearsOfService = @ExpectedYearsOfService,
			AccrualRate = @AccrualRate,
			ConcurrencyId = ConcurrencyId+1
	from	PolicyManagement..TPensionInfo p 
	where	p.pensioninfoid = @pensioninfoid

end
else begin

	insert into PolicyManagement..TPensionInfo(PolicyBusinessId,PensionableSalary,ExpectedYearsOfService,AccrualRate,ConcurrencyId)
	select	@PolicyBusinessId, @PensionableSalary,@ExpectedYearsOfService,@AccrualRate,1

	select @pensioninfoid = SCOPE_IDENTITY()

	insert into PolicyManagement..TPensionInfoAudit
	(PolicyBusinessId,
	SRA,
	PensionableSalary,
	RefReturnDeathTypeId,
	ReturnOnDeathRate,
	ProtectedRightsOnly,
	QualifiesDSSIncentive,
	RefLifeCoverId,
	RebatePaid,
	ContributionUpdated,
	IsCurrent,
	RefSchemeSetUpId,
	HasWidowsPension,
	HasProtectionAgainstInflation,
	ProvidesTaxFreeLumpSum,
	ContractedOutOfS2P,
	ExpectedYearsOfService,
	NumberOfYearsCompleted,
	IsIndexed,
	RefSchemeBasisId,
	FinalSalary,
	RefContributionPercentageId,
	SpousePensionPayableOnDeath,
	ServiceBenefitSpouseEntitled,
	BenefitsPayableOnDeath,
	DeathBenefit,
	IsInTrust,
	IsNRADeffered,
	ConcurrencyId,
	AccrualRate,
	PensionInfoId,
	StampAction,
	StampDateTime,
	StampUser)
	select PolicyBusinessId,
	SRA,
	PensionableSalary,
	RefReturnDeathTypeId,
	ReturnOnDeathRate,
	ProtectedRightsOnly,
	QualifiesDSSIncentive,
	RefLifeCoverId,
	RebatePaid,
	ContributionUpdated,
	IsCurrent,
	RefSchemeSetUpId,
	HasWidowsPension,
	HasProtectionAgainstInflation,
	ProvidesTaxFreeLumpSum,
	ContractedOutOfS2P,
	ExpectedYearsOfService,
	NumberOfYearsCompleted,
	IsIndexed,
	RefSchemeBasisId,
	FinalSalary,
	RefContributionPercentageId,
	SpousePensionPayableOnDeath,
	ServiceBenefitSpouseEntitled,
	BenefitsPayableOnDeath,
	DeathBenefit,
	IsInTrust,
	IsNRADeffered,
	ConcurrencyId,
	AccrualRate,
	PensionInfoId,
	'C',
	getdate(),
	@stampuser
	from PolicyManagement..TPensionInfo p
	where	p.pensioninfoid = @pensioninfoid

end
GO
