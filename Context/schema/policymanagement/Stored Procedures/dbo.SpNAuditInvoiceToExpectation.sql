SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditInvoiceToExpectation]
    @StampUser varchar(255),
    @InvoiceToExpectationId int,
    @StampAction char(1)
AS
BEGIN
    -- Disable the count of affected rows
    SET NOCOUNT ON;

    -- Insert statement to audit the InvoiceToExpectation
    INSERT INTO [dbo].[TInvoiceToExpectationAudit]
           ([InvoiceId],        
            [ExpectationId],
            [InvoiceToExpectationId],
            [StampAction],
            [StampDateTime],
            [StampUser])           
    SELECT  InvoiceId,
            ExpectationId,
            InvoiceToExpectationId,     
            @StampAction,
            GetDate(),
            @StampUser     
    FROM [dbo].[TInvoiceToExpectation]
    WHERE InvoiceToExpectationId = @InvoiceToExpectationId;

    IF @@ERROR != 0 
        GOTO errh;

    SET NOCOUNT OFF;

    RETURN (0);

errh:
    RETURN (100);
END
GO
