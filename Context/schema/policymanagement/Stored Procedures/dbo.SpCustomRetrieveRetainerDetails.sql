SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomRetrieveRetainerDetails]
@RetainerId bigint  
AS  
  
BEGIN  
  SELECT  
    1 AS Tag,  
    NULL AS Parent,  
    T1.RetainerId AS [Retainer!1!RetainerId],   
    ISNULL(CONVERT(varchar(24), T1.NetAmount), '') AS [Retainer!1!NetAmount],   
    ISNULL(CONVERT(varchar(24), T1.VATAmount), '') AS [Retainer!1!VATAmount],   
    ISNULL(T1.RefFeeRetainerFrequencyId, '') AS [Retainer!1!RefFeeRetainerFrequencyId],   
    ISNULL(CONVERT(varchar(24), T1.StartDate, 120),'') AS [Retainer!1!StartDate],   
    ISNULL(CONVERT(varchar(24), T1.ReviewDate, 120),'') AS [Retainer!1!ReviewDate],   
    ISNULL(CONVERT(varchar(24), T1.EndDate, 120),'') AS [Retainer!1!EndDate],   
    ISNULL(CONVERT(varchar(24), T1.SentToClientDate, 120),'') AS [Retainer!1!SentToClientDate],   
    ISNULL(CONVERT(varchar(24), T1.ReceivedFromClientDate, 120),'') AS [Retainer!1!ReceivedFromClientDate],   
    ISNULL(CONVERT(varchar(24), T1.SentToBankDate, 120),'') AS [Retainer!1!SentToBankDate],   
    ISNULL(T1.Description, '') AS [Retainer!1!Description],   
    T1.IndigoClientId AS [Retainer!1!IndigoClientId],   
	Owner.BandingTemplateId AS [Retainer!1!BandingTemplateId],
	T1.IsVatExempt AS [Retainer!1!IsVatExempt],
	T1.RefVATId AS [Retainer!1!RefVATId],
	ISNULL(RV.VATRate, '') AS [Retainer!1!VATRate],
	Status.Status AS [Retainer!1!RetainerStatus],
	Pay.PaymentStatus AS [Retainer!1!RetainerPaymentStatus],
	ISNULL(BT.Description,'') AS [Retainer!1!BandingTemplate],
    ISNULL(T1.SequentialRef, '') AS [Retainer!1!SequentialRef],   
    ISNULL(T1.ConcurrencyId, '') AS [Retainer!1!ConcurrencyId],   
    ISNULL(T2.PeriodName,'') AS [Retainer!1!PeriodName],   
    ISNULL(T2.NumMonths,'') AS [Retainer!1!NumMonths],   
	Owner.PractitionerId AS [Retainer!1!PractitionerId], 
    CRMP.CRMContactId AS [Retainer!1!PractitionerCRMContactId],   
    Owner.TnCCoachId AS [Retainer!1!TnCCoachId],   
	CRMT.CRMContactId AS [Retainer!1!TnCCoachCRMContactId],
    CRMT.FirstName + ' ' + CRMT.LastName AS [Retainer!1!TnCCoachName],
    CRMP.FirstName + ' ' + CRMP.LastName AS [Retainer!1!PractitionerName],
	CASE ISNULL(CRMC.PersonId,0)
		WHEN 0 THEN CRMC.FirstName + ' ' + CRMC.LastName
		ELSE CRMC.CorporateName
	END AS [Retainer!1!FullName],
	NULL AS [FeeRetainerOwner!2!FeeRetainerOwnerId],
	NULL AS [FeeRetainerOwner!2!FeeId],	
	NULL AS [FeeRetainerOwner!2!CRMContactId],
	NULL AS [FeeRetainerOwner!2!TnCCoachId],
	NULL AS [FeeRetainerOwner!2!PractitionerId],
	NULL AS [FeeRetainerOwner!2!BandingTemplateId],
	NULL AS [FeeRetainerOwner!2!ConcurrencyId]
      
    
  FROM TRetainer T1  
  LEFT JOIN TRefFeeRetainerFrequency T2  ON T1.RefFeeRetainerFrequencyId=T2.RefFeeRetainerFrequencyId
  LEFT JOIN TRefVAT RV ON RV.RefVATId = T1.RefVATId
  JOIN(
		SELECT RetainerId,MIN(PractitionerId)'PractitionerId',MIN(TnCCoachId)'TnCCoachId',MIN(BandingTemplateId)'BandingTemplateId',MIN(CRMContactId)'CRMContactId'
		FROM TFeeRetainerOwner
		WHERE RetainerId=@RetainerId
		GROUP BY RetainerId) Owner ON T1.RetainerId=Owner.RetainerId
  JOIN CRM..TPractitioner TP ON TP.PractitionerId=Owner.PractitionerId
  JOIN CRM..TCRMContact CRMP ON TP.CRMContactId=CRMP.CRMContactId
  JOIN Compliance..TTncCoach TNC ON Owner.TncCoachId=TNC.TNCCoachId
  JOIN Administration..TUser TU ON TNC.UserId=TU.UserId	
  JOIN CRM..TCRMContact CRMT ON CRMT.CRMContactId=TU.CRMContactId
  JOIN CRM..TCRMContact CRMC ON Owner.CRMContactId=CRMC.CRMContactId
  JOIN(
	SELECT RetainerId,Status
	FROM TRetainerStatus
	WHERE RetainerStatusId=(SELECT MAX(RetainerStatusId) FROM TRetainerStatus WHERE RetainerId = @RetainerId))
	Status ON T1.RetainerId=Status.RetainerId
  JOIN(
	SELECT RetainerId,PaymentStatus
	FROM TRetainerPaymentStatus
	WHERE RetainerPaymentStatusId=(SELECT MAX(RetainerPaymentStatusId) FROM TRetainerPaymentStatus WHERE RetainerId=@RetainerId))PAY ON T1.RetainerId=Pay.RetainerId
  LEFT JOIN Commissions..TBandingTemplate BT ON Owner.BandingTemplateId=BT.BandingTemplateId
  WHERE T1.RetainerId = @RetainerId


UNION ALL

SELECT 2 As TAG,
	1 AS Parent,
	T1.RetainerId,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	T2.FeeRetainerOwnerId,	
	T2.FeeId,	
	T2.CRMContactId,
	T2.TnCCoachId,
	T2.PractitionerId,
	T2.BandingTemplateId,
	T2.ConcurrencyId

	FROM TFeeRetainerOwner T2
	JOIN TRetainer T1 ON T1.RetainerId=T2.RetainerId
	WHERE T2.RetainerId=@RetainerId
	
  ORDER BY [Retainer!1!RetainerId],[FeeRetainerOwner!2!FeeRetainerOwnerId]

  FOR XML EXPLICIT  
  
END  
RETURN (0)  

GO
