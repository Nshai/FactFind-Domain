SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[spCustomRetrieveVerificationHistoryWithAdvisor] @CRMContactId int

as

select  
1 AS Tag,
NULL AS Parent,
vh.VerificationHistoryId As [VerificationHistory!1!VerificationHistoryId],
vh.UserId As [VerificationHistory!1!UserId],
vh.CRMContactId As [VerificationHistory!1!CRMContactId],
right('0' + cast(datepart(day,vh.VerificationDate) as varchar(5)),2) + ' ' + datename(month,vh.VerificationDate) + ' ' +cast(datepart(year,vh.VerificationDate) as varchar(4)) + ' ' +convert(varchar,vh.verificationdate,108) As [VerificationHistory!1!VerificationDate],
vh.VerificationResult As [VerificationHistory!1!VerificationResult],
vh.AuthenticationId As [VerificationHistory!1!AuthenticationId],
vh.ResultDocumentId As [VerificationHistory!1!ResultDocumentId],
vh.CertificateDocumentId As [VerificationHistory!1!CertificateDocumentId],
'/documents/' + cast(u.IndigoClientId as varchar(5)) + '/' + dcert.FileName As [VerificationHistory!1!CertificateFilePath],
'/documents/'+ cast(u.IndigoClientId as varchar(5)) + '/' + dres.FileName As [VerificationHistory!1!ResultFilePath],
firstname + ' ' + lastname As [VerificationHistory!1!AdviserName]
from TVerificationHistory vh
inner join Administration..TUser u on u.userid = vh.userid
inner join TCRMContact c on c.crmcontactid = u.crmcontactid
left join DocumentManagement..TDocVersion dres on  dres.DocumentId = vh.ResultDocumentId
left join DocumentManagement..TDocVersion dcert on  dcert.DocumentId = vh.CertificateDocumentId
where	vh.CRMContactId = @CRMContactId
order by VerificationDate desc
for xml explicit
GO
