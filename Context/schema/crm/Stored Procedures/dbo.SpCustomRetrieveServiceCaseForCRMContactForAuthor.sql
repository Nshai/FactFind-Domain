SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomRetrieveServiceCaseForCRMContactForAuthor]
@AdviceCaseId bigint  
--set @AdviceCaseId = 6869
  

AS

  
-- calculate current monthly contributions    
declare @CurrentRegularContributions money, @CurrentLumpSumContributions money, @CurrentTransferContributions money    
    
select @CurrentRegularContributions =     
 SUM(    
  case rf.RefFrequencyId    
  when 1 then (pmi.Amount * 52)/12 --weekly    
  when 2 then (pmi.Amount * 26)/12 --fortnightly    
  when 3 then (pmi.Amount * 13)/12 --four weekly    \
  when 4 then (pmi.amount * 12)/12  -- monthly    
  when 5 then (pmi.Amount * 4 )/12  --quaterly    
  when 7 then (pmi.amount * 2 )/12  --half yearly    
  when 8 then (pmi.Amount * 1 )/12 -- annually    
 end     
 )    
 from TPolicyMoneyIn pmi    
 join TRefFrequency rf on rf.RefFrequencyId = pmi.RefFrequencyId    
 join crm..TAdviceCasePlan acp on acp.PolicyBusinessId = pmi.PolicyBusinessId and acp.AdviceCaseId = @AdviceCaseId 
 where rf.RefFrequencyId < 10
 and (pmi.StopDate is null or stopdate < getdate() )    
   
      
-- calculate current lump sum contributions    
select @CurrentLumpSumContributions =     
 SUM(pmi.Amount)    
 from TPolicyMoneyIn pmi    
 join TRefFrequency rf on rf.RefFrequencyId = pmi.RefFrequencyId    
 join crm..TAdviceCasePlan acp on acp.PolicyBusinessId = pmi.PolicyBusinessId and acp.AdviceCaseId = @AdviceCaseId 
 where rf.RefFrequencyId = 10  
 and pmi.RefContributionTypeId = 2 -- lump sum     
 and (pmi.StopDate is null or stopdate < getdate() )    
 
 -- calculate current transfer contributions    
select @CurrentTransferContributions =     
 SUM(pmi.Amount)    
 from TPolicyMoneyIn pmi    
 join TRefFrequency rf on rf.RefFrequencyId = pmi.RefFrequencyId    
 join crm..TAdviceCasePlan acp on acp.PolicyBusinessId = pmi.PolicyBusinessId and acp.AdviceCaseId = @AdviceCaseId 
 where rf.RefFrequencyId = 10  
 and pmi.RefContributionTypeId = 3 -- transfer   
 and (pmi.StopDate is null or stopdate < getdate() )    
  
  
-- create temp table as it's easier to do the calcs  
  
declare @Charges table (FeeId bigint, FeeChargingTypeId int, FeePercent decimal(12,4), VATPercent decimal(12,4), DiscountPercent decimal(12,4), DiscountAmount money, ContributionAmount money, InitialPeriod int, NetFeeAmount money, VATAmount money, TotalDiscountAmount money, TotalFeeAmount money, DiscountReason varchar(2000), InitialCharge money, FeeNetAmount money, FeeVatAmount money)  
  
insert into @Charges (FeeId, FeeChargingTypeId, FeePercent, VATPercent, DiscountPercent, DiscountAmount, ContributionAmount, InitialPeriod, DiscountReason, FeeNetAmount, FeeVatAmount)  
select   
f.FeeId, 
maxFee.RefAdviseFeeChargingTypeId,  
afcd.PercentageOfFee/100,  
isnull(v.VatRate/100,0),  
isnull(d.Percentage/100,0),  
d.Amount,  
case maxFee.RefAdviseFeeChargingTypeId 
when 8 then isnull(@CurrentRegularContributions,0)
when 9 then isnull(@CurrentLumpSumContributions,0)
when 10 then isnull(@CurrentTransferContributions,0)
End,
isnull(f.InitialPeriod,0),  
f.DiscountReason,  
f.NetAmount,  
f.VATAmount  
from TFee f       
join (      
 select MAX(f.feeid) as FeeId, afct.RefAdviseFeeChargingTypeId      
 from TFee f      
 join TFeeRetainerOwner fro on fro.FeeId = f.feeid      
 join TAdviseFeeType aft on aft.AdviseFeeTypeId = f.AdviseFeeTypeId      
 join TRefAdviseFeeType raft on raft.RefAdviseFeeTypeId = aft.RefAdviseFeeTypeId and raft.Name = 'Initial Fee'       
 join TFee2Policy f2p on f2p.FeeId = f.FeeId-- and f2p.PolicyBusinessId = @PolicyBusinessId    
 join crm..TAdviceCasePlan acp on acp.PolicyBusinessId = f2p.PolicyBusinessId and acp.AdviceCaseId = @AdviceCaseId 
 join TAdviseFeeChargingDetails afcd on afcd.AdviseFeeChargingDetailsId = f.AdviseFeeChargingDetailsId 
 join tadvisefeechargingtype afct on afct.AdviseFeeChargingTypeId = afcd.AdviseFeeChargingTypeId  
 group by afct.RefAdviseFeeChargingTypeId
) maxFee on maxFee.FeeId = f.FeeId      
join TAdviseFeeChargingDetails afcd on afcd.AdviseFeeChargingDetailsId = f.AdviseFeeChargingDetailsId 
left join TDiscount d on d.discountid = f.discountid      
left join TRefVAT v on v.RefVATId = f.RefVATId    
 
 
Update @Charges  
set TotalDiscountAmount = DiscountPercent * ( FeePercent * ContributionAmount * InitialPeriod ) where FeeChargingTypeId = 8

Update @Charges  
set TotalDiscountAmount = DiscountPercent * ( FeePercent * ContributionAmount ) where FeeChargingTypeId in (9,10)

update @Charges
set NetFeeAmount = ( FeePercent * ContributionAmount * InitialPeriod )- TotalDiscountAmount
where FeeChargingTypeId = 8

Update @Charges  
set NetFeeAmount = ( FeePercent * ContributionAmount ) - TotalDiscountAmount
where FeeChargingTypeId in (9,10)

   
Update @Charges   
set VATAmount = VATPercent * NetFeeAmount  
  
update @Charges   
set TotalFeeAmount = NetFeeAmount + VATAmount    

update @Charges   
set InitialCharge = ( FeePercent * ContributionAmount * InitialPeriod ) - ( DiscountPercent * FeePercent * ContributionAmount * InitialPeriod ) + ( VATPercent * (( FeePercent * ContributionAmount * InitialPeriod ) - ( DiscountPercent * FeePercent * ContributionAmount * InitialPeriod )))  
where FeeChargingTypeId = 8

    
update @Charges
set InitialCharge = (FeePercent * ContributionAmount) - ( DiscountPercent * ( FeePercent * ContributionAmount )) + ( VATPercent * (( FeePercent * ContributionAmount ) - ( DiscountPercent * ( FeePercent * ContributionAmount ))))  
where FeeChargingTypeId in (9,10)


select   
 1 as tag,  
 null as parent,  
 ac.AdviceCaseId as [AdviceCase!1!AdviceCaseId],  
 ac.SequentialRef as [AdviceCase!1!SequentialRef],  
 ac.CaseName as [AdviceCase!1!CaseName],  
 convert(varchar(10), isnull(ac.StartDate,''), 103) as [AdviceCase!1!StartDate],  
 acs.Descriptor as [AdviceCase!1!Status],  
 adv.FirstName + ' ' + adv.LastName as [AdviceCase!1!AdviserName],  
 isnull(c1.FirstName,'') + isnull(' ' + c1.LastName,'') + isnull(c1.CorporateName,'') as [AdviceCase!1!Owner1Name],  
 isnull(c2.FirstName,'') + isnull(' ' + c2.LastName,'') + isnull(c2.CorporateName,'') as [AdviceCase!1!Owner2Name],  
 isnull(acy.Name,'') as [AdviceCase!1!Category],  
 null as [InitialCharge!2!InitialCharge],  
 null as [OneOffCharge!3!OneOffCharge]  
 from TAdviceCase ac  
 join TAdviceCaseStatus acs on acs.AdviceCaseStatusId = ac.StatusId  
 join tpractitioner p on p.practitionerid = ac.practitionerid  
 join tcrmcontact adv on adv.crmcontactid = p.crmcontactid  
 join tcrmcontact c1 on c1.crmcontactid = ac.CRMContactId  
 left join tcrmcontact c2 on c2.crmcontactid = ac.owner2partyid  
 left join policymanagement..TAdviseCategory acy on acy.AdviseCategoryId = ac.AdviseCategoryId  
 where ac.AdviceCaseId = @AdviceCaseId  
   
 union  
   
 select   
 2 as tag,  
 1 as parent,  
 @AdviceCaseId,  
 null,  
 null,  
 null,  
 null,  
 null,  
 null,  
 null,   
 null,  
 case 
	when sum(isnull(FeePercent,0)) = 0 then SUM(isnull(FeeNetAmount,0) + isnull(FeeVatAmount,0))
	else SUM(isnull(NetFeeAmount,0) + isnull(VatAmount,0))
 end,  
 null  
 from @Charges
  
 union  
   
 select   
 3 as tag,  
 1 as parent,  
 ac.AdviceCaseId,  
 null,  
 null,  
 null,  
 null,  
 null,  
 null,  
 null,   
 null,  
 null,  
 SUM(isnull(f.NetAmount,0) + isnull(f.VatAmount,0))  
 from TAdviceCase ac  
 join TAdviceCaseFee acf on acf.AdviceCaseId = ac.AdviceCaseId  
 join policymanagement..TFee f on f.FeeId = acf.FeeId  
 left join policymanagement..TAdviseFeeType aft on aft.AdviseFeeTypeId = f.AdviseFeeTypeId    
 left join policymanagement..TRefAdviseFeeType raft on raft.RefAdviseFeeTypeId = aft.RefAdviseFeeTypeId  
 where ac.AdviceCaseId = @AdviceCaseId  
 and (aft.RefAdviseFeeTypeId = 3 or aft.RefAdviseFeeTypeId is null) -- one-off, or no category  
 group by ac.AdviceCaseId  
  
  
  FOR XML EXPLICIT

GO