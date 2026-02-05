SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomGetFeeDetails]
	@FeeId bigint    
AS        
SELECT    
    1 AS Tag,    
    NULL AS Parent,    
    T1.FeeId AS [Fee!1!FeeId],     
	T1.RefFeeTypeId AS [Fee!1!RefFeeTypeId],  
    ISNULL(CONVERT(varchar(24), T1.NetAmount), '') AS [Fee!1!NetAmount],   
    ISNULL(CONVERT(varchar(24), T1.VATAmount), '') AS [Fee!1!VATAmount],     
    ISNULL(T1.RefFeeRetainerFrequencyId, '') AS [Fee!1!RefFeeRetainerFrequencyId],     
    ISNULL(CONVERT(varchar(24), T1.InvoiceDate, 120),'') AS [Fee!1!InvoiceDate],     
    ISNULL(CONVERT(varchar(24), T1.SentToClientDate, 120),'') AS [Fee!1!SentToClientDate],     
    ISNULL(CONVERT(varchar(24), T1.NextDueDate, 120),'') AS [Fee!1!NextDueDate],           
    ISNULL(T1.BillingPeriodMonths,'') AS [Fee!1!BillingPeriodMonths],  
	Status.Status AS [Fee!1!FeeStatus],  
	Pay.PaymentStatus AS [Fee!1!FeePaymentStatus],  
	T1.VatExempt AS [Fee!1!VATExempt],  
	T1.IsRecurring AS [Fee!1!IsRecurring],  
	T1.NumRecurringPayments AS [Fee!1!NumRecurringPayments],  
	ISNULL(T1.Description, '') AS [Fee!1!Description],    
	RFT.FeeTypeName AS [Fee!1!FeeTypeName],   
	T1.IndigoClientId AS [Fee!1!IndigoClientId],     
	CASE F2P.HasRelatedPlans  
		WHEN 0 THEN 0  
		ELSE 1  
	END AS [Fee!1!HasRelatedPlans],    
	FRO.BandingTemplateId AS [Fee!1!BandingTemplateId],   
	ISNULL(BT.Description,'') AS [Fee!1!BandingTemplate],  
	ISNULL(T1.SequentialRef, '') AS [Fee!1!SequentialRef],     
	ISNULL(T1.ConcurrencyId, '') AS [Fee!1!ConcurrencyId],     
	ISNULL(T2.PeriodName,'') AS [Fee!1!PeriodName],     
	ISNULL(T2.NumMonths,'') AS [Fee!1!NumMonths],     
	FRO.PractitionerId AS [Fee!1!PractitionerId],   
	CRMP.CRMContactId AS [Fee!1!PractitionerCRMContactId],     
	FRO.TnCCoachId AS [Fee!1!TnCCoachId],     
	TNC.CRMContactId AS [Fee!1!TnCCoachCRMContactId],  
	TNC.TnCName AS [Fee!1!TnCCoachName],  
	CRMP.FirstName + ' ' + CRMP.LastName AS [Fee!1!PractitionerName],  
	CASE ISNULL(CRMC.PersonId,0)  
		WHEN 0 THEN CRMC.FirstName + ' ' + CRMC.LastName  
		ELSE CRMC.CorporateName  
	END AS [Fee!1!FullName],  
	T1.RefVATId AS [Fee!1!RefVATId],  
	ISNULL(RV.VatRate, 0) AS [Fee!1!VATRate],  
	ISNULL(T1.DiscountId, 0) AS [Fee!1!DiscountId],
	ISNULL(D.Percentage, 0) AS [Fee!1!DiscountPercentage],
	ISNULL(D.Amount, 0) AS [Fee!1!DiscountAmount],
	ISNULL(AFT.Name, '') AS [Fee!1!FeeType],
	ISNULL(APT.Name, '') AS [Fee!1!PaymentType],
	NULL AS [FeeRetainerOwner!2!FeeRetainerOwnerId],  
	NULL AS [FeeRetainerOwner!2!FeeId],   
	NULL AS [FeeRetainerOwner!2!CRMContactId],  
	NULL AS [FeeRetainerOwner!2!TnCCoachId],  
	NULL AS [FeeRetainerOwner!2!PractitionerId],  
	NULL AS [FeeRetainerOwner!2!BandingTemplateId],  
	NULL AS [FeeRetainerOwner!2!ConcurrencyId]  
FROM 
	TFee T1    
	LEFT JOIN TRefFeeRetainerFrequency T2  ON T1.RefFeeRetainerFrequencyId=T2.RefFeeRetainerFrequencyId  
	JOIN (  
		SELECT FeeId,MIN(PractitionerId)'PractitionerId',MIN(TnCCoachId)'TnCCoachId',MIN(BandingTemplateId)'BandingTemplateId',MIN(CRMContactId)'CRMContactId'  
		FROM TFeeRetainerOwner  
		WHERE FeeId=@FeeId  
		GROUP BY FeeId) AS FRO ON T1.FeeId = FRO.FeeId  
	JOIN CRM..TPractitioner TP ON TP.PractitionerId=FRO.PractitionerId  
	JOIN CRM..TCRMContact CRMP ON TP.CRMContactId=CRMP.CRMContactId  
	LEFT JOIN (
		SELECT A.TnCCoachId,ISNULL(D.CRMContactId,0) 'CRMContactId',ISNULL(D.FirstName,'') + CASE ISNULL(D.FirstName,'') WHEN '' THEN '' ELSE ' ' END + ISNULL(D.LastName,'') 'TnCName'
		FROM TFeeRetainerOwner A
			JOIN	Compliance..TTncCoach B ON A.TncCoachId=B.TNCCoachId  
			JOIN Administration..TUser C ON B.UserId=C.UserId   
			JOIN CRM..TCRMContact D ON C.CRMContactId=D.CRMContactId  
		WHERE A.FeeId=@FeeId
			AND ISNULL(A.TnCCoachId,0)!=0
		)TNC ON ISNULL(FRO.TnCCoachId,0)=TNC.TnCCoachId
	JOIN TRefFeeType RFT ON T1.RefFeeTypeId = RFT.RefFeeTypeId  
	LEFT JOIN TRefVat RV ON RV.RefVatId = T1.RefVatId  
	JOIN CRM..TCRMContact CRMC ON FRO.CRMContactId=CRMC.CRMContactId  
	JOIN(  
		SELECT FeeId,Status  
		FROM TFeeStatus  
		WHERE FeeStatusId=(SELECT MAX(FeeStatusId) FROM TFeeStatus WHERE FeeId = @FeeId)) AS [Status] ON T1.FeeId=Status.FeeId  
	LEFT  JOIN(  
		SELECT FeeId,PaymentStatus  
		FROM TFeePaymentStatus  
		WHERE FeePaymentStatusId=(SELECT MAX(FeePaymentStatusId) FROM TFeePaymentStatus WHERE FeeId=@FeeId)) AS PAY ON T1.FeeId=Pay.FeeId  
	LEFT JOIN (  
		SELECT FeeId,ISNULL(COUNT(PolicyBusinessId),0)'HasRelatedPlans'  
		FROM TFee2Policy  
		WHERE FeeId=@FeeId  
		GROUP BY FeeId) AS F2P ON T1.FeeId=F2P.FeeId  
	LEFT JOIN Commissions..TBandingTemplate BT ON FRO.BandingTemplateId=BT.BandingTemplateId  
	-- RDR data
	LEFT JOIN TDiscount D ON D.DiscountId = T1.DiscountId
	LEFT JOIN TAdviseFeeType AFT ON AFT.AdviseFeeTypeId = T1.AdviseFeeTypeId
	LEFT JOIN TAdvisePaymentType APT ON APT.AdvisePaymentTypeId = T1.AdvisePaymentTypeId
	
WHERE T1.FeeId = @FeeId  
  
UNION ALL  
  
  SELECT 2 As TAG,  
	1 AS Parent,  
	T1.FeeId,  
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
	JOIN TFee T1 ON T1.FeeId=T2.FeeId  
WHERE 
	T2.FeeId=@FeeId  
ORDER BY 
	[Fee!1!FeeId],[FeeRetainerOwner!2!FeeRetainerOwnerId]  
FOR XML EXPLICIT        
RETURN (0)    
GO
