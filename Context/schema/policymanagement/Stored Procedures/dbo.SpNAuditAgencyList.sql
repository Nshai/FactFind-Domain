set quoted_identifier off
go
set ansi_nulls on
go
create procedure [dbo].[spnauditagencylist]
	@stampuser varchar (255),
	@agencylistid bigint,
	@stampaction char(1)
as

insert into [dbo].[tagencylistaudit]
           ([agencylistid],[code],[Type],[fca],[refprodproviderid]
		   ,[stampaction],[stampdatetime],[stampuser])
select agencylistid,code, [Type], fca,refprodproviderid
           ,@stampaction,getdate(),@stampuser
from tagencylist
where agencylistid = @agencylistid

if @@error != 0 goto errh

return (0)

errh:
return (100)

go
