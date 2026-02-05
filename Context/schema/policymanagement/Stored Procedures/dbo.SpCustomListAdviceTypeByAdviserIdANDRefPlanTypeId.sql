SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[SpCustomListAdviceTypeByAdviserIdANDRefPlanTypeId]      
 @IndigoClientId bigint,       
@PractitionerId bigint,      
@RefPlanTypeId bigint      
AS      
      
  SELECT       
      
  1 AS Tag,      
  NULL AS Parent,      
  T1.AdviceTypeId AS [AdviceType!1!AdviceTypeId],      
  T4.[Description] AS [AdviceType!1!Descriptor],      
  T3.Descriptor AS [AdviceType!1!LifeCycleId],      
  T1.RefPlanTypeId AS [AdviceType!1!RefPlanTypeId],      
  T4.IntelligentOfficeAdviceType AS [AdviceType!1!IntelligentOfficeAdviceType]      
      
        
  From TLifeCycle2RefPlanType T1      
  JOIN TRefPlanType2ProdSubType r ON r.RefPlanTypeId = t1.RefPlanTypeId  
  JOIN Compliance..TGating T2 ON T2.RefPlanType2ProdSubTypeId = r.RefPlanType2ProdSubTypeId      
  INNER JOIN TLifeCycle T3 ON T3.LifeCycleId = T1.LifeCycleId       
  INNER JOIN TAdviceType T4 ON T4.AdviceTypeId = T1.AdviceTypeId And T4.ArchiveFg = 0      
  INNER JOIN TRefPlanType T5 ON T1.RefPlanTypeId = T5.RefPlanTypeId       
      
  Where  r.RefPlanType2ProdSubtypeId = @RefPlanTypeId 
	AND T2.PractitionerId = @PractitionerId 
	AND T3.IndigoClientId = @IndigoClientId 
	AND T5.SchemeType in (0,1) 
	AND T4.IndigoClientId = @IndigoClientId      
      
UNION      
      
  SELECT       
      
  1 AS Tag,      
  NULL AS Parent,      
  T1.AdviceTypeId AS [AdviceType!1!AdviceTypeId],      
  T4.[Description]  AS [AdviceType!1!Descriptor],      
  T3.Descriptor AS [AdviceType!1!LifeCycleId],      
  T1.RefPlanTypeId AS [AdviceType!1!RefPlanTypeId],      
  T4.IntelligentOfficeAdviceType AS [AdviceType!1!IntelligentOfficeAdviceType]      
      
        
  From TLifeCycle2RefPlanType T1      
  INNER JOIN TLifeCycle T3 ON T3.LifeCycleId = T1.LifeCycleId       
  INNER JOIN TAdviceType T4 ON T4.AdviceTypeId = T1.AdviceTypeId And T4.ArchiveFg = 0      
  INNER JOIN TRefPlanType T5 ON T1.RefPlanTypeId = T5.RefPlanTypeId       
  INNER JOIN TRefPlanType2ProdSubType r ON r.RefPlanTypeId = t1.RefPlanTypeId  
  Where  r.RefPlanType2ProdSubTypeId = @RefPlanTypeId 
	AND T3.IndigoClientId = @IndigoClientId 
	AND T5.SchemeType in (0,1) 
	AND T4.IndigoClientId = @IndigoClientId 
	AND T3.Descriptor = 'Pre-Existing'      
      
      
      
  Order By [AdviceType!1!Descriptor]      
      
  FOR XML EXPLICIT      
    
    
  
GO
