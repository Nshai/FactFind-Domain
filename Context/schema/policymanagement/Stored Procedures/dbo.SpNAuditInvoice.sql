SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditInvoice]
	@StampUser varchar (255),
	@InvoiceId bigint,
	@StampAction char(1)
AS
BEGIN
	INSERT INTO [dbo].[TInvoiceAudit]
           ([CRMContactId]
           ,[Description]
           ,[DocVersionId]
           ,[ExternalReference]
           ,[SequentialRef]
           ,[NetAmount]
           ,[VATAmount]
           ,[TenantId]
           ,[ConcurrencyId]
           ,[InvoiceId]
           ,[StampAction]
           ,[StampDateTime]
           ,[StampUser]
           ,[InvoiceDate]
           ,[CreatedDate]
           ,[SentToClientDate])
    SELECT 
		[CRMContactId]
      ,[Description]
      ,[DocVersionId]
      ,[ExternalReference]
      ,[SequentialRef]
      ,[NetAmount]
	  ,[VATAmount]
      ,[TenantId]
      ,[ConcurrencyId]
      ,[InvoiceId]
	  ,@StampAction
	  ,GetDate()
	  ,@StampUser      
      ,[InvoiceDate]
      ,[CreatedDate]
      ,[SentToClientDate]      
  FROM [dbo].[TInvoice]
  WHERE [InvoiceId] = @InvoiceId
IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
END
GO
