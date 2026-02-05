
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[spCustomGenerateMovementsJob]
	
AS

-- This is for initial ONLY now ... - SO ... only get the last run for initial movements :-)
Declare @LastMovmentRunDate datetime =(Select Max(LastRunDateTime) from TMovement where LastRunDateTime IS NOT NULL AND IsRecurring = 0) -- Using Created Date time is wrong as it creates GAPS -- DO NOT ISNULL/GETDATE HERE NO NO NO

Declare @TimeFrameHours INT = (Select DATEDIFF(HOUR, ISNULL(@LastMovmentRunDate, GETDATE()), GETDATE()) ) + 2

print 'Last Run Date Time'
print @LastMovmentRunDate

print 'Hours To Go Back'
print @TimeFrameHours


EXEC spCustomGenerateMovements @TimeFrameHours 

Go