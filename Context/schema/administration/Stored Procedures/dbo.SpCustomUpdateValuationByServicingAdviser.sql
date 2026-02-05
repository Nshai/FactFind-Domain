SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomUpdateValuationByServicingAdviser]  
@IndigoClientId bigint,  
@PreferenceName varchar(255),  
@Value bit  
AS  
  
BEGIN  
  
-- possible values:  
-- ExtendValuationsByServicingadviser
  
declare @indigoclientguid uniqueidentifier  
  
select @indigoclientguid = guid from TIndigoClient where indigoclientid = @IndigoClientId

 IF EXISTS (SELECT 1 FROM TindigoClientPreference WHERE IndigoClientId = @IndigoClientId AND PreferenceName = @PreferenceName)  
         BEGIN  
                        UPDATE [TIndigoClientPreference]
                                SET [Value] =  @Value, [ConcurrencyId] = [ConcurrencyId] + 1
                                        OUTPUT
                                              DELETED.[IndigoClientId],DELETED.[IndigoClientGuid],DELETED.[PreferenceName],DELETED.[Value],DELETED.[Disabled],DELETED.[Guid],DELETED.[ConcurrencyId],DELETED.[IndigoClientPreferenceId]
                                               ,'U',GETDATE(),'0'
                                        INTO [TIndigoClientPreferenceAudit]
                                                   ([IndigoClientId],[IndigoClientGuid],[PreferenceName],[Value],[Disabled],[Guid],[ConcurrencyId],[IndigoClientPreferenceId]
                                                   ,[StampAction],[StampDateTime],[StampUser])
                                WHERE
                                        [IndigoClientId] = @IndigoClientId AND [PreferenceName] = @PreferenceName

                        UPDATE TIndigoClientPreferenceCombined 
                                  SET Value = @Value  
                                        OUTPUT
                                            DELETED.Guid,DELETED.IndigoClientPreferenceId,DELETED.IndigoClientId,DELETED.IndigoClientGuid,DELETED.PreferenceName,DELETED.Value,DELETED.Disabled,DELETED.ConcurrencyId,'U', GETDATE(), '0'  
                                        INTO TIndigoClientPreferenceCombinedAudit  
                                            (Guid,IndigoClientPreferenceId,IndigoClientId,IndigoClientGuid,PreferenceName,Value,Disabled,ConcurrencyId,StampAction,StampDateTime,StampUser)  
                                  WHERE IndigoClientGuid = @indigoclientguid AND PreferenceName = @PreferenceName  
         END  
 ELSE  
         BEGIN  
                    INSERT INTO [TIndigoClientPreference]
                               ([IndigoClientId],[IndigoClientGuid],[PreferenceName],[Value],[Disabled],[Guid],[ConcurrencyId])
                                        OUTPUT
                                              INSERTED.[IndigoClientId],INSERTED.[IndigoClientGuid],INSERTED.[PreferenceName],INSERTED.[Value],INSERTED.[Disabled],INSERTED.[Guid],INSERTED.[ConcurrencyId],INSERTED.[IndigoClientPreferenceId]
                                               ,'C',GETDATE(),'0'
                                        INTO [TIndigoClientPreferenceAudit]
                                                   ([IndigoClientId],[IndigoClientGuid],[PreferenceName],[Value],[Disabled],[Guid],[ConcurrencyId],[IndigoClientPreferenceId],
                                                    [StampAction],[StampDateTime],[StampUser])
                         VALUES
                               (@IndigoClientId, @indigoclientguid, @PreferenceName, @Value, 0, NEWID(), 1)

                    INSERT INTO TIndigoClientPreferenceCombined (IndigoClientPreferenceId,IndigoClientId, IndigoClientGuid, PreferenceName, Value, Disabled, Guid, ConcurrencyId)  
                            OUTPUT 
                                     INSERTED.Guid,INSERTED.IndigoClientPreferenceId,INSERTED.IndigoClientId,INSERTED.IndigoClientGuid,INSERTED.PreferenceName,INSERTED.Value,INSERTED.Disabled,INSERTED.ConcurrencyId,'U', GETDATE(), '0'  
                            INTO TIndigoClientPreferenceCombinedAudit  
                                    (Guid,IndigoClientPreferenceId,IndigoClientId,IndigoClientGuid,PreferenceName,Value,Disabled,ConcurrencyId,StampAction,StampDateTime,StampUser)                    
                        SELECT IndigoClientPreferenceId,IndigoClientId, @indigoclientguid, PreferenceName, Value, Disabled, Guid, ConcurrencyId  
                            FROM TIndigoClientPreference
                            WHERE IndigoClientId = @IndigoClientId AND PreferenceName = @PreferenceName  
          END  
  
END

exec policymanagement..SpCustomValuationsTenantChanged  @IndigoClientId

GO
