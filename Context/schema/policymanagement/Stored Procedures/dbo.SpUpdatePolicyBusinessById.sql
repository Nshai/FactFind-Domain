SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpUpdatePolicyBusinessById]
@KeyPolicyBusinessId bigint,
@StampUser varchar (255),
@PolicyDetailId bigint,
@PolicyNumber varchar (50) = NULL,
@PractitionerId bigint,
@ReplaceNotes varchar (8000) = NULL,
@TnCCoachId bigint = NULL,
@AdviceTypeId bigint,
@BestAdvicePanelUsedFG bit = 0,
@WaiverDefermentPeriod int = 0,
@IndigoClientId bigint,
@SwitchFG tinyint = 0,
@TotalRegularPremium money = NULL,
@TotalLumpSum money = NULL,
@MaturityDate datetime = NULL,
@LifeCycleId bigint = NULL,
@PolicyStartDate datetime = NULL,
@PremiumType varchar (50) = NULL,
@AgencyNumber varchar (50) = NULL,
@ProviderAddress varchar (1000) = NULL,
@OffPanelFg bit = 0,
@BaseCurrency varchar (50) = 'GBP',
@ExpectedPaymentDate datetime = NULL,
@ProductName varchar (50) = NULL,
@InvestmentTypeId bigint = NULL,
@RiskRating int = NULL,
@SequentialRef varchar (50) = NULL
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  INSERT INTO TPolicyBusinessAudit (
    PolicyDetailId, 
    PolicyNumber, 
    PractitionerId, 
    ReplaceNotes, 
    TnCCoachId, 
    AdviceTypeId, 
    BestAdvicePanelUsedFG, 
    WaiverDefermentPeriod, 
    IndigoClientId, 
    SwitchFG, 
    TotalRegularPremium, 
    TotalLumpSum, 
    MaturityDate, 
    LifeCycleId, 
    PolicyStartDate, 
    PremiumType, 
    AgencyNumber, 
    ProviderAddress, 
    OffPanelFg, 
    BaseCurrency, 
    ExpectedPaymentDate, 
    ProductName, 
    InvestmentTypeId, 
    RiskRating, 
    ConcurrencyId,
    PolicyBusinessId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.PolicyDetailId, 
    T1.PolicyNumber, 
    T1.PractitionerId, 
    T1.ReplaceNotes, 
    T1.TnCCoachId, 
    T1.AdviceTypeId, 
    T1.BestAdvicePanelUsedFG, 
    T1.WaiverDefermentPeriod, 
    T1.IndigoClientId, 
    T1.SwitchFG, 
    T1.TotalRegularPremium, 
    T1.TotalLumpSum, 
    T1.MaturityDate, 
    T1.LifeCycleId, 
    T1.PolicyStartDate, 
    T1.PremiumType, 
    T1.AgencyNumber, 
    T1.ProviderAddress, 
    T1.OffPanelFg, 
    T1.BaseCurrency, 
    T1.ExpectedPaymentDate, 
    T1.ProductName, 
    T1.InvestmentTypeId, 
    T1.RiskRating, 
    T1.ConcurrencyId,
    T1.PolicyBusinessId,
    'U',
    GetDate(),
    @StampUser

  FROM TPolicyBusiness T1

  WHERE (T1.PolicyBusinessId = @KeyPolicyBusinessId)
  UPDATE T1
  SET 
    T1.PolicyDetailId = @PolicyDetailId,
    T1.PolicyNumber = @PolicyNumber,
    T1.PractitionerId = @PractitionerId,
    T1.ReplaceNotes = @ReplaceNotes,
    T1.TnCCoachId = @TnCCoachId,
    T1.AdviceTypeId = @AdviceTypeId,
    T1.BestAdvicePanelUsedFG = @BestAdvicePanelUsedFG,
    T1.WaiverDefermentPeriod = @WaiverDefermentPeriod,
    T1.IndigoClientId = @IndigoClientId,
    T1.SwitchFG = @SwitchFG,
    T1.TotalRegularPremium = @TotalRegularPremium,
    T1.TotalLumpSum = @TotalLumpSum,
    T1.MaturityDate = @MaturityDate,
    T1.LifeCycleId = @LifeCycleId,
    T1.PolicyStartDate = @PolicyStartDate,
    T1.PremiumType = @PremiumType,
    T1.AgencyNumber = @AgencyNumber,
    T1.ProviderAddress = @ProviderAddress,
    T1.OffPanelFg = @OffPanelFg,
    T1.BaseCurrency = @BaseCurrency,
    T1.ExpectedPaymentDate = @ExpectedPaymentDate,
    T1.ProductName = @ProductName,
    T1.InvestmentTypeId = @InvestmentTypeId,
    T1.RiskRating = @RiskRating,
    T1.ConcurrencyId = T1.ConcurrencyId + 1
  FROM TPolicyBusiness T1

  WHERE (T1.PolicyBusinessId = @KeyPolicyBusinessId)

SELECT * FROM TPolicyBusiness [PolicyBusiness]
  WHERE ([PolicyBusiness].PolicyBusinessId = @KeyPolicyBusinessId)
 FOR XML AUTO

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
