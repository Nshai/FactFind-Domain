CREATE PROCEDURE [dbo].[SpNCustomRetrievePartyLiabilities] 
(
  @CRMContactId BIGINT,                            
  @CRMContactId2 BIGINT,                       
  @TenantId bigint
)
As

--DECLARE @CRMContactId BIGINT = 4670733
--DECLARE @CRMContactId2 BIGINT = 4670731
--DECLARE @TenantId BIGINT = 10155


SELECT distinct liability.LiabilitiesId     LiabilityId     
,               ISNULL(owner1.CorporateName, (cast(owner1.FirstName as NVARCHAR(255)) + ' '+ 
											  cast(owner1.LastName as NVARCHAR(255))))   [Owner]                     
,               liability.LiabilityAccountNumber 
,               liability.CommitedOutgoings      
,               liability.Description            
,               liability.TotalLoanAmount        
,               liability.repayorinterest       
,               liability.Amount                 
,               liability.InterestRate           
,               liability.PaymentAmountPerMonth  
,               liability.LenderName             
,               liability.OriginalTerm           
,               liability.EndDate                
,               liability.Protected              
,               liability.EarlyRedemptionCharge  
,               liability.IsConsolidated         
,               liability.IsToBeRepaid           
,               liability.HowWillItBeRepaid      
,               liability.CreditLimit
,				liability.IsGuarantorMortgage       
,				liability.InterestRateType RateType       
FROM   FactFind.dbo.TLiabilities liability
       inner join CRM.dbo.TCRMContact owner1
         on liability.CRMContactId = owner1.CRMContactId      
		  
WHERE  liability.CRMContactId in (@CRMContactId, @CRMContactId2)
         and ISNULL(liability.CRMContactId2, 0) = 0

UNION 

SELECT distinct liability.LiabilitiesId          
,                cast('Joint' as NVARCHAR(255)) [Owner]                    
,               liability.LiabilityAccountNumber 
,               liability.CommitedOutgoings      
,               liability.Description            
,               liability.TotalLoanAmount        
,               liability.repayorinterest       
,               liability.Amount                 
,               liability.InterestRate           
,               liability.PaymentAmountPerMonth  
,               liability.LenderName             
,               liability.OriginalTerm           
,               liability.EndDate                
,               liability.Protected              
,               liability.EarlyRedemptionCharge  
,               liability.IsConsolidated         
,               liability.IsToBeRepaid           
,               liability.HowWillItBeRepaid      
,               liability.CreditLimit            
,				liability.IsGuarantorMortgage  
,				liability.InterestRateType RateType        
FROM   FactFind.dbo.TLiabilities liability      
WHERE  liability.CRMContactId = @CRMContactId
         and liability.CRMContactId2 = @CRMContactId2

UNION 

SELECT distinct liability.LiabilitiesId          
,               cast('Joint' as NVARCHAR(255)) [Owner]                        
,               liability.LiabilityAccountNumber 
,               liability.CommitedOutgoings      
,               liability.Description            
,               liability.TotalLoanAmount        
,               liability.repayorinterest       
,               liability.Amount                 
,               liability.InterestRate           
,               liability.PaymentAmountPerMonth  
,               liability.LenderName             
,               liability.OriginalTerm           
,               liability.EndDate                
,               liability.Protected              
,               liability.EarlyRedemptionCharge  
,               liability.IsConsolidated         
,               liability.IsToBeRepaid           
,               liability.HowWillItBeRepaid      
,               liability.CreditLimit            
,				liability.IsGuarantorMortgage  
,				liability.InterestRateType RateType       
FROM   FactFind.dbo.TLiabilities liability       
WHERE  liability.CRMContactId = @CRMContactId2 And liability.CRMContactId2= @CRMContactId
