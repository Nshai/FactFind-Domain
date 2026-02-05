SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveTasksDatesByClientIds]  
  @TenantId bigint,
  @Client1Id bigint,
  @Client2Id bigint= NULL
AS    
 
    CREATE TABLE #TaskTable
    (
        TaskId                  INT
        ,DueDate                DATETIME
        ,DateCompleted          DATETIME
        ,CRMContactId           BIGINT
    );

      INSERT INTO 
        #TaskTable
      SELECT
        t.TaskId,
        CASE
            WHEN DateCompleted IS NULL THEN DueDate 
            ELSE NULL 
        END AS DueDate, 
        DateCompleted, 
        @Client1Id 
    FROM TTask t 
      INNER JOIN TOrganiserActivity oa ON oa.TaskId = t.TaskId AND oa.CRMContactId = t.CRMContactId 
      INNER JOIN TActivityCategory2RefSystemEvent ac2rse ON ac2rse.ActivityCategoryId = oa.ActivityCategoryId
      INNER JOIN TRefSystemEvent rse ON rse.RefSystemEventId = ac2rse.RefSystemEventId AND rse.Identifier IN ('Review', 'Review Diary Date')
    WHERE t.IndigoClientId = @TenantId 
    AND (
                oa.CRMContactId   = @Client1Id
            OR (oa.IndigoClientId = @TenantId AND oa.JointCRMContactId = @Client1Id)
        )

    IF(@Client2Id IS NOT NULL)
    INSERT INTO #TaskTable
    SELECT
      t.TaskId,
      CASE
         WHEN DateCompleted IS NULL THEN DueDate 
         ELSE NULL 
      END
      AS DueDate, 
      DateCompleted, 
      @Client2Id 
    FROM TTask t 
      INNER JOIN TOrganiserActivity oa ON oa.TaskId = t.TaskId AND oa.CRMContactId = t.CRMContactId 
      INNER JOIN TActivityCategory2RefSystemEvent ac2rse ON ac2rse.ActivityCategoryId = oa.ActivityCategoryId
      INNER JOIN TRefSystemEvent rse ON rse.RefSystemEventId = ac2rse.RefSystemEventId AND rse.Identifier IN ('Review', 'Review Diary Date')
    WHERE t.IndigoClientId = @TenantId AND
      (oa.CRMContactId = @Client2Id OR oa.IndigoClientId =@TenantId AND oa.JointCRMContactId = @Client2Id)

    DELETE t
    FROM        #TaskTable      t
    INNER JOIN  dbo.TCRMCOntact c
    ON
        t.CRMCOntactID = c.CRMContactID
    WHERE
        c.IsDeleted = 1;

SELECT
   MAX (DateCompleted) AS ReviewCompletedDate ,
   MIN (DueDate) AS ReviewDueDate,
   CRMContactId AS ClientId
FROM
   #TaskTable
GROUP BY CRMContactId
  
GO