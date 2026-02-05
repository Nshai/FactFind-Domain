SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[SpNRetrievePensionInfoByPolicyBusinessId] @PolicyBusinessId bigint

as

select	
PensionInfoId,
PolicyBusinessId,
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
AccrualRate,
FinalSalary,
RefContributionPercentageId,
SpousePensionPayableOnDeath,
ServiceBenefitSpouseEntitled,
BenefitsPayableOnDeath,
DeathBenefit,
IsInTrust,
IsNRADeffered,
ConcurrencyId,
HistoricalCrystallisedPercentage,
CurrentCrystallisedPercentage,
CrystallisedPercentage,
UncrystallisedPercentage

from	PolicyManagement..TPensionInfo 
where	PolicyBusinessId = @PolicyBusinessId
GO
