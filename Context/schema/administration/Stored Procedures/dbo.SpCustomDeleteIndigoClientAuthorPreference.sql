SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomDeleteIndigoClientAuthorPreference]
@PreferenceName varchar (255),
@IndigoClientGuid varchar (255),
@StampUser varchar (255),
@CSVValuesToKeep varchar(max) = ''
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
        (T1.IndigoClientGuid = @IndigoClientGuid)
         AND  T1.Value NOT IN (@CSVValuesToKeep)
         
  DELETE T1 FROM TIndigoClientPreference T1

  WHERE (T1.PreferenceName = @PreferenceName) AND 
        (T1.IndigoClientGuid = @IndigoClientGuid)
        AND T1.Value NOT IN (@CSVValuesToKeep)


  SELECT 'deleted' = @@ROWCOUNT FOR XML RAW



  DELETE T1 FROM TIndigoClientPreferenceCombined T1
  WHERE (T1.PreferenceName = @PreferenceName) AND 
        (T1.IndigoClientGuid = @IndigoClientGuid)
         AND T1.Value NOT IN (@CSVValuesToKeep)

--also delete template associations for author
IF (@PreferenceName = 'AuthorContentProvider')
BEGIN
	DELETE FROM author..TIndigoClientTemplate 
			OUTPUT 
				deleted.[Guid],
				deleted.IndigoClientGuid,
				deleted.IndigoClientTemplateId,
				deleted.TemplateGuid,
				deleted.ConcurrencyId,
				'D',
				GETDATE(),
				@StampUser
			 INTO author..TIndigoClientTemplateAudit
				 (
				  [Guid],
				  IndigoClientGuid,
				  IndigoClientTemplateId,
				  TemplateGuid,
				  ConcurrencyId,
				  StampAction,
				  StampDateTime,
				  StampUser
				 )
	WHERE [Guid] IN 
	(
		SELECT ict.Guid
		FROM author..TIndigoClientTemplate ict
		join administration..TIndigoClient i on i.guid = ict.indigoclientguid
		join author..ttemplate t on t.guid = ict.templateguid
		join administration..tindigoclient ti on ti.indigoclientid = t.indigoclientid
		left join administration..tindigoclientpreference icp on icp.value = ti.guid 
		and icp.preferencename = 'AuthorContentProvider' 
		and icp.indigoclientid = i.indigoclientid
		where icp.indigoclientpreferenceid is null
		AND ict.IndigoClientGuid = @IndigoClientGuid
	)
	
	-- also from combined
	DELETE FROM author..TIndigoClientTemplateCombined
			OUTPUT 
				deleted.[Guid],
				deleted.IndigoClientGuid,
				deleted.IndigoClientTemplateId,
				deleted.TemplateGuid,
				--deleted.msrepl_tran_version,
				deleted.ConcurrencyId,
				'D',
				GETDATE(),
				@StampUser
			 INTO author..TIndigoClientTemplateCombinedAudit
				 (
				  [Guid],
				  IndigoClientGuid,
				  IndigoClientTemplateId,
				  TemplateGuid,
				  ConcurrencyId,
				  StampAction,
				  StampDateTime,
				  StampUser
				 )
	WHERE [Guid] IN 
	(
		SELECT ict.Guid
		FROM author..TIndigoClientTemplateCombined ict
		join administration..TIndigoClientCombined i on i.guid = ict.indigoclientguid
		join author..TTemplateCombined t on t.guid = ict.templateguid
		join administration..TIndigoClientCombined ti on ti.indigoclientid = t.indigoclientid
		left join administration..TIndigoClientPreferenceCombined icp on icp.value = ti.guid 
		and icp.preferencename = 'AuthorContentProvider' 
		and icp.indigoclientid = i.indigoclientid
		where icp.indigoclientpreferenceid is null
		AND ict.IndigoClientGuid = @IndigoClientGuid
	)
END			


IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
