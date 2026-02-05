SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditReportAddressConfiguration]
	@StampUser varchar (255),
	@ReportAddressConfigurationId bigint,
	@StampAction char(1)
AS

INSERT INTO TReportAddressConfigurationAudit 
( IndigoClientId, ReportName, UseOrganisationAddress, UseLegalEntityAddress, 
		UseGroupAddress, ConcurrencyId, 
	ReportAddressConfigurationId, StampAction, StampDateTime, StampUser) 
Select IndigoClientId, ReportName, UseOrganisationAddress, UseLegalEntityAddress, 
		UseGroupAddress, ConcurrencyId, 
	ReportAddressConfigurationId, @StampAction, GetDate(), @StampUser
FROM TReportAddressConfiguration
WHERE ReportAddressConfigurationId = @ReportAddressConfigurationId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
