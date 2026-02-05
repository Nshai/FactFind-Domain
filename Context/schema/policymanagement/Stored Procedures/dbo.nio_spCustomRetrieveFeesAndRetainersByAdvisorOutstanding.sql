SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[nio_spCustomRetrieveFeesAndRetainersByAdvisorOutstanding]
	(		
		@AdviserCRMContactId bigint	
	)

AS


Declare @spacer varchar(10)
Select @spacer = '00000000'


SELECT 
	'1' + CAST(T2.FeeId as varchar) AS [PaymentItemId],
	T2.FeeId AS [RecordId],
	T2.FeeId AS [FeeId],
	T2.SequentialRef AS [RefNumber],
	CASE T2.IsRecurring
		WHEN 1 THEN 'Fee (R)'
		ELSE 'Fee'
	END AS [Description],
	T1.CRMContactId AS [CRMContactId],
	CASE 
		WHEN T3.PersonId IS NULL THEN T3.CorporateName
		ELSE T3.FirstName + ' ' + T3.LastName
		END AS [CRMContactFullName],
	T1.PractitionerId AS [PractitionerId],
	T5.FirstName + ' ' + T5.LastName AS [PractitionerFullName],
	T2.NetAmount + T2.VATAmount AS [ExpectedFCIAmount],
	'Fee' AS [Type],
	T2.RefFeeTypeId AS [Feetype],
	T6.FeeTypeName AS [Feetypedescription],
	CASE WHEN T2.RefFeeTypeId = 3 AND (T2.NetAmount = 0 OR T2.NetAmount IS NULL) THEN 'In progress or pending valuation.'
	ELSE CAST(T2.NetAmount AS varchar)
	END AS [NetAmount],
	CASE  T2.IsRecurring
		WHEN 1 THEN CAST(T7.PeriodName as varchar)
		ELSE 'n/a'
	END AS [Period],
	CAST(T2.VATExempt as varchar) AS [VATExempt],
	T2.InvoiceDate AS [InvoiceDate],
	T9.Status AS [Status],
	T9.Status AS [StatusId],
	T9.StatusDate AS [StatusDate],
	T2.ConcurrencyId AS [ConcurrencyId],
	ISNULL(T3.LastName, '') AS [ClientLastName], 
	ISNULL(T3.FirstName, '') AS [ClientFirstName], 
	ISNULL(T3.CorporateName, '') AS [CorporateName], 
	ISNULL(T3.CRMContactType, '') AS [CRMContactType], 
	ISNULL(T3.AdvisorRef, '') AS [ClientRef]

FROM [PolicyManagement].dbo.TFeeRetainerOwner T1
INNER JOIN [PolicyManagement].dbo.TFee T2 ON T1.FeeId = T2.FeeId
LEFT JOIN [CRM].dbo.TCRMContact T3 ON T1.CRMContactId = T3.CRMContactId
LEFT JOIN [CRM].dbo.TPractitioner T4 ON T1.PractitionerId = T4.PractitionerId
LEFT JOIN [CRM].dbo.TCRMContact T5 ON T4.CRMContactId = T5.CRMContactId
INNER JOIN  [PolicyManagement].dbo.TRefFeeType T6 ON T2.RefFeeTypeId = T6.RefFeeTypeId
LEFT JOIN [PolicyManagement].dbo.TRefFeeRetainerFrequency T7 ON T2.RefFeeRetainerFrequencyId = T7.RefFeeRetainerFrequencyId 
INNER JOIN (	Select FeeStatusId = Max(T1.FeeStatusId) , T1.FeeId
		From TFeeStatus T1 INNER JOIN TFeeRetainerOwner T2 ON T1.FeeId = T2.FeeId  
		
		INNER JOIN CRM.dbo.TPractitioner T2_1  ON T2_1.PractitionerId = T2.PractitionerId  
			INNER JOIN CRM.dbo.TCRMContact T2_2 ON T2_2.CRMContactId = T2_1.CRMContactId                     
        WHERE T2_2.CRMContactId = @AdviserCRMContactId		
		--Where T2.PractitionerId = @PractitionerId 
		Group By T1.FeeId
		
	        ) T8 ON T8.FeeId = T1.FeeId
INNER JOIN TFeeStatus T9 ON T8.FeeStatusId = T9.FeeStatusId AND T9.Status <>  'Deleted' 
INNER JOIN (Select FeeId, Max(FeePaymentStatusId) as LastFeePaymentStatusId From TFeePaymentStatus Group By FeeId) T10 ON T10.FeeId = T2.FeeId
INNER JOIN TFeePaymentStatus T11 on T11.FeePaymentStatusId = T10.LastFeePaymentStatusId
--WHERE T1.PractitionerId = @PractitionerId 
WHERE T4.CRMContactId = @AdviserCRMContactId 
	AND ((T9.Status = 'Due' AND T11.PaymentStatus = 'Not Paid') OR (T9.Status = 'Submitted For T & C'))

UNION
SELECT
	'3' + CAST(T2.RetainerId as varchar) AS [PaymentItemId],
	T2.RetainerId AS [RecordId],
	NULL AS [FeeId],
	T2.SequentialRef AS [RefNumber],
	'Retainer' AS [Description],
	T1.CRMContactId AS [CRMContactId],
	CASE 
		WHEN T3.PersonId IS NULL THEN T3.CorporateName
		ELSE T3.FirstName + ' ' + T3.LastName
		END AS [CRMContactFullName],
	T1.PractitionerId AS [PractitionerId],
	T5.FirstName + ' ' + T5.LastName AS [PractitionerFullName],
	T2.NetAmount + T2.VATAmount AS [ExpectedFCIAmount],
	'Retainer' AS [Type],
	NULL AS [Feetype],
	NULL AS [Feetypedescription],
	CAST(T2.NetAmount AS varchar) AS [NetAmount],
	CAST(T7.PeriodName as varchar) AS [Period],
	'n/a' AS [VATExempt],
	NULL AS [InvoiceDate],
	T9.Status AS [Status],
	T9.Status AS [StatusId],
	T9.StatusDate AS [StatusDate],
	T2.ConcurrencyId AS [ConcurrencyId],
	ISNULL(T3.LastName, '') AS [ClientLastName], 
	ISNULL(T3.FirstName, '') AS [ClientFirstName], 
	ISNULL(T3.CorporateName, '') AS [CorporateName], 
	ISNULL(T3.CRMContactType, '') AS [CRMContactType], 
	ISNULL(T3.AdvisorRef, '') AS [ClientRef]

FROM [PolicyManagement].dbo.TFeeRetainerOwner T1
INNER JOIN [PolicyManagement].dbo.TRetainer T2 ON T1.RetainerId = T2.RetainerId
LEFT JOIN [CRM].dbo.TCRMContact T3 ON T1.CRMContactId = T3.CRMContactId
LEFT JOIN [CRM].dbo.TPractitioner T4 ON T1.PractitionerId = T4.PractitionerId
LEFT JOIN [CRM].dbo.TCRMContact T5 ON T4.CRMContactId = T5.CRMContactId
LEFT JOIN [PolicyManagement].dbo.TRefFeeRetainerFrequency T7 ON T2.RefFeeRetainerFrequencyId = T7.RefFeeRetainerFrequencyId
INNER JOIN (	Select RetainerStatusId = Max(T1.RetainerStatusId) , T1.RetainerId
		From TRetainerStatus T1 INNER JOIN TFeeRetainerOwner T2 ON T1.RetainerId = T2.RetainerId  
		
		INNER JOIN CRM.dbo.TPractitioner T2_1  ON T2_1.PractitionerId = T2.PractitionerId  
			INNER JOIN CRM.dbo.TCRMContact T2_2 ON T2_2.CRMContactId = T2_1.CRMContactId                     
        WHERE T2_2.CRMContactId = @AdviserCRMContactId		
		--Where T2.PractitionerId = @PractitionerId 
		Group By T1.RetainerId
	        ) T8 ON T8.RetainerId = T1.RetainerId
INNER JOIN TRetainerStatus T9 ON T8.RetainerStatusId = T9.RetainerStatusId  AND T9.Status <>  'Deleted'
INNER JOIN (
		Select RetainerPaymentStatusId,RetainerId,PaymentStatus,PaymentStatusNotes,PaymentStatusDate From TRetainerPaymentStatus Where RetainerPaymentStatusId in (Select Max(RetainerPaymentStatusId) From TRetainerPaymentStatus Group By RetainerId)
                      )  T10
ON T10.RetainerId = T2.RetainerId
--WHERE T1.PractitionerId = @PractitionerId 
WHERE T4.CRMContactId = @AdviserCRMContactId 
	AND ((T9.Status = 'Active' AND T10.PaymentStatus = 'Not Paid') OR (T9.Status = 'Submitted For T & C'))

ORDER BY [FeeId],[InvoiceDate]
GO
