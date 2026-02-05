SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[spNCustomIsFundPanelRestricted] @UserId bigint as

if (select 1 from administration..TUser u
		inner join TFundPanelRestricted a on u.activerole = a.roleid
		where @UserId = UserId) > 0
		select 1
		
else select 0
GO
