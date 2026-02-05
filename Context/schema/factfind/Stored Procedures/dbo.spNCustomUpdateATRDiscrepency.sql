SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[spNCustomUpdateATRDiscrepency]    
    
@CRMContactId bigint,    
@StampUser varchar(255),    
@IsInvestment bit, --indicates whether this is investment or retirement    
@CalculatedRiskGuid uniqueidentifier --update to Clients risk    
    
    
as    
    
declare @AtrRefProfilePreferenceId int,    
  @CalculatedRisk int  ,  
  @selectedRisk int,   
  @selectedRiskGuid uniqueidentifier  
    
select @AtrRefProfilePreferenceId = AtrRefProfilePreferenceId     
         from TATRTemplateSetting a    
         inner join TATRTemplate b on b.atrtemplateid = a.atrtemplateid    
         inner join crm..TCRMContact c on c.indclientid = b.indigoclientid    
         where crmcontactid = @CRMContactId and    
           Active = 1    
    
select @CalculatedRisk = RiskNumber from policymanagement..TRiskProfileCombined where [guid] = @CalculatedRiskGuid    
    
    
--if risk is set at client level then update all objectives    
if(@AtrRefProfilePreferenceId =1 or @IsInvestment = 1) begin    
    
    
 --if the client has disagreed with the generated profile reset the discrepency and end  
 if(select Client1AgreesWithProfile from TATRInvestmentGeneral where crmcontactid = @crmcontactid) = 0   
 begin  
    
 select @selectedRiskGuid = Client1ChosenProfileGuid   
         from TATRInvestmentGeneral  
         where crmcontactid = @CRMContactId  
    
 select @selectedRisk = risknumber from policymanagement..TRiskProfileCombined r where r.guid = @selectedRiskGuid  
 select @calculatedRisk = risknumber from policymanagement..TRiskProfileCombined r where r.guid = @CalculatedRiskGuid  
   
    
 update i  
 set  i.RiskDiscrepency = @calculatedRisk - @selectedRisk  
 from  TATRInvestmentGeneral   i
 where crmcontactid = @CRMContactId  
    
 return  
end  
     
 update  o    
 set  --o.RiskProfileAdjustedDate = getdate(),    
   o.RiskDiscrepency = case when isnull(cast(RiskProfileGuid as varchar(50)),'') = '' then 0    
         else @CalculatedRisk - risknumber     
         end    
 from TObjective o    
 left join policymanagement..TRiskProfileCombined r on r.guid = RiskProfileGuid    
 where o.CRMContactId = @CRMContactId and    
   ((objectiveTypeId = 1 and @IsInvestment = 1) or @AtrRefProfilePreferenceId = 1)    
    
end   
else begin -- risk set at retirement and investment level  
--if the client has disagreed with the generated profile then fall out here.    
 if(select Client1AgreesWithProfile from TATRRetirementGeneral where crmcontactid = @crmcontactid) = 0    
 return     
     
 update  o    
 set  --o.RiskProfileAdjustedDate = getdate(),    
   o.RiskDiscrepency = case when isnull(cast(RiskProfileGuid as varchar(50)),'') = '' then 0    
         else @CalculatedRisk - risknumber     
         end    
 from TObjective o    
 left join policymanagement..TRiskProfileCombined r on r.guid = RiskProfileGuid    
 where o.CRMContactId = @CRMContactId and    
  objectiveTypeId = 2    
    
end   
GO
