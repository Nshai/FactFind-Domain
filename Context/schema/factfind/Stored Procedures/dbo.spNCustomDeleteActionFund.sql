SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[spNCustomDeleteActionFund] 

@ActionFundId bigint,
@StampUser varchar(50)

as

exec spNAuditActionFund @StampUser,@ActionFundId,'D'

delete	a
from	TActionFund a
where	actionfundid = @ActionFundId
GO
