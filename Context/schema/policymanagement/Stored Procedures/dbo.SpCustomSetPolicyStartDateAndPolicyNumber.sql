SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[SpCustomSetPolicyStartDateAndPolicyNumber] @PolicyBusinessId bigint,
@PolicyStartDate varchar(12)='01 jan 1900',@PolicyNumber varchar(50),@StampUser varchar(255)

as

--Use this to keep the date in the correct format
set dateformat dmy

declare @StatusId_InForce bigint
declare @StatusHistoryId bigint
declare @theStartDate datetime
declare @dateOfChange datetime
declare @currentStatus varchar(50)

select @dateOfChange=getdate()

if @PolicyStartDate <>'01 jan 1900'
begin
	select @theStartDate=convert(varchar,@PolicyStartDate,103)
end
else
begin
	select @theStartDate=null
end

select @currentstatus=b.[name] from policymanagement..tstatushistory a join tstatus b on a.statusid=b.statusid where a.policybusinessid=@policybusinessid and a.currentstatusfg=1


select @StatusId_InForce=StatusId from PolicyManagement..TPolicyBusiness a join PolicyManagement..TStatus b on a.IndigoClientId=b.IndigoClientid where b.[Name]='In Force' and a.IndigoClientId=213

--Add an audit record for policy business record
Insert PolicyManagement..TPolicyBusinessAudit(PolicyDetailId,PolicyNumber,PractitionerId,ReplaceNotes,TnCCoachId,AdviceTypeId,BestAdvicePanelUsedFG,WaiverDefermentPeriod,IndigoClientId,
						SwitchFG,TotalRegularPremium,TotalLumpSum,MaturityDate,LifeCycleId,PolicyStartDate,PremiumType,AgencyNumber,ProviderAddress,OffPanelFg,
						BaseCurrency,ExpectedPaymentDate,ProductName,InvestmentTypeId,RiskRating,SequentialRef,ConcurrencyId,PolicyBusinessId,
						StampAction,StampDateTime,StampUser)
select PolicyDetailId,PolicyNumber,PractitionerId,ReplaceNotes,TnCCoachId,AdviceTypeId,BestAdvicePanelUsedFG,WaiverDefermentPeriod,IndigoClientId,
						SwitchFG,TotalRegularPremium,TotalLumpSum,MaturityDate,LifeCycleId,PolicyStartDate,PremiumType,AgencyNumber,ProviderAddress,OffPanelFg,
						BaseCurrency,ExpectedPaymentDate,ProductName,InvestmentTypeId,RiskRating,SequentialRef,ConcurrencyId,PolicyBusinessId,
						'U',getdate(),@StampUser
from PolicyManagement..TPolicyBusiness
where policybusinessid=@policybusinessid


Update PolicyManagement..TPolicyBusiness
SET PolicyNumber=@PolicyNumber,PolicyStartDate=@theStartDate
WHERE PolicyBusinessId=@PolicyBusinessId

if lower(@currentstatus)='submitted to provider'
begin
--If the policy is currently submitted to provider then set it to inforce and add a status history record
exec PolicyManagement..SpCustomCreateStatusHistory
@StampUser=@StampUser,
@PolicyBusinessId=@PolicyBusinessId,
@StatusId=@StatusId_InForce,
@StatusReasonId=NULL,
@ChangedToDate=@theStartDate,
@ChangedByUserId=@StampUser,
@DateOfChange=@dateOfChange,
@LifeCycleStepFG=1
end

--If current status is in force, update the inforce date
if (lower(@currentstatus)='in force' and  @PolicyStartDate>'01 jan 1900')
begin
	select @StatusHistoryId=StatusHistoryId from policymanagement..tstatushistory where policybusinessid=@policybusinessid and currentstatusfg=1
	insert PolicyManagement..TStatusHistoryAudit(PolicyBusinessId,StatusId,StatusReasonId,ChangedToDate,ChangedByUserId,DateOfChange,LifeCycleStepFG,
							CurrentStatusFG,ConcurrencyId,StatusHistoryId,StampAction,StampDateTime,StampUser)
	select PolicyBusinessId,StatusId,StatusReasonId,ChangedToDate,ChangedByUserId,DateOfChange,LifeCycleStepFG,
		CurrentStatusFG,ConcurrencyId,StatusHistoryId,'U',getdate(),@StampUser
	from PolicyManagement..TStatusHistory
	where StatusHistoryId=@StatusHistoryId

	Update PolicyManagement..TStatusHistory
	Set ChangedToDate=@PolicyStartDate
	where StatusHistoryId=@StatusHistoryId

end

--Delete the PolicyBusinessCache record
if exists(select PolicyBusinessCacheId from PolicyManagement..TPolicyBusinessCache where PolicyBusinessId=@PolicyBusinessId)
begin
	insert PolicyManagement..TPolicyBusinessCacheAudit(PolicyBusinessId,CachedHTML,ConcurrencyId,PolicyBusinessCacheId,
								StampAction,StampDateTime,StampUser)
	select PolicyBusinessId,CachedHTML,ConcurrencyId,PolicyBusinessCacheId,'D',getdate(),@StampUser
	from PolicyManagement..TPolicyBusinessCache
	where policybusinessid=@PolicyBusinessId
	
	delete from PolicyManagement..TPolicyBusinessCache
	where policybusinessid=@PolicyBusinessId
end

--Update The TDNPolicyMatching record
insert commissions..tdnpolicymatchingaudit
(IndClientId,PolicyId,PolicyNo,PolicyRef,ExpCommAmount,RefProdProviderId,ProviderName,RefComTypeId,
RefComTypeName,PractitionerId,PractUserId,PractName,ClientId,ClientFirstName,ClientLastName,PreSubmissionFG,
StatusId,StatusDate,SubmittedDate,RefPlanType2ProdSubTypeId,GroupId,ConcurrencyId,DnPolicyMatchingId,StampAction,StampDateTime,StampUser)

select IndClientId,PolicyId,PolicyNo,PolicyRef,ExpCommAmount,RefProdProviderId,ProviderName,RefComTypeId,
RefComTypeName,PractitionerId,PractUserId,PractName,ClientId,ClientFirstName,ClientLastName,PreSubmissionFG,
StatusId,StatusDate,SubmittedDate,RefPlanType2ProdSubTypeId,GroupId,ConcurrencyId,DnPolicyMatchingId,
'U',getdate(),@StampUser
from commissions..tdnpolicymatching
where policyid=@PolicyBusinessId

Update commissions..tdnpolicymatching
set PolicyNo=@PolicyNumber,
statusid=@StatusId_InForce,
StatusDate=@theStartDate
where PolicyId=@PolicyBusinessId


GO
