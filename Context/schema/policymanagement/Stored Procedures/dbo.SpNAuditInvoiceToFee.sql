SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SpNAuditInvoiceToFee]
	@StampUser varchar (255),
	@InvoiceToFeeId bigint,
	@StampAction char(1)
AS
BEGIN
	INSERT INTO [dbo].[TInvoiceToFeeAudit]
           ([InvoiceId]
           ,[FeeId]           
           ,[ConcurrencyId]
           ,[InvoiceToFeeId]
           ,[NetAmount]
           ,[VATAmount]
           ,[StampAction]
           ,[StampDateTime]
           ,[StampUser])           
    SELECT 		
       [InvoiceId]
      ,[FeeId]
      ,[ConcurrencyId]
      ,[InvoiceToFeeId]      
      ,[NetAmount]
      ,[VATAmount]
	  ,@StampAction
	  ,GetDate()
	  ,@StampUser      
  FROM [dbo].[TInvoiceToFee]
  WHERE [InvoiceToFeeId] = @InvoiceToFeeId
IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
END

GO
