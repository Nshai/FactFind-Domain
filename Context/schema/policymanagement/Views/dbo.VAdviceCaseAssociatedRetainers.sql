SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO





CREATE VIEW [dbo].[VAdviceCaseAssociatedRetainers]
AS
SELECT     T1.AdviceCaseRetainerId, 
			T1.AdviceCaseId, 
			T2.RetainerId, 
			T2.SequentialRef, 
			T2.NetAmount AS RetainerNetAmount, 
			T2.VATAmount AS RetainerVATAmount, 
			ISNULL(T2.Description, '') AS RetainerDescription, 
			T2.StartDate AS StartDate, 
			T2.SentToClientDate AS SentToClientDate
FROM         CRM.dbo.TAdviceCaseRetainer AS T1 INNER JOIN
                      PolicyManagement.dbo.TRetainer AS T2 ON T1.RetainerId = T2.RetainerId


GO
