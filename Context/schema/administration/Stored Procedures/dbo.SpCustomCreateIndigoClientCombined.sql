SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[SpCustomCreateIndigoClientCombined]
@IndigoClientId bigint,
@StampIndigoClient varchar(50)

as

begin

INSERT INTO TIndigoClientCombined (IndigoClientId, Identifier, RefEnvironmentId, IsPortfolioConstructionProvider, IsAuthorProvider, IsAtrProvider, Guid, ConcurrencyId)
SELECT @IndigoClientId, Identifier, RefEnvironmentId, IsPortfolioConstructionProvider, IsAuthorProvider, IsAtrProvider, Guid, 1
FROM TIndigoClient WHERE IndigoClientId = @IndigoClientId

INSERT INTO TIndigoClientCombinedAudit (IndigoClientId, Identifier, RefEnvironmentId, IsPortfolioConstructionProvider, IsAuthorProvider, IsAtrProvider, ConcurrencyId, Guid, StampAction, StampUser, StampDateTime)
SELECT IndigoClientId, Identifier, RefEnvironmentId, IsPortfolioConstructionProvider, IsAuthorProvider, IsAtrProvider, 1, Guid, 'C', @StampIndigoClient, getdate()
FROM TIndigoClientCombined WHERE IndigoClientId = @IndigoClientId

end
GO
