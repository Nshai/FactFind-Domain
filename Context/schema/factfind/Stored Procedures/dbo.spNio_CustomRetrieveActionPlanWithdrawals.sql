SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE procedure [dbo].[spNio_CustomRetrieveActionPlanWithdrawals]      



@ActionPlanIds varchar(max)    



as      



Declare @ParsedValues Table ( Id int, ParsedValue varchar(200) )  

Insert Into @ParsedValues(Id, ParsedValue)

Exec Administration.dbo.SpCustomParseCsvStringToStringList @CommaSeperatedList = @ActionPlanIds







Select ActionPlanWithdrawalId, ActionPlanId, WithdrawalAmount, WithdrawalType, WithdrawalFrequency, IsIncreased, IsEncashment



From TActionPlanWithdrawal A

Where ActionPlanId in (Select ParsedValue From @ParsedValues)




GO
