SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCreateIntroducerExtended]
	@StampUser varchar (255),
	@IntroducerId bigint, 
	@MigrationRef varchar(255)  = NULL	
AS


DECLARE @IntroducerExtendedId bigint, @Result int
			
	
INSERT INTO TIntroducerExtended
(IntroducerId, MigrationRef, ConcurrencyId)
VALUES(@IntroducerId, @MigrationRef, 1)

SELECT @IntroducerExtendedId = SCOPE_IDENTITY(), @Result = @@ERROR
IF @Result != 0 GOTO errh

Execute @Result = dbo.SpNAuditIntroducerExtended @StampUser, @IntroducerExtendedId, 'C'

IF @Result  != 0 GOTO errh

Execute dbo.SpNRetrieveIntroducerExtendedByIntroducerExtendedId @IntroducerExtendedId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
