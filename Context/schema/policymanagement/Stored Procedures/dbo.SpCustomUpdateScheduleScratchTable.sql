SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomUpdateScheduleScratchTable] @ValScheduleScratchId bigint, @IsProcessed bit  
AS    
  
--Update done this was as this is NOT a standard table with concurreny etc...  

--06/02/2009 - Added code to update next item's* SubmitAtOrAfter field to be current time + ScheduleDelay for the provider

Declare @NextValScheduleScratchId bigint, @SubmitSequenceByProvider bigint, @RefProdProviderId bigint
Declare @ScheduleDelay int, @LastSubmitAtOrAfter datetime

Begin Tran RS

--Get specific details related to this item
Select @RefProdProviderId = A.RefProdProviderId, @SubmitSequenceByProvider = SubmitSequenceByProvider, 
	@ScheduleDelay = B.ScheduleDelay, @LastSubmitAtOrAfter = A.SubmitAtOrAfter 
From TValScheduleScratch A with(nolock)
Inner Join TValProviderConfig B with(nolock) On A.RefProdProviderId = B.RefProdProviderId
Where ValScheduleScratchId = @ValScheduleScratchId


--Identify next record to process by SubmitSequenceByProvider and if Time is less or equal to 23:55 (allow for last item to be processed)
Select @NextValScheduleScratchId = IsNull(ValScheduleScratchId,0)
From TValScheduleScratch with(nolock) 
Where RefProdProviderId = @RefProdProviderId 
And SubmitSequenceByProvider = (@SubmitSequenceByProvider + 1)
And getdate() <= (
	dateadd(s, 0, 
		dateadd(n, 55, 
			dateadd(hh, 23, convert(varchar(11), getdate(),121))))
)


--Update main record as @IsProcessed
Update TValScheduleScratch  
Set IsProcessed = @IsProcessed  
Where ValScheduleScratchId = @ValScheduleScratchId  

--Update next records SubmitAtOrAfter field
If @NextValScheduleScratchId > 0 And @IsProcessed = 1
Begin
	Update A
	Set SubmitAtOrAfter =
		Case When ScheduledLevel = 'firm' or ScheduledLevel = 'bulkmanual' Then
			Case When RefValScheduleItemStatusId not in (0,4,8) Then 
				NextOccurrence 
			Else 
				Null 
			End
		Else
			--If the current time is greater then the @LastSubmitAtOrAfter time
			Case When dateadd(s, 0, convert(varchar(24), getdate(),121)) > dateadd(s, 0, convert(varchar(24), @LastSubmitAtOrAfter,121)) Then
					--then set SubmitAtOrAfter = current time + ScheduleDelay
					Case When ScheduleDelay = 0 Then
						dateadd(s, 1, convert(varchar(24), getdate(),121))
					Else
						dateadd(s, ScheduleDelay, convert(varchar(24), getdate(),121))
					End
			Else
				--Else set SubmitAtOrAfter = @LastSubmitAtOrAfter + ScheduleDelay
				Case When ScheduleDelay = 0 Then
					dateadd(s, 1, convert(varchar(24), @LastSubmitAtOrAfter,121))
				Else
					dateadd(s, ScheduleDelay, convert(varchar(24), @LastSubmitAtOrAfter,121))
				End
			End
		End
	From TValScheduleScratch A 
	Inner Join TValScheduleConfig B On A.RefProdProviderId = B.RefProdProviderId
	Where A.ValScheduleScratchId = @NextValScheduleScratchId  
End


Commit Tran RS


/*

Use PolicyManagement
Go 

-Original Code  
CREATE PROCEDURE SpCustomUpdateScheduleScratchTable @ValScheduleScratchId bigint, @IsProcessed bit  
AS    
  
--Update done this was as this is NOT a standard table with concurreny etc...  
  
Update TValScheduleScratch  
Set IsProcessed = @IsProcessed  
Where ValScheduleScratchId = @ValScheduleScratchId  
  
*/ 
  
  
GO
