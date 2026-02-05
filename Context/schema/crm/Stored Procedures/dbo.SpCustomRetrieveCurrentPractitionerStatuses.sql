SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomRetrieveCurrentPractitionerStatuses]          
@IndClientId bigint,          
@PractitionerId bigint          
AS          
          
BEGIN          
  SELECT TOP 1          
    1 AS Tag,          
    NULL AS Parent,          
    T1.PractitionerId AS [Practitioner!1!PractitionerId],           
    ISNULL(T2.ActiveStatus, '') AS [Practitioner!1!ActiveStatus],           
    ISNULL(T5.RiskStatusDescription, '') AS [Practitioner!1!RiskStatusDescription],
	ISNULL(T7.RiskStatusDescription, '') AS [Practitioner!1!ProductRiskStatusDescription],           
    ISNULL(T6.CompetencyStatus, '') AS [Practitioner!1!CompetencyStatus],        
    ISNULL(T5.RefRiskStatusId, 0) AS [Practitioner!1!RefRiskStatusId],    
	ISNULL(T5.RefRiskStatusId, 0) AS [Practitioner!1!AdviserRefRiskStatusId],
	ISNULL(T7.RefRiskStatusId, 0) AS [Practitioner!1!ProductRefRiskStatusId],
    ISNULL(T3.RiskStatusId, 0) AS [Practitioner!1!RiskStatusId]          
          
  FROM [CRM].[dbo].TPractitioner T1          
  LEFT JOIN [Compliance].[dbo].TActiveStatus T2          
  ON T2.PractitionerId = T1.PractitionerId          
          
  LEFT JOIN [Compliance].[dbo].TRiskStatus T3          
  ON T3.PractitionerId = T1.PractitionerId          
          
  LEFT JOIN [Compliance].[dbo].TCompetencyStatus T4          
  ON T4.PractitionerId = T1.PractitionerId          
          
  LEFT JOIN [Compliance].[dbo].TRefRiskStatus T5          
  ON T5.RefRiskStatusId = T3.AdviserRefRiskStatusId 

  LEFT JOIN  [Compliance].[dbo].TRefRiskStatus T7          
  ON T7.RefRiskStatusId = T3.ProductRefRiskStatusId         
          
  LEFT JOIN [Compliance].[dbo].TRefCompetencyStatus T6          
  ON T6.RefCompetencyStatusId = T4.RefCompetencyStatusId          
          
  WHERE T1.IndClientId = @IndClientId          
 AND T1.PractitionerId = @PractitionerId          
          
 Order By  T2.ActiveStatusId desc , T3.RiskStatusId desc, T4.CompetencyStatusId desc          
          
  FOR XML EXPLICIT          
          
END          
RETURN (0)    
GO
