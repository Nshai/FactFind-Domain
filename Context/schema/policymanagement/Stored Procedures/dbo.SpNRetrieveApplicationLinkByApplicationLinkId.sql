SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNRetrieveApplicationLinkByApplicationLinkId]
	@ApplicationLinkId bigint
AS

SELECT T1.ApplicationLinkId, T1.IndigoClientId, T1.RefApplicationId, T1.MaxLicenceCount, T1.CurrentLicenceCount, T1.AllowAccess, 
	T1.ExtranetURL, T1.ConcurrencyId
FROM TApplicationLink  T1
WHERE T1.ApplicationLinkId = @ApplicationLinkId
GO
