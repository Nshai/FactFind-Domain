SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[SpCustomUpdateIndigoClientCombined]
@IndigoClientId bigint,
@RefEnvironmentId bigint,
@StampUser varchar(50)

as

begin

INSERT INTO TIndigoClientCombinedAudit (IndigoClientId, Identifier, RefEnvironmentId, IsPortfolioConstructionProvider, IsAuthorProvider, IsAtrProvider, Guid, StampAction, StampUser, StampDateTime)
SELECT IndigoClientId, Identifier, RefEnvironmentId, IsPortfolioConstructionProvider, IsAuthorProvider, IsAtrProvider, Guid, 'U', @StampUser, getdate()
FROM TIndigoClientCombined 
WHERE IndigoClientId = @IndigoClientId
AND RefEnvironmentId = @RefEnvironmentId

UPDATE icc
SET icc.Identifier = ic.Identifier,
icc.IsPortfolioConstructionProvider = ic.IsPortfolioConstructionProvider,
icc.IsAuthorProvider = ic.IsAuthorProvider,
icc.IsAtrProvider = ic.IsAtrProvider
FROM TIndigoClientCombined icc
JOIN TIndigoClient ic ON ic.IndigoClientId = icc.IndigoClientId AND icc.RefEnvironmentId = @RefEnvironmentId

SELECT * FROM TIndigoClientCombined WHERE IndigoClientId = @IndigoClientId AND RefEnvironmentId = @RefEnvironmentId

FOR XML AUTO
end
GO
