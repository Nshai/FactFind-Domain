SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNRetrieveActionByActionId]
	@ActionId bigint
AS

SELECT T1.ActionId, T1.Identifier, T1.Descriptor, T1.Javascript, T1.Ordinal, T1.FactFindTypeId, T1.ConcurrencyId
FROM TAction  T1
WHERE T1.ActionId = @ActionId

GO
