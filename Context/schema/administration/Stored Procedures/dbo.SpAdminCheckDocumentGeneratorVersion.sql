SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpAdminCheckDocumentGeneratorVersion]
	@TenantId bigint,
	@DefaultGeneratorVersion tinyint = 2 -- This is new author, should be the default for new tenants (other than simply biz).
AS
DECLARE @ExtendedId bigint, @CurrentGeneratorVersion tinyint

--Users should not be able to set this to old author
Select @DefaultGeneratorVersion = 2

---------------------------------------------------------------
-- Get current information from the extended table for this tenant
---------------------------------------------------------------
SELECT 
	@ExtendedId = IndigoClientExtendedId, 
	@CurrentGeneratorVersion = DocumentGeneratorVersion
FROM 
	TIndigoClientExtended 
WHERE 
	IndigoClientId = @TenantId

---------------------------------------------------------------
-- If there is no TIndigoClientExtended record then add a new one
---------------------------------------------------------------
IF @ExtendedId IS NULL BEGIN
	INSERT INTO TIndigoClientExtended (
		IndigoClientId, FinancialYearStartMonth, LogEventsTo, ConcurrencyId, DocumentGeneratorVersion)
	VALUES (
		@TenantId,	
		1, NULL, 1, @DefaultGeneratorVersion)
		
	SET @ExtendedId = SCOPE_IDENTITY()
	
	EXEC SpNAuditIndigoClientExtended 0, @ExtendedId, 'C'

END		
---------------------------------------------------------------
-- If there is no DocGenerator version specified then update the extended table
---------------------------------------------------------------
ELSE IF @CurrentGeneratorVersion IS NULL BEGIN
	EXEC SpNAuditIndigoClientExtended 0, @ExtendedId, 'U'
	
	UPDATE TIndigoClientExtended 
	SET
		DocumentGeneratorVersion = @DefaultGeneratorVersion,
		ConcurrencyId = ConcurrencyId + 1			
	WHERE 
		IndigoClientExtendedId = @ExtendedId
END	
GO
