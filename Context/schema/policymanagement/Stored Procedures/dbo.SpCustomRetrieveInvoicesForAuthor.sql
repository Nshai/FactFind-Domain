create procedure [dbo].[SpCustomRetrieveInvoicesForAuthor]
@CRMContactId bigint

as

SELECT 
1 as tag,
null as parent,
i.InvoiceId as [Invoice!1!InvoiceId],
i.SequentialRef as [Invoice!1!SequentialRef],
i.ExternalReference as [Invoice!1!ExternalReference]

FROM TInvoice i
WHERE i.CRMContactId = @CRMContactId

FOR XML EXPLICIT



