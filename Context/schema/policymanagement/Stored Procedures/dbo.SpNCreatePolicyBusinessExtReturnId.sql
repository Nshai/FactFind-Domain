SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCreatePolicyBusinessExtReturnId]
	@StampUser varchar (255),
	@PolicyBusinessId bigint, 
	@BandingTemplateId bigint, 
	@MigrationRef varchar(255)  = NULL, 
	@PortalReference varchar(50)  = NULL	
AS


DECLARE @PolicyBusinessExtId bigint, @Result int
			
	
INSERT INTO TPolicyBusinessExt
(PolicyBusinessId, BandingTemplateId, MigrationRef, PortalReference, ConcurrencyId)
VALUES(@PolicyBusinessId, @BandingTemplateId, @MigrationRef, @PortalReference, 1)

SELECT @PolicyBusinessExtId = SCOPE_IDENTITY(), @Result = @@ERROR
IF @Result != 0 GOTO errh


Execute @Result = dbo.SpNAuditPolicyBusinessExt @StampUser, @PolicyBusinessExtId, 'C'

IF @Result  != 0 GOTO errh


SELECT @PolicyBusinessExtId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
