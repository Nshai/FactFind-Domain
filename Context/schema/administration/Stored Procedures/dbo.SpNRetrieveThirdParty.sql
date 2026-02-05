SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNRetrieveThirdParty]
AS

SELECT T1.ThirdPartyId, T1.ThirdPartyDescription, T1.ConcurrencyId
FROM TThirdParty  T1
GO
