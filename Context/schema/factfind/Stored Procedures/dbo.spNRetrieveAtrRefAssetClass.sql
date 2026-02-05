SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[spNRetrieveAtrRefAssetClass] as

select 
AtrRefAssetClassId,
Identifier,
ShortName,
Ordering,
ConcurrencyId
from TAtrRefAssetClass
GO
