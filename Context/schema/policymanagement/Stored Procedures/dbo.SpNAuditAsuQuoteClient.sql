SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditAsuQuoteClient]
	@StampUser varchar (255),
	@QuoteClientId bigint,
	@StampAction char(1)
AS

INSERT INTO TAsuQuoteClientAudit
( 
	Age, DateAgeCalculated,ClientRequired,GrossMonthlyIncome,Aged18To64,
	LivingUk16Hours,TemporaryWork,NamedOnMortgage,ResidentialMortagage,PaymentsUptoDate,
	AwareOfClaim,ExtraInfoClaim,FormalNotificationOrCuts,FormalAdministrationOrLiquidation,RegisteredUnemployed,ContinuosEmployment,
	QuoteClientId, StampAction, StampDateTime, StampUser
) 
SELECT  
	Age, DateAgeCalculated,ClientRequired,GrossMonthlyIncome,Aged18To64,
	LivingUk16Hours,TemporaryWork,NamedOnMortgage,ResidentialMortagage,PaymentsUptoDate,
	AwareOfClaim,ExtraInfoClaim,FormalNotificationOrCuts,FormalAdministrationOrLiquidation,RegisteredUnemployed,ContinuosEmployment,
	QuoteClientId, @StampAction, GetDate(), @StampUser

FROM TAsuQuoteClient
WHERE QuoteClientId = @QuoteClientId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
