SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[nio_SpCustomDeleteWrapperPlanTypesByWrapperProviderId]
	(
		@wrapperproviderid bigint, @stampuser varchar (255)
	)

AS

begin

insert into TWrapperPlanTypeAudit
select 
WrapperProviderId,
RefPlanType2ProdSubTypeId,
ConcurrencyId,
WrapperPlanTypeId,
'D',
getdate(),
@stampuser
from	TWrapperPlanType
where WrapperProviderId = @wrapperproviderid

delete from TWrapperPlanType
where WrapperProviderId = @wrapperproviderid

SELECT 1

end
GO
