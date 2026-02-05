SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomUpdateFundSubscription]
@IndigoClientId bigint,
@PreferenceName varchar(255),
@Value bit

as

begin

-- possible values:
-- SubscribedToPriceFeed
-- SubscribedToFundAnalysis

declare @indigoclientguid uniqueidentifier

select @indigoclientguid = guid from TIndigoClient where indigoclientid = @IndigoClientId

	IF EXISTS (SELECT * FROM TindigoClientPreference WHERE IndigoClientId = @IndigoClientId AND PreferenceName = @PreferenceName)
	BEGIN
		INSERT INTO TIndigoClientPreferenceAudit (IndigoClientId, IndigoClientGuid, PreferenceName, Value, Disabled, Guid, ConcurrencyId, IndigoClientPreferenceId, StampAction, StampDateTime, StampUser)
		SELECT IndigoClientId, IndigoClientGuid, PreferenceName, Value, Disabled, Guid, ConcurrencyId, IndigoClientPreferenceId, 'U', GETDATE(), '0'
		FROM TIndigoClientPreference 
		WHERE IndigoClientId = @IndigoClientId AND PreferenceName = @PreferenceName

		UPDATE TIndigoClientPreference
		SET Value = @Value
		WHERE IndigoClientId = @IndigoClientId AND PreferenceName = @PreferenceName

		insert into TIndigoClientPreferenceCombinedAudit
		(Guid,IndigoClientPreferenceId,IndigoClientId,IndigoClientGuid,PreferenceName,Value,Disabled,ConcurrencyId,StampAction,StampDateTime,StampUser)
		select Guid,IndigoClientPreferenceId,IndigoClientId,IndigoClientGuid,PreferenceName,Value,Disabled,ConcurrencyId,'U', GETDATE(), '0'
		from	TIndigoClientPreferenceCombined
		WHERE IndigoClientGuid = @indigoclientguid AND PreferenceName = @PreferenceName

		UPDATE TIndigoClientPreferenceCombined
		SET Value = @Value
		WHERE IndigoClientGuid = @indigoclientguid AND PreferenceName = @PreferenceName

	END
	ELSE
	BEGIN
		INSERT INTO TIndigoClientPreference (IndigoClientId, IndigoClientGuid, PreferenceName, Value, Disabled, Guid, ConcurrencyId)
		SELECT i.IndigoClientid, i.Guid, @PreferenceName, @Value, 0, newid(), 1
		FROM TIndigoClient i
		WHERE IndigoClientId = @IndigoClientId

		INSERT INTO TIndigoClientPreferenceAudit (IndigoClientId, IndigoClientGuid, PreferenceName, Value, Disabled, Guid, ConcurrencyId, IndigoClientPreferenceId, StampAction, StampDateTime, StampUser)
		SELECT IndigoClientId, IndigoClientGuid, PreferenceName, Value, Disabled, Guid, ConcurrencyId, IndigoClientPreferenceId, 'C', GETDATE(), '0'
		FROM TIndigoClientPreference  
		WHERE IndigoClientId = @IndigoClientId AND PreferenceName = @PreferenceName

		INSERT INTO TIndigoClientPreferenceCombined (IndigoClientPreferenceId,IndigoClientId, IndigoClientGuid, PreferenceName, Value, Disabled, Guid, ConcurrencyId)
		SELECT IndigoClientPreferenceId,IndigoClientId, @indigoclientguid, PreferenceName, Value, Disabled, Guid, ConcurrencyId
		FROM TIndigoClientPreference  
		WHERE IndigoClientId = @IndigoClientId AND PreferenceName = @PreferenceName

		insert into TIndigoClientPreferenceCombinedAudit
		(Guid,IndigoClientPreferenceId,IndigoClientId,IndigoClientGuid,PreferenceName,Value,Disabled,ConcurrencyId,StampAction,StampDateTime,StampUser)
		select Guid,IndigoClientPreferenceId,IndigoClientId,IndigoClientGuid,PreferenceName,Value,Disabled,ConcurrencyId,'U', GETDATE(), '0'
		from	TIndigoClientPreferenceCombined
		WHERE IndigoClientGuid = @indigoclientguid AND PreferenceName = @PreferenceName

		
	END

END

GO
