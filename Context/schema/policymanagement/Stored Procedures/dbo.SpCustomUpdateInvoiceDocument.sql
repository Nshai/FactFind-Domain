create procedure [dbo].[SpCustomUpdateInvoiceDocument]
@StampUser bigint,
@InvoiceId bigint,
@DocVersionId bigint

as

begin

--TODO: AUDIT (once the db schema is in place)

UPDATE TInvoice
SET DocVersionId = @DocVersionId
WHERE InvoiceId = @InvoiceId

end

