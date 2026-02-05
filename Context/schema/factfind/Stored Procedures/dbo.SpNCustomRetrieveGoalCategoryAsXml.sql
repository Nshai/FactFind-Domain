SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveGoalCategoryAsXml]
AS

SELECT
RefGoalCategoryId,
Name

FROM TRefGoalCategory

order by Ordinal

FOR XML RAW('GoalCategory')
GO
