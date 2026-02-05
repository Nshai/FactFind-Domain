SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  PROCEDURE [dbo].[SpCustomRetrieveLifeCycleByDescriptorAndLifeCycleId]    
@Descriptor varchar (255),    
@IntelligentOfficeStatusType varchar (50),    
@LifeCycleId bigint    
AS    
    
BEGIN    
  SELECT    
    1 AS Tag,    
    NULL AS Parent,    
    T1.LifeCycleId AS [LifeCycle!1!LifeCycleId],     
    T1.Name AS [LifeCycle!1!Name],     
    ISNULL(T1.Descriptor, '') AS [LifeCycle!1!Descriptor],     
    T1.Status AS [LifeCycle!1!Status],     
    T1.PreQueueBehaviour AS [LifeCycle!1!PreQueueBehaviour],     
    T1.PostQueueBehaviour AS [LifeCycle!1!PostQueueBehaviour],     
    ISNULL(CONVERT(varchar(24), T1.CreatedDate, 120),'') AS [LifeCycle!1!CreatedDate],     
    ISNULL(T1.CreatedUser, '') AS [LifeCycle!1!CreatedUser],     
    T1.IndigoClientId AS [LifeCycle!1!IndigoClientId],     
    T1.ConcurrencyId AS [LifeCycle!1!ConcurrencyId],     
    NULL AS [LifeCycleStep!2!LifeCycleStepId],     
    NULL AS [LifeCycleStep!2!StatusId],     
    NULL AS [LifeCycleStep!2!LifeCycleId],     
    NULL AS [LifeCycleStep!2!ConcurrencyId],     
    NULL AS [Status!3!StatusId],     
    NULL AS [Status!3!Name],     
    NULL AS [Status!3!OrigoStatusId],     
    NULL AS [Status!3!IntelligentOfficeStatusType],     
    NULL AS [Status!3!PreComplianceCheck],  
    NULL AS [Status!3!PostComplianceCheck],  
    NULL AS [Status!3!IndigoClientId],     
    NULL AS [Status!3!ConcurrencyId]    
  FROM TLifeCycle T1    
  INNER JOIN TLifeCycleStep T2    
  ON T1.LifeCycleId = T2.LifeCycleId    
  INNER JOIN TStatus T3    
  ON T2.StatusId = T3.StatusId    
  WHERE (T3.IntelligentOfficeStatusType = @IntelligentOfficeStatusType) AND     
        (T1.Descriptor = @Descriptor) AND (T1.LifeCycleId = @LifeCycleId)    
    
  UNION ALL    
    
  SELECT    
    2 AS Tag,    
    1 AS Parent,    
    T1.LifeCycleId,     
    T1.Name,     
    ISNULL(T1.Descriptor, ''),     
    T1.Status,  
    T1.PreQueueBehaviour,  
    T1.PostQueueBehaviour,  
    ISNULL(CONVERT(varchar(24), T1.CreatedDate, 120),''),     
    ISNULL(T1.CreatedUser, ''),     
    T1.IndigoClientId,     
    T1.ConcurrencyId,     
    T2.LifeCycleStepId,     
    T2.StatusId,     
    T2.LifeCycleId,     
    T2.ConcurrencyId,     
    NULL,     
    NULL,     
    NULL,     
    NULL,     
    NULL,     
    NULL,     
    NULL,     
    NULL    
  FROM TLifeCycleStep T2    
  INNER JOIN TLifeCycle T1    
  ON T2.LifeCycleId = T1.LifeCycleId    
  INNER JOIN TStatus TStatus    
  ON T2.StatusId = TStatus.StatusId    
  WHERE (TStatus.IntelligentOfficeStatusType = @IntelligentOfficeStatusType) AND     
        (T1.Descriptor = @Descriptor) AND (T1.LifeCycleId = @LifeCycleId)    
    
  UNION ALL    
    
  SELECT    
    3 AS Tag,    
    2 AS Parent,    
    T1.LifeCycleId,     
    T1.Name,     
    ISNULL(T1.Descriptor, ''),     
    T1.Status,     
    T1.PreQueueBehaviour,     
    T1.PostQueueBehaviour,     
    ISNULL(CONVERT(varchar(24), T1.CreatedDate, 120),''),     
    ISNULL(T1.CreatedUser, ''),     
    T1.IndigoClientId,     
    T1.ConcurrencyId,     
    NULL,     
    NULL,     
    NULL,     
    NULL,     
    T3.StatusId,     
    T3.Name,     
    ISNULL(T3.OrigoStatusId, ''),     
    ISNULL(T3.IntelligentOfficeStatusType, ''),     
    T3.PreComplianceCheck,  
    T3.PostComplianceCheck,  
    T3.IndigoClientId,     
    T3.ConcurrencyId    
  FROM TStatus T3    
  INNER JOIN TLifeCycleStep T2    
  ON T3.StatusId = T2.StatusId    
  INNER JOIN TLifeCycle T1    
  ON T2.LifeCycleId = T1.LifeCycleId    
  WHERE (T3.IntelligentOfficeStatusType = @IntelligentOfficeStatusType) AND     
        (T1.Descriptor = @Descriptor) AND (T1.LifeCycleId = @LifeCycleId)    
    
  ORDER BY [LifeCycle!1!LifeCycleId],  [Status!3!StatusId], [LifeCycleStep!2!LifeCycleStepId]    
    
  FOR XML EXPLICIT    
    
END    
RETURN (0)    
  


GO
