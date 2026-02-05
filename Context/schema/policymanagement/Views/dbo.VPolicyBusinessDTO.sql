SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[VPolicyBusinessDTO]  
  
AS  
  
SELECT  
 PB.*,  
 PO.CRMContactId AS PolicyOwnerCRMContactId,  
 P.CRMContactId AS AdviserCRMContactId,  
 U.CRMContactId AS TnCCoachCRMContactId,  
 PDesc.RefPlanType2ProdSubTypeId,  
 adviceType.[Description] as AdviceTypeName,
 C.CorporateName AS ProviderName,  
 SH.ChangedToDate AS SubmittedToProviderDate, 
 STAT.[Name] AS CurrentStatus,
 CASE 
	WHEN TopUp.MinPolicyBusinessId=TopUp.MaxPolicyBusinessId THEN 0
	ELSE 1
END AS IsTopUp
	
	
FROM  
 PolicyManagement..TPolicyBusiness PB  
 JOIN PolicyManagement..TPolicyDetail PD ON PD.PolicyDetailId = PB.PolicyDetailId  
 JOIN (
	SELECT MIN(PolicyBusinessId) AS MinPolicyBusinessId,MAX(PolicyBusinessId) AS MaxPolicyBusinessId,A.PolicyDetailId
	FROM TPolicyDetail A
	JOIN TPolicyBusiness B ON A.PolicyDetailId=B.PolicyDetailId
	GROUP BY A.PolicyDetailId) TopUp ON PD.PolicyDetailId=TopUp.PolicyDetailId
 JOIN   
  (  
   SELECT  
    PolicyDetailId,  
    Min(PolicyOwnerId) AS PolicyOwnerId  
   FROM  
    PolicyManagement..TPolicyOwner  
   GROUP BY  
    PolicyDetailId  
  ) FirstPO ON FirstPO.PolicyDetailId = PB.PolicyDetailId  
 JOIN PolicyManagement..TPolicyOwner PO ON PO.PolicyOwnerId = FirstPO.PolicyOwnerId
 JOIN PolicyManagement..TPlanDescription PDesc ON PDesc.PlanDescriptionId = PD.PlanDescriptionId  
 JOIN PolicyManagement..TRefProdProvider Prod ON Prod.RefProdProviderId = PDesc.RefProdProviderId  
 JOIN CRM..TCRMContact C ON C.CRMContactId = Prod.CRMContactId  
 JOIN CRM..TPractitioner P ON P.PractitionerId = PB.PractitionerId   
 LEFT JOIN Compliance..TTnCCoach TnC ON TnC.TnCCoachId = PB.TnCCoachId   
 LEFT JOIN Administration..TUser U ON U.UserId = TnC.UserId  
 LEFT JOIN  
  (  
   SELECT  
    PolicyBusinessId,  
    MAX(StatusHistoryId) AS StatusHistoryId  
   FROM  
    PolicyManagement..TStatusHistory SH  
    JOIN PolicyManagement..TStatus S ON S.StatusId = SH.StatusId AND S.IntelligentOfficeStatusType = 'Submitted To Provider'  
   GROUP BY  
    PolicyBusinessId  
  ) TnCSubmit ON TnCSubmit.PolicyBusinessId = PB.PolicyBusinessId  
 LEFT JOIN PolicyManagement..TStatusHistory SH ON SH.StatusHistoryId = TnCSubmit.StatusHistoryId 
 JOIN PolicyManagement..TStatusHistory CS ON Cs.PolicyBusinessId=PB.PolicyBusinessId AND CS.CurrentStatusFG=1
 JOIN PolicyManagement..TStatus STAT ON CS.StatusId=STAT.StatusId
 JOIN policymanagement..TAdviceType adviceType ON pb.AdviceTypeId = adviceType.AdviceTypeId
   
  
  
GO
