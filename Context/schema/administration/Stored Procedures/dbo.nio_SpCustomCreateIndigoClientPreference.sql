SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE Procedure [dbo].[nio_SpCustomCreateIndigoClientPreference]  
 (  
  @StampUser varchar (255),  
  @TenantId bigint,   
  @TenantGuid varchar(255) ,   
  @PreferenceName varchar(255) ,   
  @Value varchar(255)  = NULL,   
  @Disabled bit = 0  
 )  
  
AS
      
SET NOCOUNT ON  
  
DECLARE @tx int  
SELECT @tx = @@TRANCOUNT  
IF @tx = 0 BEGIN TRANSACTION TX  
  
BEGIN  
   
	DECLARE @IndigoClientPreferenceId bigint
   
	--TIndigoClientPreference
	INSERT INTO TIndigoClientPreference (IndigoClientId, IndigoClientGuid, PreferenceName, Value, Disabled, ConcurrencyId)

	--Get Inserted values
	OUTPUT INSERTED.IndigoClientId, INSERTED.IndigoClientGuid, INSERTED.PreferenceName, INSERTED.Value, INSERTED.Disabled,
		INSERTED.ConcurrencyId, INSERTED.IndigoClientPreferenceId, 'C', GetDate(), '0'

	--Add data to Audit
	INTO TIndigoClientPreferenceAudit 
		(IndigoClientId, IndigoClientGuid, PreferenceName, Value, Disabled, 
			ConcurrencyId, IndigoClientPreferenceId, StampAction, StampDateTime,  StampUser)

	VALUES(@TenantId, @TenantGuid, @PreferenceName, @Value, @Disabled, 1)  
  
	SELECT @IndigoClientPreferenceId = IndigoClientPreferenceId From TIndigoClientPreference
	Where IndigoClientId = @TenantId 
	and IndigoClientGuid = @TenantGuid
	and PreferenceName = @PreferenceName
	and Value= @Value
	and Disabled = @Disabled
    
	--TIndigoClientPreferenceCombined
	INSERT INTO TIndigoClientPreferenceCombined (IndigoClientPreferenceId, IndigoClientId, 
		IndigoClientGuid, PreferenceName, Value, Disabled, ConcurrencyId)  

	SELECT IndigoClientPreferenceId, IndigoClientId,   
		IndigoClientGuid, PreferenceName, Value, Disabled, ConcurrencyId  

	FROM TIndigoClientPreference  
	WHERE IndigoClientPreferenceId = @IndigoClientPreferenceId  
   
  
IF @@ERROR != 0 GOTO errh  
IF @tx = 0 COMMIT TRANSACTION TX  

Select 1
  
END  
Return 0
  
errh:  
  IF @tx = 0 ROLLBACK TRANSACTION TX  
  Return(100)  
GO
