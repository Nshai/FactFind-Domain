SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[spNCustomUpdateClientATRDiscrepency]
 @CRMContactId bigint,
 @StampUser varchar(50),
 @IsInvestment bit,
 @SelectedProfile uniqueidentifier,
 @ClientAgrees bit
 
 as
 
declare @AtrRefProfilePreferenceId int,        
		@selectedProfileRisk int,
		@calculatedRisk int,
		@chosenRiskGuid uniqueidentifier,
		@chosenRiskNumber int
      
select @AtrRefProfilePreferenceId = AtrRefProfilePreferenceId       
         from TATRTemplateSetting a      
         inner join TATRTemplate b on b.atrtemplateid = a.atrtemplateid      
         inner join crm..TCRMContact c on c.indclientid = b.indigoclientid      
         where crmcontactid = @CRMContactId and      
           Active = 1      
      
select @selectedProfileRisk = RiskNumber from policymanagement..TRiskProfileCombined where [guid] = @SelectedProfile      
      
      
--if risk is set at client level then update all objectives      
if(@AtrRefProfilePreferenceId =1 or @IsInvestment = 1) begin      
      
      
 --if the client has agreed with the generated profile reset the discrepency and datestampl the change
	if(@ClientAgrees =1) begin    		      		     		      
		update i    
		set  i.RiskDiscrepency = 0,
		i.RiskProfileAdjustedDate = getdate()
		from  TATRInvestmentGeneral   i  
		where crmcontactid = @CRMContactId    
	end else begin
		--calculate the difference between the calculated and selected
		select @calculatedRisk =	isnull(RiskNumber ,0)
									from TATRInvestmentGeneral a 
									inner join policymanagement..TRiskProfileCombined b on b.[guid] = a.CalculatedRiskProfile
									where a.crmcontactid = @crmcontactid
		
		--set the client level discrepency and datestamp the change
		update i    
		set  i.RiskDiscrepency = @calculatedRisk - @selectedProfileRisk,
		i.RiskProfileAdjustedDate = getdate()
		from  TATRInvestmentGeneral   i  
		where crmcontactid = @CRMContactId 																		
	end
	    
	--update the objectives discrepency based on the selected or chosen guid
	select @chosenRiskGuid = case when Client1AgreesWithProfile = 1 then CalculatedRiskProfile else Client1ChosenProfileGuid end  
								from TATRInvestmentGeneral where crmcontactid = @crmcontactid
								
	select @chosenRiskNumber = isnull(RiskNumber,0) from policymanagement..TRiskProfileCombined where [guid] = @chosenRiskGuid     
	   
	update  o      
	set		o.RiskDiscrepency = case when isnull(cast(RiskProfileGuid as varchar(50)),'') = '' then 0      
			else @chosenRiskNumber - risknumber       
			end      
	from TObjective o      
	left join policymanagement..TRiskProfileCombined r on r.guid = RiskProfileGuid      
	where o.CRMContactId = @CRMContactId and      
	((objectiveTypeId = 1 and @IsInvestment = 1) or @AtrRefProfilePreferenceId = 1)            
  
      
end     
else begin -- risk set at retirement and investment level    

  --if the client has agreed with the generated profile reset the discrepency
	if(@ClientAgrees =1) begin    		      		     		      
		update i    
		set  i.RiskDiscrepency = 0,
		i.RiskProfileAdjustedDate = getdate()
		from  TATRRetirementGeneral   i  
		where crmcontactid = @CRMContactId    
	end else begin
	--calculate the difference between the calculated and selected
		select @calculatedRisk =	isnull(RiskNumber ,0)
									from TATRRetirementGeneral a 
									inner join policymanagement..TRiskProfileCombined b on b.[guid] = a.CalculatedRiskProfile
									where a.crmcontactid = @crmcontactid
		
		--set the client level discrepency and datestamp the change
		update i    
		set  i.RiskDiscrepency = @calculatedRisk - @selectedProfileRisk,
		i.RiskProfileAdjustedDate = getdate()
		from  TATRRetirementGeneral   i  
		where crmcontactid = @CRMContactId 				
	
	end       
       
     --update the objectives discrepency based on the selected or chosen guid
	select @chosenRiskGuid = case when Client1AgreesWithProfile = 1 then CalculatedRiskProfile else Client1ChosenProfileGuid end  
								from TATRRetirementGeneral where crmcontactid = @crmcontactid
								
	select @chosenRiskNumber = isnull(RiskNumber,0) from policymanagement..TRiskProfileCombined where [guid] = @chosenRiskGuid     
	   
	update  o      
	set		o.RiskDiscrepency = case when isnull(cast(RiskProfileGuid as varchar(50)),'') = '' then 0      
			else @chosenRiskNumber - risknumber       
			end      
	from TObjective o      
	left join policymanagement..TRiskProfileCombined r on r.guid = RiskProfileGuid      
	where o.CRMContactId = @CRMContactId and objectiveTypeId = 2

end 
 
GO
