SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[spNCustomUpdatePlanForActionPlan] @ActionPlanId bigint, @Stampuser varchar(99)  
  
as  
  
declare @PolicyBusinessId bigint  
declare @PolicyDetailId bigint -- NEEDED FOR TOPUPS
  
select @PolicyBusinessId = MasterPolicyBusinessId from TActionPlandn where actionplanid = @ActionPlanId  
SELECT @PolicyDetailId = PolicyDetailId FROM policymanagement..TPolicyBusiness with (nolock) where PolicyBusinessId = @PolicyBusinessId

  
--Fund Proposals  
insert into policymanagement..TFundProposalAudit  
(PolicyBusinessId,FundUnitId,IsFromSeed,Percentage,TenantId, RegularContributionPercentage, ConcurrencyId,FundProposalId,StampAction,StampDateTime,StampUser)  
select PolicyBusinessId,FundUnitId,IsFromSeed,Percentage,TenantId, RegularContributionPercentage,ConcurrencyId,FundProposalId,'D',getdate(),@stampuser  
from policymanagement..TFundProposal where policybusinessid = @PolicyBusinessId  
  
delete from policymanagement..TFundProposal where policybusinessid = @PolicyBusinessId  
  
  
insert into policymanagement..TFundProposal  
(PolicyBusinessId,FundUnitId,IsFromSeed,Percentage,TenantId, RegularContributionPercentage,ConcurrencyId)  
  
select masterpolicybusinessid, isnull(Fundunitid,d.fundid),isnull(fromfeedfg,1), PercentageAllocation,indclientid, b.RegularContributionPercentage,1  
from TActionPlandn a  
inner join TActionFund b on b.actionplanid = a.actionplanid  
inner join crm..TCRMContact c on c.crmcontactid = a.owner1  
left join policymanagement..TPolicyBusinessFund d on d.policybusinessfundid = b.policybusinessFundId  
where a.actionplanid = @ActionPlanId and (b.percentageallocation > 0 or b.RegularContributionPercentage > 0)
  
  
--Withdrawals - annual  
insert into policymanagement..TPolicyMoneyOut  
(PolicyBusinessId,Amount,PaymentStartDate,RefFrequencyId,RefWithdrawalTypeId,ConcurrencyId)  
select masterpolicybusinessid,  
  AnnualWithdrawal,  
  getdate(),  
  8,  
  1,  
  1  
from TActionPlandn  
where actionplanid = @ActionPlanId  and AnnualWithdrawal > 0
  
insert into policymanagement..TPolicyMoneyOutAudit  
(PolicyMoneyOutId,PolicyBusinessId,Amount,PaymentStartDate,RefFrequencyId,RefWithdrawalTypeId,ConcurrencyId,StampAction,StampDateTime,StampUser)  
select   
PolicyMoneyOutId ,PolicyBusinessId,Amount,PaymentStartDate,RefFrequencyId,RefWithdrawalTypeId,ConcurrencyId,'C',getdate(),@stampuser  
from policymanagement..TPolicyMoneyOut  
where PolicyMoneyOutId = SCOPE_IDENTITY()  
  
  
--Withdrawal single  
insert into policymanagement..TPolicyMoneyOut  
(PolicyBusinessId,Amount,PaymentStartDate,RefFrequencyId,RefWithdrawalTypeId,ConcurrencyId)  
select masterpolicybusinessid,  
  -SingleLumpSum,  
  getdate(),  
  10,  
  2,  
  1  
from TActionPlandn  
where actionplanid = @ActionPlanId  and singlelumpsum < 0
  
insert into policymanagement..TPolicyMoneyOutAudit  
(PolicyMoneyOutId,PolicyBusinessId,Amount,PaymentStartDate,RefFrequencyId,RefWithdrawalTypeId,ConcurrencyId,StampAction,StampDateTime,StampUser)  
select   
PolicyMoneyOutId ,PolicyBusinessId,Amount,PaymentStartDate,RefFrequencyId,RefWithdrawalTypeId,ConcurrencyId,'C',getdate(),@stampuser  
from policymanagement..TPolicyMoneyOut 
where PolicyMoneyOutId = SCOPE_IDENTITY()  
   
  
--contributions monthly.    
--Need to take in to account any existing active self frequent contributions  
declare @policyMoneyIn bigint   
  
select @policyMoneyIn = PolicyMoneyInId  
      from policymanagement..TPolicyMoneyIn a  
      inner join policymanagement..TRefFrequency b on b.reffrequencyid = a.reffrequencyid  
      inner join policymanagement..TRefContributionType c on c.refcontributiontypeid = a.refcontributiontypeid  
      inner join policymanagement..TRefContributorType d on d.refcontributortypeid = a.refcontributortypeid  
      where PolicyBusinessId = @PolicyBusinessId and  
        FrequencyName != 'Single' and  
        RefContributionTypeName = 'Regular' and  
        RefContributorTypeName = 'Self' and  
        --check that it's still active  
        (StopDate is null or StopDate > getdate()) 
        
       
        
         
     
if(isnull(@policyMoneyIn,0) = 0) begin  
   
 insert into policymanagement..TPolicyMoneyIn  
 (Amount,RefFrequencyId,StartDate,PolicyBusinessId,CurrentFg,RefContributionTypeId,RefContributorTypeId,ConcurrencyId)  
 select MonthlyContribution,4,getdate(),masterpolicybusinessid,1,1,1,1  
 from TActionPlandn  
 where actionplanid = @ActionPlanId  and MonthlyContribution >0
  
 insert into policymanagement..TPolicyMoneyInAudit  
 (PolicyMoneyInId,Amount,RefFrequencyId,StartDate,PolicyBusinessId,CurrentFg,RefContributionTypeId,RefContributorTypeId,ConcurrencyId,StampAction,StampDateTime,StampUser)  
 select   
 PolicyMoneyInId,Amount,RefFrequencyId,StartDate,PolicyBusinessId,CurrentFg,RefContributionTypeId,RefContributorTypeId,ConcurrencyId,'C',getdate(),@stampuser  
 from policymanagement..TPolicyMoneyIn  
 where PolicyMoneyInId = SCOPE_IDENTITY()  
  
end  
else begin   
  
 -- stop existing and add a new one which combines both  
 exec policymanagement..spNAuditPolicyMoneyIn @stampuser,@policyMoneyIn,'U'  
   
 declare @RefFrequencyId int,  
   @Amount money,  
   @NewAmount money
   
 select   
 @RefFrequencyId = RefFrequencyId,   
 @Amount = amount   
 from policymanagement..TPolicyMoneyIn where policymoneyinid = @policyMoneyIn  
  
 --calculate the factor for the new money  
 select @NewAmount = CASE           
     when  @RefFrequencyId=1 then MonthlyContribution / 4                
     when  @RefFrequencyId=2 then MonthlyContribution / 2  
     when  @RefFrequencyId=3 then MonthlyContribution  
     when  @RefFrequencyId=4 then MonthlyContribution  
     when  @RefFrequencyId=5 then MonthlyContribution * 3  
     when  @RefFrequencyId=7 then MonthlyContribution * 6     
     when  @RefFrequencyId=8 then MonthlyContribution * 12  
     else 0 END  
 from TActionPlandn  
 where actionplanid = @ActionPlanId  
   
	 if(@Amount != @NewAmount) 
	 begin  
		 ---stop the current  
		 update a  
		 set  stopdate = DATEADD(D,-1, getdate() ), CurrentFg = 0
		 from policymanagement..TPolicyMoneyIn a  
		 where policymoneyinid = @policyMoneyIn  
		 
		 if( @NewAmount > 0)
		 begin
		       
			 insert into policymanagement..TPolicyMoneyIn  
			 (Amount,RefFrequencyId,StartDate,PolicyBusinessId,CurrentFg,RefContributionTypeId,RefContributorTypeId,ConcurrencyId)  
			 select @NewAmount,@RefFrequencyId,getdate(),masterpolicybusinessid,1,1,1,1  
			 from TActionPlandn  
			 where actionplanid = @ActionPlanId  
			  
			 insert into policymanagement..TPolicyMoneyInAudit  
			 (PolicyMoneyInId,Amount,RefFrequencyId,StartDate,PolicyBusinessId,CurrentFg,RefContributionTypeId,RefContributorTypeId,ConcurrencyId,StampAction,StampDateTime,StampUser)  
			 select   
			 PolicyMoneyInId,Amount,RefFrequencyId,StartDate,PolicyBusinessId,CurrentFg,RefContributionTypeId,RefContributorTypeId,ConcurrencyId,'C',getdate(),@stampuser  
			 from policymanagement..TPolicyMoneyIn  
			 where PolicyMoneyInId = SCOPE_IDENTITY()
			 
			 --Audit the TPolicyBusiness record before update
			exec policymanagement..SpNAuditPolicyBusiness @stampuser, @PolicyBusinessId, 'U'  

			--Update the TPolicyBusiness record as it shows the contributions on the summary
			update policymanagement..TPolicyBusiness
			set TotalRegularPremium = @NewAmount, PremiumType = 'Montly', ConcurrencyId = ConcurrencyId + 1
			where PolicyBusinessId = @PolicyBusinessId
			
			
			-- Stop the TOPUPS' CONTRIBUTIONS TOO
			SELECT PolicyMoneyInId , PB.PolicyBusinessId
			into #tempTopUpsPolicyContributions
			from policymanagement..TPolicyMoneyIn a  
			INNER JOIN policymanagement..TRefFrequency b on b.reffrequencyid = a.reffrequencyid  
			INNER JOIN policymanagement..TRefContributionType c on c.refcontributiontypeid = a.refcontributiontypeid  
			INNER JOIN policymanagement..TRefContributorType d on d.refcontributortypeid = a.refcontributortypeid  
			INNER JOIN policymanagement..TPolicyBusiness PB ON a.PolicyBusinessId = PB.PolicyBusinessId
			INNER JOIN policymanagement..TStatusHistory SH WITH (NOLOCK) ON SH.PolicyBusinessId = PB.PolicyBusinessId AND CurrentStatusFg = 1
			INNER JOIN policymanagement..TStatus S WITH (NOLOCK) ON S.StatusId = SH.StatusId AND S.IntelligentOfficeStatusType = 'In force'
			WHERE
				-- make sure that supplied plan is NOT the main policy record but has the same policyDetail ID, hence a TOPUP
				Pb.PolicyDetailId = @PolicyDetailId
				AND PB.PolicyBusinessId != @PolicyBusinessId
				AND         FrequencyName != 'Single' and  
					RefContributionTypeName = 'Regular' and  
					RefContributorTypeName = 'Self' and  
					--check that it's still active  
					(StopDate is null or StopDate > getdate())

			-- AUDIT TopUP contributions
			INSERT INTO policymanagement..TPolicyMoneyInAudit
				(Amount, EscalationPercentage, RefFrequencyId, StartDate,
				PolicyBusinessId, RefTaxBasisId, RefTaxYearId, RefContributionTypeId,
				RefContributorTypeId, CurrentFg, RefEscalationTypeId, SalaryPercentage,
				StopDate, ConcurrencyId, PolicyMoneyInId, StampAction, StampDateTime, StampUser,
				IsInitialFee, IsOngoingFee, IsFullTransfer, RefTransferTypeId)
			SELECT Amount, EscalationPercentage, RefFrequencyId, StartDate,
				PolicyBusinessId, RefTaxBasisId, RefTaxYearId, RefContributionTypeId,
				RefContributorTypeId, CurrentFg, RefEscalationTypeId, SalaryPercentage,
				StopDate, ConcurrencyId, PolicyMoneyInId, 'U', GetDate(), @StampUser,
				IsInitialFee, IsOngoingFee, IsFullTransfer, RefTransferTypeId
			FROM policymanagement..TPolicyMoneyIn
			WHERE PolicyMoneyInId in (select PolicyMoneyInId from #tempTopUpsPolicyContributions)

			-- Update the main table for topups and stop all its contributions
			update a
			 set  stopdate = DATEADD(D,-1, getdate() ), CurrentFg = 0
			 from policymanagement..TPolicyMoneyIn a  
			 JOIN #tempTopUpsPolicyContributions b ON a.PolicyMoneyInId = b.PolicyMoneyInId

			-- If we have updated the plan's contribution and the topups contribution then we need to change the plancontribution amount field in action plan too
			-- Audit first
			exec spNAuditActionPlan @StampUser,@ActionPlanId,'U' 
			-- Update the contribution field
			update TACtionPlan      
			set PlanContributionAmount = @NewAmount
			where ActionPlanId = @ActionPlanId      
			
		end
	end
end   
  
--Contribution lump sum
 insert into policymanagement..TPolicyMoneyIn  
 (Amount,RefFrequencyId,StartDate,PolicyBusinessId,CurrentFg,RefContributionTypeId,RefContributorTypeId,ConcurrencyId)  
 select SingleLumpSum,10,getdate(),masterpolicybusinessid,0,2,1,1  
 from TActionPlandn  
 where actionplanid = @ActionPlanId  and singlelumpsum > 0
  
 insert into policymanagement..TPolicyMoneyInAudit  
 (PolicyMoneyInId,Amount,RefFrequencyId,StartDate,PolicyBusinessId,CurrentFg,RefContributionTypeId,RefContributorTypeId,ConcurrencyId,StampAction,StampDateTime,StampUser)  
 select   
 PolicyMoneyInId,Amount,RefFrequencyId,StartDate,PolicyBusinessId,CurrentFg,RefContributionTypeId,RefContributorTypeId,ConcurrencyId,'C',getdate(),@stampuser  
 from policymanagement..TPolicyMoneyIn  
 where PolicyMoneyInId = SCOPE_IDENTITY()
GO
