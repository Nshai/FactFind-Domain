SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_SpCustomCreateWrapperProvider]
	(
		@RefPlanTypeId bigint,
		@RefProdProviderId bigint,
		@WrapAllowOtherProvidersFg bit,
		@SippAllowOtherProvidersFg bit,
		@SassAllowOtherProvidersFg bit,
		@OffshoreBondAllowOtherProvidersFg bit,
		@GroupSippAllowOtherProvidersFg bit,
		@FamilySippAllowOtherProvidersFg bit,
		@QropsAllowOtherProvidersFg bit,
		@StampUser varchar (255),
		@SuperAllowOtherProvidersFg bit,
		@QnupsAllowOtherProvidersFg bit,
		@JuniorSIPPAllowOtherProvidersFg bit,
		@WrapInvestmentAllowOtherProvidersFg bit = 0,
		@PersonalPensionAllowOtherProvidersFg bit = 0,
		@OpenAnnuityAllowOtherProvidersFg bit = 0,
		@IncomeDrawdownAllowOtherProvidersFg bit = 0,
		@PhasedRetirementAllowOtherProvidersFg bit = 0,
    @RopsAllowOtherProvidersFg bit = 0,
    @InvestmentBondAllowOtherProvidersFg bit = 0,
    @PensionAllowOtherProvidersFg bit = 0,
	@SuperWrapAllowOtherProvidersFg bit = 0,
	@SelfManagedSuperFundAllowOtherProvidersFg bit = 0
	)

AS

begin

declare @id bigint

insert into TWrapperProvider
(
  RefPlanTypeId,
  RefProdProviderId,
  WrapAllowOtherProvidersFg,
  SippAllowOtherProvidersFg,
  SsasAllowOtherProvidersFg,
  GroupSippAllowOtherProvidersFg,
  FamilySippAllowOtherProvidersFg,
  OffshoreBondAllowOtherProvidersFg,
  QropsAllowOtherProvidersFg,
  RopsAllowOtherProvidersFg,
  SuperAllowOtherProvidersFg,
  JuniorSIPPAllowOtherProvidersFg,
  QnupsAllowOtherProvidersFg,
  WrapInvestmentAllowOtherProvidersFg,
  PersonalPensionAllowOtherProvidersFg,
  OpenAnnuityAllowOtherProvidersFg,
  IncomeDrawdownAllowOtherProvidersFg,
  PhasedRetirementAllowOtherProvidersFg,
  InvestmentBondAllowOtherProvidersFg,
  PensionAllowOtherProvidersFg,
  SuperWrapAllowOtherProvidersFg,
  SelfManagedSuperFundAllowOtherProvidersFg,
  WrapperOnly,
  ConcurrencyId
)
select
@RefPlanTypeId,
@RefProdProviderId,
@WrapAllowOtherProvidersFg,
@SippAllowOtherProvidersFg,
@SassAllowOtherProvidersFg,
@GroupSippAllowOtherProvidersFg,
@FamilySippAllowOtherProvidersFg,
@OffshoreBondAllowOtherProvidersFg,
@QropsAllowOtherProvidersFg,
@RopsAllowOtherProvidersFg,
@SuperAllowOtherProvidersFg,
@JuniorSIPPAllowOtherProvidersFg,
@QnupsAllowOtherProvidersFg,
@WrapInvestmentAllowOtherProvidersFg,
@PersonalPensionAllowOtherProvidersFg,
@OpenAnnuityAllowOtherProvidersFg,
@IncomeDrawdownAllowOtherProvidersFg,
@PhasedRetirementAllowOtherProvidersFg,
@InvestmentBondAllowOtherProvidersFg,
@PensionAllowOtherProvidersFg,
@SuperWrapAllowOtherProvidersFg,
@SelfManagedSuperFundAllowOtherProvidersFg,
1,
1

select @id  = scope_identity()

insert into TWrapperProviderAudit
(
  RefPlanTypeId,
  RefProdProviderId,
  WrapAllowOtherProvidersFg,
  SippAllowOtherProvidersFg,
  SsasAllowOtherProvidersFg,
  GroupSippAllowOtherProvidersFg,
  FamilySippAllowOtherProvidersFg,
  OffshoreBondAllowOtherProvidersFg,
  QropsAllowOtherProvidersFg,
  RopsAllowOtherProvidersFg,
  SuperAllowOtherProvidersFg,
  JuniorSIPPAllowOtherProvidersFg,
  QnupsAllowOtherProvidersFg,
  WrapInvestmentAllowOtherProvidersFg,
  PersonalPensionAllowOtherProvidersFg,
  OpenAnnuityAllowOtherProvidersFg,
  IncomeDrawdownAllowOtherProvidersFg,
  PhasedRetirementAllowOtherProvidersFg,
  InvestmentBondAllowOtherProvidersFg,
  PensionAllowOtherProvidersFg,
  SuperWrapAllowOtherProvidersFg,
  SelfManagedSuperFundAllowOtherProvidersFg,
  WrapperOnly,
  ConcurrencyId,
  WrapperProviderId,
  StampAction,
  StampDateTime,
  StampUser  
)
select 
RefPlanTypeId,
RefProdProviderId,
WrapAllowOtherProvidersFg,
SippAllowOtherProvidersFg,
SsasAllowOtherProvidersFg,
GroupSippAllowOtherProvidersFg,
FamilySippAllowOtherProvidersFg,
OffshoreBondAllowOtherProvidersFg,
QropsAllowOtherProvidersFg,
RopsAllowOtherProvidersFg,
SuperAllowOtherProvidersFg,
JuniorSIPPAllowOtherProvidersFg,
QnupsAllowOtherProvidersFg,
WrapInvestmentAllowOtherProvidersFg,
PersonalPensionAllowOtherProvidersFg,
OpenAnnuityAllowOtherProvidersFg,
IncomeDrawdownAllowOtherProvidersFg,
PhasedRetirementAllowOtherProvidersFg,
InvestmentBondAllowOtherProvidersFg,
PensionAllowOtherProvidersFg,
SuperWrapAllowOtherProvidersFg,
SelfManagedSuperFundAllowOtherProvidersFg,
WrapperOnly,
ConcurrencyId,
WrapperProviderId,
'C',
getdate(),
@StampUser
from	TWrapperProvider
where	WrapperProviderId = @id

SELECT 1

end
GO
