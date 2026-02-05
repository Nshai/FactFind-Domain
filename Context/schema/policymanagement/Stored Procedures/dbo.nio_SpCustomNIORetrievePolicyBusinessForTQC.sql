SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_SpCustomNIORetrievePolicyBusinessForTQC]    
   @TenantId bigint, @TnCCoachId bigint        
    
with recompile    
    
AS        
      
   
      
SELECT                   
 Pb.PolicyBusinessId , 
 Pb.PolicyDetailId,  
 Pb.PolicyNumber,
 Pb.PractitionerId,
 Pb.ReplaceNotes,
 Pb.TnCCoachId,
 Pb.AdviceTypeId,
 Pb.BestAdvicePanelUsedFG,
 Pb.WaiverDefermentPeriod,
 Pb.IndigoClientId,
 Pb.SwitchFG,
 Pb.TotalRegularPremium,
 Pb.TotalLumpSum,
 Pb.MaturityDate,
 Pb.LifeCycleId,
 Pb.PolicyStartDate,
 Pb.PremiumType, 
 Pb.AgencyNumber, 
 Pb.ProviderAddress,
 Pb.OffPanelFg,
 Pb.BaseCurrency,
 Pb.ExpectedPaymentDate,
 Pb.ProductName, 
 Pb.InvestmentTypeId,
 Pb.RiskRating,
 Pb.SequentialRef,
 Pb.ConcurrencyId,
 A.CRMContactId AS 'AdviserCRMContactId',
 Usr.CRMContactId AS 'TnCCoachCRMContactId' 
 --CASE ISNULL(TopUp.MinPb,0) WHEN 0 THEN 0 ELSE 1 END AS IsTopUp,  
 
      
FROM Compliance..TTnCCoach TnC 
JOIN Administration..TUser Usr ON TnC.UserId=Usr.UserId          
JOIN TPolicyBusiness Pb ON Pb.TnCCoachId = TnC.TnCCoachId And Pb.IndigoClientId = @TenantId        
JOIN TPolicyDetail Pd ON Pd.PolicyDetailId = Pb.PolicyDetailId          
JOIN TStatusHistory Sh ON Sh.PolicyBusinessId = Pb.PolicyBusinessId AND Sh.CurrentStatusFG = 1    
JOIN TStatus Stat ON Sh.StatusId=Stat.StatusId AND Stat.IntelligentOfficeStatusType='Submitted To T AND C'    
 -- Adviser          
 JOIN [CRM].[dbo].TPractitioner A ON A.PractitionerId = Pb.PractitionerId             
 -- For topups          
 LEFT JOIN         
 (          
	SELECT PolicyDetailId, MIN(PolicyBusinessId) 'MinPB'
	  FROM TPolicyBusiness
      Where IndigoClientId =@TenantId        
      GROUP BY PolicyDetailId   
      HAVING COUNT(PolicyBusinessId)>1
   ) TopUp ON Pd.PolicyDetailId = TopUp.PolicyDetailId     
--Has it been delete from the proposals queue?  
LEFT JOIN  
(  
 SELECT PolicyBusinessId,FileCheckMiniId  
 FROM Compliance..TFileCheckMini WITH(NOLOCK)  
 WHERE IsPreSale=1  
 AND IsArchived=1  
 AND Status='Not Checked'  
) FCM ON Pb.PolicyBusinessId=FCM.PolicyBusinessId  
WHERE Usr.CRMContactId = @TnCCoachId            
AND ISNULL(FCM.FileCheckMiniId,0)=0  
AND Usr.IndigoClientId=@TenantId
GO
