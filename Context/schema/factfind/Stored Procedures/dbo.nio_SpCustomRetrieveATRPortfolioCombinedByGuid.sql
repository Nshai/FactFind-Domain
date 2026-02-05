SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[nio_SpCustomRetrieveATRPortfolioCombinedByGuid] 

@Guid uniqueidentifier

as

select 
 AtrPortfolioId,
 Guid,
 Identifier,
 Active,
 AnnualReturn,
 Volatility,
 AtrTemplateGuid,
 IndigoClientId,
 ATRRefPortfolioTypeId
from factfind..TATRPortfolioCombined
where Guid = @Guid
GO
