SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomRetrieveExistingPolicyBusiness]
@IndigoClientId bigint,
@RefProdProviderId bigint,
@ClientCRMContactId bigint,
@PolicyNumber varchar (50)  
AS  
  
--Used in LIO to check if a sub plan exists or should it be added
  
BEGIN  
  SELECT  
    1 AS Tag,  
    NULL AS Parent,  
    T1.PolicyBusinessId AS [PolicyBusiness!1!PolicyBusinessId],   
    T1.PolicyDetailId AS [PolicyBusiness!1!PolicyDetailId],   
    ISNULL(T1.PolicyNumber, '') AS [PolicyBusiness!1!PolicyNumber],   
    T1.PractitionerId AS [PolicyBusiness!1!PractitionerId],   
    T1.AdviceTypeId AS [PolicyBusiness!1!AdviceTypeId],   
    T1.IndigoClientId AS [PolicyBusiness!1!IndigoClientId],   
    ISNULL(T1.ProductName, '') AS [PolicyBusiness!1!ProductName],   
    ISNULL(T1.SequentialRef, '') AS [PolicyBusiness!1!SequentialRef],   
    T1.ConcurrencyId AS [PolicyBusiness!1!ConcurrencyId]

  From PolicyManagement..TPolicyBusiness T1 WITH(NOLOCK)
  --Check Owner
  Inner Join PolicyManagement..TPolicyDetail T2 WITH(NOLOCK) On T1.PolicyDetailId = T2.PolicyDetailId
  Inner Join PolicyManagement..TPolicyOwner T3 WITH(NOLOCK) On T3.PolicyDetailId = T2.PolicyDetailId
  --Check Provider
  Inner Join PolicyManagement..TPlanDescription T4 WITH(NOLOCK) On T2.PlanDescriptionId = T4.PlanDescriptionId           
  Inner Join PolicyManagement..TRefProdProvider T5 WITH(NOLOCK) On T4.RefProdProviderId = T5.RefProdProviderId        
  --Check Status
  Inner Join TStatusHistory T8 WITH(NOLOCK) On T1.PolicyBusinessId = T8.PolicyBusinessId AND T8.CurrentStatusFG = 1      
  Inner Join TStatus T9 WITH(NOLOCK) On T8.StatusId = T9.StatusId      
   AND T9.IntelligentOfficeStatusType != 'Deleted'        
       
  Where T1.IndigoClientId = @IndigoClientId And T1.PolicyNumber = @PolicyNumber
    And T5.RefProdProviderId = @RefProdProviderId  --get results for selected providers only
    And T3.CRMContactId = @ClientCRMContactId --get results for the main client
  
  ORDER BY [PolicyBusiness!1!PolicyBusinessId]  
  
  FOR XML EXPLICIT  
  
END  
RETURN (0)  
GO
