SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditPortalUserSettings]
	@StampUser varchar (255),
	@PortalUserSettingsId bigint,
	@StampAction char(1)
AS

INSERT INTO TPortalUserSettingsAudit 
( IndigoClientId, CRMContactId, UserId, EnablePortalFg, 
		SendEmailNotificationFg, AccountLockedFg, AllowFactFindFg, AllowValuationsFg, 
		AllowPortfolioReportFg, AllowFPRetirementFg, AllowFPMortgageFg, AllowFPInvestmentFg, 
		AllowFPBudgetFg, AllowFPProtectionFg, ConcurrencyId, 
	PortalUserSettingsId, StampAction, StampDateTime, StampUser) 
Select IndigoClientId, CRMContactId, UserId, EnablePortalFg, 
		SendEmailNotificationFg, AccountLockedFg, AllowFactFindFg, AllowValuationsFg, 
		AllowPortfolioReportFg, AllowFPRetirementFg, AllowFPMortgageFg, AllowFPInvestmentFg, 
		AllowFPBudgetFg, AllowFPProtectionFg, ConcurrencyId, 
	PortalUserSettingsId, @StampAction, GetDate(), @StampUser
FROM TPortalUserSettings
WHERE PortalUserSettingsId = @PortalUserSettingsId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
