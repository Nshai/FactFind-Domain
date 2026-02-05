SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreatePolicyBusinessExt]
@StampUser varchar (255),
@PolicyBusinessId bigint,
@BandingTemplateId bigint,
@MigrationRef varchar (255) = NULL,
@PortalReference varchar (50) = NULL,
@ReportNotes varchar (4000) = NULL
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  DECLARE @PolicyBusinessExtId bigint

  INSERT INTO TPolicyBusinessExt (
    PolicyBusinessId, 
    BandingTemplateId, 
    MigrationRef, 
    PortalReference, 
    ReportNotes, 
    ConcurrencyId ) 
  VALUES (
    @PolicyBusinessId, 
    @BandingTemplateId, 
    @MigrationRef, 
    @PortalReference, 
    @ReportNotes, 
    1) 

  SELECT @PolicyBusinessExtId = SCOPE_IDENTITY()
  EXEC dbo.[SpNAuditPolicyBusinessExt] @StampUser, @PolicyBusinessExtId, 'C'

  EXEC SpRetrievePolicyBusinessExtById @PolicyBusinessExtId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
