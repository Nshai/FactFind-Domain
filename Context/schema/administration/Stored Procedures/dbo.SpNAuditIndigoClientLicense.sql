SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditIndigoClientLicense]
	@StampUser varchar (255),
	@IndigoClientLicenseId bigint,
	@StampAction char(1)
AS

INSERT INTO [Administration].[dbo].[TIndigoClientLicenseAudit] (
	[IndigoClientId]
	,[LicenseTypeId]	
	,[Status]
	,[MaxConUsers]
	,[MaxULAGCount]
	,[UADRestriction]
	,[MaxULADCount]
	,[AdviserCountRestrict]
	,[MaxAdviserCount]
	,[MaxFinancialPlanningUsers]
    ,[ConcurrencyId]		
	,[MaxAdvisaCentaCoreUsers]
	,[MaxAdvisaCentaCorePlusLifetimePlannerUsers]
	,[IndigoClientLicenseId]
	,[StampAction]
	,[StampDateTime]
	,[StampUser]
	) 
Select 
	[IndigoClientId]
	,[LicenseTypeId]	
	,[Status]
	,[MaxConUsers]
	,[MaxULAGCount]
	,[UADRestriction]
	,[MaxULADCount]
	,[AdviserCountRestrict]
	,[MaxAdviserCount]
	,[MaxFinancialPlanningUsers]
    ,[ConcurrencyId]
	,[MaxAdvisaCentaCoreUsers]
	,[MaxAdvisaCentaCorePlusLifetimePlannerUsers]	
	,[IndigoClientLicenseId]
	,@StampAction
	,GetDate()
	,@StampUser
FROM [dbo].[TIndigoClientLicense]
WHERE IndigoClientLicenseId = @IndigoClientLicenseId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
