SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomRetrieveCombinedIndigoClients]
@Filter varchar(255),
@FilterValue varchar(255)

AS

declare @sql varchar(1000)

set @sql = '
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.Guid AS [IndigoClientCombined!1!Guid], 
    T1.Identifier AS [IndigoClientCombined!1!Identifier], 
    T1.IndigoClientId AS [IndigoClientCombined!1!IndigoClientId], 
    T1.RefEnvironmentId AS [IndigoClientCombined!1!RefEnvironmentId], 
    T1.IsPortfolioConstructionProvider AS [IndigoClientCombined!1!IsPortfolioConstructionProvider], 
    T1.IsAuthorProvider AS [IndigoClientCombined!1!IsAuthorProvider], 
    T1.ConcurrencyId AS [IndigoClientCombined!1!ConcurrencyId]
  FROM TIndigoClientCombined T1
'
if @Filter <> ''
	set @Sql = @sql + ' WHERE (T1.' + @filter + ' = ' + @filtervalue+ ')'

set @sql = @sql + ' ORDER BY [IndigoClientCombined!1!Identifier] FOR XML EXPLICIT'

exec (@sql)


RETURN (0)
GO
