SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpInsertTenantCreatedChangeEvent]  
 @TenantId bigint,
 @IsCloneOf bigint = null
AS  
  
SET NOCOUNT ON  
  
DECLARE @tx int  
SELECT @tx = @@TRANCOUNT  
IF @tx = 0 BEGIN TRANSACTION TX  
  
BEGIN  
  DECLARE @EventName varchar(20) = 'TenantCreated'
  DECLARE @SystemUserId bigint = -200
  DECLARE @ContextData varchar(MAX) =  (Select 'IntelliFlo.Contracts.Core.EventManagement.Events.TenantCreated, IntelliFlo.Contracts.Core' as '$type'
  ,@TenantId as 'TenantId'
  ,@SystemUserId  as 'UserId'
  ,@TenantId AS 'EntityId'
  ,'1' AS 'Priority'
  ,IIF(@IsCloneOf IS NOT NULL, @IsCloneOf, NULL) AS 'IsCloneOf'
  FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)


  

  INSERT INTO [TChangeEvent] (
  UserId, 
  TenantId, 
  CreatedDate, 
  EventName, 
  ContextData, 
  [Priority])
  VALUES (
  @SystemUserId, 
  @TenantId, 
  GETDATE(), 
  @EventName,
  @ContextData,
  1)
  
IF @@ERROR != 0 GOTO errh  
IF @tx = 0 COMMIT TRANSACTION TX  
  
END  
RETURN (0)  
  
errh:  
  IF @tx = 0 ROLLBACK TRANSACTION TX  
  RETURN (100)  
GO
