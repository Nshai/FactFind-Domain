SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveSplitBasicById]
	@SplitBasicId bigint
AS

BEGIN
	SELECT
	1 AS Tag,
	NULL AS Parent,
	T1.SplitBasicId AS [SplitBasic!1!SplitBasicId], 
	T1.IndClientId AS [SplitBasic!1!IndClientId], 
	ISNULL(T1.PractitionerId, '') AS [SplitBasic!1!PractitionerId], 
	ISNULL(T1.PractitionerCRMContactId, '') AS [SplitBasic!1!PractitionerCRMContactId], 
	ISNULL(T1.BandingTemplateId, '') AS [SplitBasic!1!BandingTemplateId], 
	ISNULL(T1.GroupingId, '') AS [SplitBasic!1!GroupingId], 
	ISNULL(T1.GroupCRMContactId, '') AS [SplitBasic!1!GroupCRMContactId], 
	CONVERT(varchar(24), T1.SplitPercent) AS [SplitBasic!1!SplitPercent], 
	T1.PaymentEntityId AS [SplitBasic!1!PaymentEntityId], 
	T1.PractitionerFg AS [SplitBasic!1!PractitionerFg], 
	T1.ConcurrencyId AS [SplitBasic!1!ConcurrencyId]
	FROM TSplitBasic T1
	
	WHERE T1.SplitBasicId = @SplitBasicId
	ORDER BY [SplitBasic!1!SplitBasicId]

  FOR XML EXPLICIT

END
RETURN (0)
GO
