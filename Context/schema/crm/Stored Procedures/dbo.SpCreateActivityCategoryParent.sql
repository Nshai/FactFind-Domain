SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateActivityCategoryParent]  @StampUser varchar (255),  @Name varchar (50),  @IndigoClientId bigint  AS    SET NOCOUNT ON    DECLARE @tx int  SELECT @tx = @@TRANCOUNT  IF @tx = 0 BEGIN TRANSACTION TX    BEGIN    DECLARE @ActivityCategoryParentId bigint      INSERT INTO TActivityCategoryParent (      Name,       IndigoClientId,       ConcurrencyId )     VALUES (      @Name,       @IndigoClientId,       1)       SELECT @ActivityCategoryParentId = SCOPE_IDENTITY()    INSERT INTO TActivityCategoryParentAudit (      Name,       IndigoClientId,       ConcurrencyId,      ActivityCategoryParentId,      StampAction,      StampDateTime,      StampUser)    SELECT      T1.Name,       T1.IndigoClientId,       T1.ConcurrencyId,      T1.ActivityCategoryParentId,      'C',      GetDate(),      @StampUser      FROM TActivityCategoryParent T1   WHERE T1.ActivityCategoryParentId=@ActivityCategoryParentId    EXEC SpRetrieveActivityCategoryParentById @ActivityCategoryParentId    IF @@ERROR != 0 GOTO errh  IF @tx = 0 COMMIT TRANSACTION TX    END  RETURN (0)    errh:    IF @tx = 0 ROLLBACK TRANSACTION TX    RETURN (100)  
GO
