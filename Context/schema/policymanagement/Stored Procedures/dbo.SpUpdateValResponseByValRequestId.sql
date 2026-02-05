SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpUpdateValResponseByValRequestId]  
@KeyValRequestId bigint,  
@StampUser varchar (255),  
@ErrorDescription varchar(4000) =  NULL,  
@IsAnalysed bit =  0,  
@ResponseXML text = NULL,  
@ResponseDate datetime = NULL,  
@ResponseStatus varchar (255) = NULL  
AS  
  
SET NOCOUNT ON  
  
DECLARE @tx int  
SELECT @tx = @@TRANCOUNT  
IF @tx = 0 BEGIN TRANSACTION TX  
  
BEGIN  
  INSERT INTO TValResponseAudit (  
    ValRequestId,   
	ResponseXML,
	ResponseDate,
	ResponseStatus,
	ErrorDescription,
	IsAnalysed,
	ConcurrencyId,
	ValResponseId,
	StampAction,
	StampDateTime,
	StampUser)  
  SELECT  
    T1.ValRequestId,   
	T1.ResponseXML,
	T1.ResponseDate,
	T1.ResponseStatus,
	T1.ErrorDescription,
	T1.IsAnalysed,
	T1.ConcurrencyId,
	T1.ValResponseId,  
    'U',  
    GetDate(),  
    @StampUser   
  FROM TValResponse T1  
  WHERE (T1.ValRequestId = @KeyValRequestId)  

  UPDATE T1  
  SET   
	T1.ErrorDescription = @ErrorDescription,
	T1.IsAnalysed =  @IsAnalysed,  
    T1.ResponseXML = @ResponseXML,  
    T1.ResponseDate = @ResponseDate,  
    T1.ResponseStatus = @ResponseStatus,  
    T1.ConcurrencyId = T1.ConcurrencyId + 1  
  FROM TValResponse T1  
  WHERE (T1.ValRequestId = @KeyValRequestId)  
  
SELECT * FROM TValResponse [ValResponse]  
  WHERE ([ValResponse].ValRequestId = @KeyValRequestId)  
 FOR XML AUTO  
  
IF @@ERROR != 0 GOTO errh  
IF @tx = 0 COMMIT TRANSACTION TX  
  
END  
RETURN (0)  
  
errh:  
  IF @tx = 0 ROLLBACK TRANSACTION TX  
  RETURN (100)  
GO
