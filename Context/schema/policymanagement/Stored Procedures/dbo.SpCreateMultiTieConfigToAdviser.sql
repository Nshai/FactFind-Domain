SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpCreateMultiTieConfigToAdviser]
@TenantId int,
@MultiTieName Varchar(250),
@AdviserIds dbo.[tvp_bigint] READONLY
AS
BEGIN
	insert into TMultiTieConfigToAdviser (MultiTieConfigId, AdviserId, TenantId) 
	select mtc.MultiTieConfigId,
		   a.[VALUE], 
		   @TenantId
	from @AdviserIds a
	inner join TMultiTieConfig mtc on mtc.MultiTieName = @MultiTieName
	where a.VALUE not in (select AdviserId from TMultiTieConfigToAdviser)
		and mtc.MultiTieName = @MultiTieName
		and mtc.TenantId = @TenantId
		and mtc.IsArchived = 0
END
RETURN (0)
GO
