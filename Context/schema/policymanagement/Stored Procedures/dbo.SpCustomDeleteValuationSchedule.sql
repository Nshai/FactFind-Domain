SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomDeleteValuationSchedule]
AS 

Declare @ValScheduleId bigint, @IndigoClientId bigint

--Delete val schedules for indigoclients who's status is not active
--Use a cursor to loop through all indigoclients
declare c_IndigoClients cursor for
select a.ValScheduleId, a.IndigoClientId
from policymanagement..tvalschedule a with(nolock)
inner join administration..tindigoclient b with(nolock) on a.indigoclientid = b.indigoclientid
where b.status <> 'active'

open c_IndigoClients
fetch next from c_IndigoClients into @ValScheduleId, @IndigoClientId

while @@fetch_status=0
begin

exec SpDeleteValSchedulePolicyByValScheduleId @ValScheduleId, '0'
exec SpDeleteValScheduleItemByValScheduleId @ValScheduleId, '0'
exec SpDeleteValScheduleById @ValScheduleId, '0'

fetch next from c_IndigoClients into @ValScheduleId, @IndigoClientId

end
close c_IndigoClients
deallocate c_IndigoClients



GO
