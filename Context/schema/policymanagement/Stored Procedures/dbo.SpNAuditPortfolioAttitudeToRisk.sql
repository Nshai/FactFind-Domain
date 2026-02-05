set quoted_identifier off
go
set ansi_nulls on
go
create procedure [dbo].[SpNAuditPortfolioAttitudeToRisk]
	@StampUser varchar (255),
	@PortfolioAttitudeToRiskId bigint,
	@StampAction char(1)
as

insert into [dbo].[TPortfolioAttitudeToRiskAudit]
([PortfolioAttitudeToRiskId], [Code], [PortfolioId], [Description], [StampAction], [StampDateTime], [StampUser])
select 
[PortfolioAttitudeToRiskId], [Code], [PortfolioId], [Description], @StampAction, GetDate(), @StampUser
from [dbo].[TPortfolioAttitudeToRisk]
where [PortfolioAttitudeToRiskId] = @PortfolioAttitudeToRiskId;

if @@ERROR != 0 goto errh

return (0)

errh:
return (100)

go
