SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[nio_SpCustomDeleteIndigoClientPreference]
	(
		@PreferenceName varchar (255),
		@TenantGuid varchar (255),
		@StampUser varchar (255)
	)

AS
    
SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  INSERT INTO TIndigoClientPreferenceAudit (
    IndigoClientId, 
    IndigoClientGuid, 
    PreferenceName, 
    Value, 
    ConcurrencyId,
    IndigoClientPreferenceId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.IndigoClientId, 
    T1.IndigoClientGuid, 
    T1.PreferenceName, 
    T1.Value, 
    T1.ConcurrencyId,
    T1.IndigoClientPreferenceId,
    'D',
    GetDate(),
    @StampUser

  FROM TIndigoClientPreference T1

  WHERE (T1.PreferenceName = @PreferenceName) AND 
        (T1.IndigoClientGuid = @TenantGuid)
  DELETE T1 FROM TIndigoClientPreference T1

  WHERE (T1.PreferenceName = @PreferenceName) AND 
        (T1.IndigoClientGuid = @TenantGuid)


  --SELECT 'deleted' = @@ROWCOUNT FOR XML RAW


  DELETE T1 FROM TIndigoClientPreferenceCombined T1
  WHERE (T1.PreferenceName = @PreferenceName) AND 
        (T1.IndigoClientGuid = @TenantGuid)


IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

Select 1

END
Return 0

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
