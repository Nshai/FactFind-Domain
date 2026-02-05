SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNRetrieveActionByFactFindTypeId]
	@FactFindTypeId bigint
AS

Select * 
From FactFind.dbo.TAction As [Action]
Where [Action].FactFindTypeId = @FactFindTypeId
GO
