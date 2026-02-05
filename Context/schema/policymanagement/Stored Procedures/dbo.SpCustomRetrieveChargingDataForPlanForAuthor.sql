SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[SpCustomRetrieveChargingDataForPlanForAuthor]
@PolicyBusinessId bigint

AS 

BEGIN
  
-- calculate current monthly contributions    
declare @CurrentRegularContributions money, @CurrentLumpSumContributions money, @CurrentTransferContributions money      
      
select @CurrentRegularContributions =       
 ISNULL(SUM(      
  case rf.RefFrequencyId      
  when 1 then (pmi.Amount * 52)/12 --weekly      
  when 2 then (pmi.Amount * 26)/12 --fortnightly      
  when 3 then (pmi.Amount * 13)/12 --four weekly    \  
  when 4 then (pmi.amount * 12)/12  -- monthly      
  when 5 then (pmi.Amount * 4 )/12  --quaterly      
  when 7 then (pmi.amount * 2 )/12  --half yearly      
  when 8 then (pmi.Amount * 1 )/12 -- annually      
 end       
 ),0)      
 from TPolicyMoneyIn pmi      
 join TRefFrequency rf on rf.RefFrequencyId = pmi.RefFrequencyId      
 where PolicyBusinessId = @PolicyBusinessId      
 and rf.RefFrequencyId < 10  
 and (pmi.StopDate is null or stopdate < getdate() )      
     
        
-- calculate current lump sum contributions      
select @CurrentLumpSumContributions = 
 ISNULL(SUM(pmi.Amount),0)
 from TPolicyMoneyIn pmi      
 join TRefFrequency rf on rf.RefFrequencyId = pmi.RefFrequencyId      
 where PolicyBusinessId = @PolicyBusinessId      
 and rf.RefFrequencyId = 10    
 and pmi.RefContributionTypeId = 2 -- lump sum       
 and (pmi.StopDate is null or stopdate < getdate() )      
   
 -- calculate current transfer contributions      
select @CurrentTransferContributions =  
 ISNULL(SUM(pmi.Amount),0)
 from TPolicyMoneyIn pmi      
 join TRefFrequency rf on rf.RefFrequencyId = pmi.RefFrequencyId      
 where PolicyBusinessId = @PolicyBusinessId      
 and rf.RefFrequencyId = 10    
 and pmi.RefContributionTypeId = 3 -- transfer     
 and (pmi.StopDate is null or stopdate < getdate() )      
    
    
-- create temp table as it's easier to do the calcs    
    
declare @Charges table (
	FeeId bigint, FeeChargingTypeId int, FeePercent decimal(12,4), VATPercent decimal(12,4), 
	DiscountPercent decimal(12,4), DiscountAmount money, ContributionAmount money, InitialPeriod int, 
	NetFeeAmount money, VATAmount money, TotalDiscountAmount money, TotalFeeAmount money, 
	DiscountReason varchar(2000), InitialCharge money, 
	FeeNetAmount money, FeeVatAmount money, 
	InitialChargeOnLumpSum money, InitialChargeOnRegular money,
	MinFeeAmount money, MaxFeeAmount money
)    
    
insert into @Charges (
	FeeId, FeeChargingTypeId, FeePercent, VATPercent, DiscountPercent, DiscountAmount, 
	ContributionAmount, InitialPeriod, DiscountReason, FeeNetAmount, FeeVatAmount, MinFeeAmount, MaxFeeAmount)    
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
	f.VATAmount,
	isnull(afcd.MinimumFee,0),
	isnull(afcd.MaximumFee,0)  
from TFee f         
join (        
 select MAX(f.feeid) as FeeId, afct.RefAdviseFeeChargingTypeId        
 from TFee f        
 join TFeeRetainerOwner fro on fro.FeeId = f.feeid        
 join TAdviseFeeType aft on aft.AdviseFeeTypeId = f.AdviseFeeTypeId        
 join TRefAdviseFeeType raft on raft.RefAdviseFeeTypeId = aft.RefAdviseFeeTypeId and raft.Name = 'Initial Fee'         
 join TFee2Policy f2p on f2p.FeeId = f.FeeId and f2p.PolicyBusinessId = @PolicyBusinessId      
 join TAdviseFeeChargingDetails afcd on afcd.AdviseFeeChargingDetailsId = f.AdviseFeeChargingDetailsId   
 join tadvisefeechargingtype afct on afct.AdviseFeeChargingTypeId = afcd.AdviseFeeChargingTypeId    
 group by afct.RefAdviseFeeChargingTypeId  
) maxFee on maxFee.FeeId = f.FeeId        
join TAdviseFeeChargingDetails afcd on afcd.AdviseFeeChargingDetailsId = f.AdviseFeeChargingDetailsId   
left join TDiscount d on d.discountid = f.discountid        
left join TRefVAT v on v.RefVATId = f.RefVATId      



--------------------------------------------------------
-- Calculate Total Discount Amount
Update @Charges
set TotalDiscountAmount = DiscountPercent * ( ( FeePercent * (@CurrentTransferContributions + @CurrentLumpSumContributions) ) + ( FeePercent * @CurrentRegularContributions * InitialPeriod ) ) 
where FeeChargingTypeId not in (8,9,10)   
   
Update @Charges    
set TotalDiscountAmount = DiscountPercent * ( FeePercent * ContributionAmount * InitialPeriod ) 
where FeeChargingTypeId = 8  
  
Update @Charges    
set TotalDiscountAmount = DiscountPercent * ( FeePercent * ContributionAmount ) 
where FeeChargingTypeId in (9,10)  
--------------------------------------------------------



--------------------------------------------------------  
-- Calculate Net Fee Amount 
Update @Charges
set NetFeeAmount = ( ( FeePercent * (@CurrentTransferContributions + @CurrentLumpSumContributions) ) + ( FeePercent * @CurrentRegularContributions * InitialPeriod ) - TotalDiscountAmount ) 
where FeeChargingTypeId not in (8,9,10)  
  
update @Charges  
set NetFeeAmount = ( FeePercent * ContributionAmount * InitialPeriod )- TotalDiscountAmount  
where FeeChargingTypeId = 8  
  
Update @Charges    
set NetFeeAmount = ( FeePercent * ContributionAmount ) - TotalDiscountAmount  
where FeeChargingTypeId in (9,10)  
--------------------------------------------------------
  


--------------------------------------------------------
-- apply the min/max fee range
UPDATE @Charges 
SET NetFeeAmount = 
	case 
		when MinFeeAmount > 0 AND NetFeeAmount < MinFeeAmount then MinFeeAmount
		when MaxFeeAmount > 0 AND NetFeeAmount > MaxFeeAmount then MaxFeeAmount
		else NetFeeAmount
	end

--------------------------------------------------------



--------------------------------------------------------  
-- Calculate VAT Amount     
Update @Charges     
set VATAmount = VATPercent * NetFeeAmount    
-------------------------------------------------------- 



--------------------------------------------------------  
-- Calculate Total Fee Amount 
update @Charges     
set TotalFeeAmount = NetFeeAmount + VATAmount      
--------------------------------------------------------  



--------------------------------------------------------  
-- Calculate Initial Charge. Diff output fields depending on FeeChargingType

update @Charges 
set InitialChargeOnLumpSum = (FeePercent * (@CurrentTransferContributions + @CurrentLumpSumContributions)) - ( DiscountPercent * ( FeePercent * (@CurrentTransferContributions + @CurrentLumpSumContributions) )) + ( VATPercent * (( FeePercent * (@CurrentTransferContributions + @CurrentLumpSumContributions) ) - ( DiscountPercent * ( FeePercent * (@CurrentTransferContributions + @CurrentLumpSumContributions) )))),
InitialChargeOnRegular = ( FeePercent * @CurrentRegularContributions * InitialPeriod ) - ( DiscountPercent * FeePercent * @CurrentRegularContributions * InitialPeriod ) + ( VATPercent * (( FeePercent * @CurrentRegularContributions * InitialPeriod ) - ( DiscountPercent * FeePercent * @CurrentRegularContributions * InitialPeriod )))
where FeeChargingTypeId not in (8,9,10) 


update @Charges     
set InitialCharge = ( FeePercent * ContributionAmount * InitialPeriod ) - ( DiscountPercent * FeePercent * ContributionAmount * InitialPeriod ) + ( VATPercent * (( FeePercent * ContributionAmount * InitialPeriod ) - ( DiscountPercent * FeePercent * ContributionAmount * InitialPeriod )))    
where FeeChargingTypeId = 8  
      
update @Charges  
set InitialCharge = (FeePercent * ContributionAmount) - ( DiscountPercent * ( FeePercent * ContributionAmount )) + ( VATPercent * (( FeePercent * ContributionAmount ) - ( DiscountPercent * ( FeePercent * ContributionAmount ))))    
where FeeChargingTypeId in (9,10)  
--------------------------------------------------------    


   
select 1 as tag,        
null as parent,        
@PolicyBusinessId as [Charges!1!PolicyBusinessId],        
null as [PlanInitialCharges!2!FeeId],        
null as [PlanInitialCharges!2!FeeChargingTypeId],    
null as [PlanInitialCharges!2!InitialChargePercent],        
null as [PlanInitialCharges!2!NetFeeAmount],        
null as [PlanInitialCharges!2!VATAmount],        
null as [PlanInitialCharges!2!Discounts],        
null as [PlanInitialCharges!2!TotalFeeAmount],          
null as [PlanInitialCharges!2!TotalInitialCharge],        
null as [PlanInitialCharges!2!TotalInitialChargeOnLumpSum],    
null as [PlanInitialCharges!2!TotalInitialChargeOnRegular], 
null as [PlanInitialCharges!2!InitialChargeDiscountPercent],       
null as [PlanInitialCharges!2!InitialChargeDiscountAmount],      
null as [PlanInitialCharges!2!InitialChargeDiscountReason],      
null as [PlanInitialCharges!2!ContributionAmount],    
null as [PlanOngoingCharges!3!FeeId],        
null as [PlanOngoingCharges!3!OngoingChargePercent]          
        
UNION         
    
    
select        
2 as tag,        
1 as parent,        
@PolicyBusinessId as [PlanInitialCharges!2!PolicyBusinessId],        
c.FeeId as [PlanInitialCharges!2!FeeId],   
c.FeeChargingTypeId,  
c.FeePercent as  [PlanInitialCharges!2!InitialChargePercent],        
c.NetFeeAmount as [PlanInitialCharges!2!NetFeeAmount],    
c.VATAmount as [PlanInitialCharges!2!VATAmount],        
c.TOtalDiscountAmount as [PlanInitialCharges!2!Discounts],     
case     
 when ISNULL(c.FeePercent,0) = 0 then FeeNetAmount + FeeVatAmount    
 else c.TotalFeeAmount     
end as [PlanInitialCharges!2!TotalFeeAmount],    
case     
 when ISNULL(c.FeePercent,0) = 0 then null    
 else c.InitialCharge    
end as [PlanInitialCharges!2!TotalInitialCharge], 
isnull(c.InitialChargeOnLumpSum,0),
isnull(c.InitialChargeOnRegular,0),       
c.DiscountPercent,    
isnull(c.DiscountAmount,0),
c.DiscountReason,    
isnull(c.ContributionAmount, 0),
null,    
null    
from @Charges c     
      
UNION        
        
select        
3 as tag,        
1 as parent,        
@PolicyBusinessId as [PlanOngoingCharges!3!PolicyBusinessId],        
null,        
null,        
null,        
null,        
null,  
null,        
null,          
null,        
null,       
null,          
null,       
null,          
null,        
null,       
f.FeeId as [PlanOngoingCharges!3!FeeId],        
afcd.PercentageOfFee/100 as [PlanOngoingCharges!3!InitialChargePercent]        
        
from TFee f         
join (        
 select MAX(f.feeid) as FeeId        
 from TFee f        
 join TFeeRetainerOwner fro on fro.FeeId = f.feeid        
 join TAdviseFeeType aft on aft.AdviseFeeTypeId = f.AdviseFeeTypeId        
 join TRefAdviseFeeType raft on raft.RefAdviseFeeTypeId = aft.RefAdviseFeeTypeId and raft.Name = 'On-going Fee'         
 join TFee2Policy f2p on f2p.FeeId = f.FeeId and f2p.PolicyBusinessId = @PolicyBusinessID        
) maxFee on maxFee.FeeId = f.FeeId        
join TAdviseFeeChargingDetails afcd on afcd.AdviseFeeChargingDetailsId = f.AdviseFeeChargingDetailsId        
        
FOR XML EXPLICIT

END