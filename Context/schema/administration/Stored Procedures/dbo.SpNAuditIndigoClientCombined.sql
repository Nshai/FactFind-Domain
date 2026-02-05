SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditIndigoClientCombined]
	@StampUser varchar (255),
	@IndigoClientCombinedId bigint,  
	@StampAction char(1)
AS

--Note: The @IndigoClientCombinedId parameter maps to IndigoClientId - this is named this way due to work with the Audit Attribute
-- It takes the table name and strips the 'T' and adds the 'Id' as beging the primary key

INSERT INTO TIndigoClientCombinedAudit

( [Guid], IndigoClientId, Identifier, RefEnvironmentId, IsPortfolioConstructionProvider, 
	IsAuthorProvider, IsAtrProvider, ConcurrencyId, StampAction, StampDateTime, StampUser)

Select [Guid], IndigoClientId, Identifier, RefEnvironmentId, IsPortfolioConstructionProvider, 
	IsAuthorProvider, IsAtrProvider, ConcurrencyId, @StampAction, GetDate(), @StampUser

FROM TIndigoClientCombined
WHERE IndigoClientId = @IndigoClientCombinedId  

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
