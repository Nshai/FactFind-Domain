SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spGetFactFindQuery] 
	@FactFindId bigint
AS

SELECT
    ff.FactFindId,
	ff.CRMContactId1,
	ff.CRMContactId2
FROM TFactFind ff
WHERE ff.FactFindId = @FactFindId

GO