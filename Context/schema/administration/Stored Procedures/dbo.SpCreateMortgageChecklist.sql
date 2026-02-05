SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateMortgageChecklist]
	@SourceTenantId BIGINT,
	@NewTenantId BIGINT

AS

BEGIN TRANSACTION

--System defined mortgage checklist categories for new tenant
INSERT INTO TMortgageChecklistCategory(MortgageChecklistCategoryName,TenantId,ArchiveFG,Ordinal,SystemFG,ConcurrencyId)
		OUTPUT                                   
			  Inserted.MortgageChecklistCategoryId,Inserted.MortgageChecklistCategoryName,Inserted.TenantId,Inserted.ArchiveFG,
			  Inserted.Ordinal,Inserted.SystemFG,Inserted.ConcurrencyId,'C', GETDATE(), 0 
		INTO
			  TMortgageChecklistCategoryAudit
			(
				MortgageChecklistCategoryId,
				MortgageChecklistCategoryName,
				TenantId,
				ArchiveFG,
				Ordinal,
				SystemFG,
				ConcurrencyId,
				StampAction,
				StampDateTime,
				StampUser				
			)
		SELECT 'General',@NewTenantId,0,1,1,1 
		UNION ALL
		SELECT 'Bridging Loans',@NewTenantId,1,2,1,1
		UNION ALL
		SELECT 'Execution-Only',@NewTenantId,1,3,1,1 	
	


--System defined mortgage checklist Questions for new tenant and updating category for new questions 
--Since the order and Archived can be changed for each question for the source tenant. Hence not considering the values from Source tenant.
INSERT INTO TMortgageChecklistQuestion(Question,MortgageChecklistCategoryId,Ordinal,IsArchived,ConcurrencyId,TenantId,ParentQuestionId,SystemFG)
		OUTPUT                                   
			  Inserted.MortgageChecklistQuestionId,Inserted.Question,Inserted.MortgageChecklistCategoryId,Inserted.Ordinal,
			  Inserted.IsArchived,Inserted.ConcurrencyId,Inserted.TenantId,Inserted.ParentQuestionId,Inserted.SystemFG,'C', GETDATE(), 0 
		INTO
			  TMortgageChecklistQuestionAudit
			(
				MortgageChecklistQuestionId,
				Question,
				MortgageChecklistCategoryId,
				Ordinal,
				IsArchived,
				ConcurrencyId,
				TenantId,
				ParentQuestionId,
				SystemFG,
				StampAction,
				StampDateTime,
				StampUser				
			)

SELECT question.Question,category.MortgageChecklistCategoryId,question.Ordinal,question.IsArchived,question.ConcurrencyId,@NewTenantId,question.IsChild,question.SystemFG FROM 
--ALM - 27/02/2017 - CORRECTED SPELLING MISTAKE - OFERED BECAME OFFERED
(SELECT 'Key messages about the service being offered have been disclosed and discussed with the client' as 'Question','General' as 'Category',1 as 'Ordinal',0 as 'IsArchived',1 as 'ConcurrencyId',1 as 'SystemFG',Null as 'IsChild'
UNION ALL
SELECT 'The different types of products and interest rate arrangements that might meet your customer''s future needs (including what your customer''s future repayments will be after a concessionary scheme)','General',2,0,1,1,NULL
UNION ALL
SELECT 'The main repayment methods available','General',3,0,1,1,Null
UNION ALL
SELECT 'For mortgages based in part or in full on an interest only basis:','General',4,0,1,1,Null
UNION ALL
SELECT 'The various methods available for repayment of the loan','General',1,0,1,1,1
UNION ALL
SELECT 'The consequences of failing to make suitable arrangements for the repayment of the mortgage','General',2,0,1,1,1
UNION ALL
SELECT 'Confirm that it is the customer''s responsibility to ensure that a repayment vehicle is maintained for the duration of the mortgage','General',3,0,1,1,1
UNION ALL
SELECT 'Client is aware that they will have to demonstrate to the Lender that a clearly understood and credible repayment strategy is in place','General',4,0,1,1,1
UNION ALL
SELECT 'The consequences should they repay the mortgage early','General',5,0,1,1,NULL
UNION ALL
SELECT 'Related insurances','General',6,0,1,1,NULL
UNION ALL
SELECT 'The customer''s responsibility to ensure that all necessary forms of insurance relating to the property and mortgage are in place','General',7,0,1,1,NULL
UNION ALL
SELECT 'Explain that certain insurances may be a condition of the mortgage','General',8,0,1,1,NULL
UNION ALL
SELECT 'All costs and fees associated with the mortgage','General',9,0,1,1,NULL
UNION ALL
SELECT 'Whether or not the terms and conditions of the mortgage product are portable in the event of moving house','General',10,0,1,1,NULL
UNION ALL
SELECT 'Explain when the customer''s account details may be passed to a credit reference agency','General',11,0,1,1,NULL
UNION ALL
SELECT 'Explain what a higher lending charge is','General',12,0,1,1,NULL
UNION ALL
SELECT 'The possible consequences for the customer''s mortgage should their personal circumstances change (e.g. accident, sickness, redundancy) and the options open to them (e.g. Mortgage Payment Protection)','General',13,0,1,1,NULL
UNION ALL
SELECT 'Joint applications - concept of joint and several liability','General',14,0,1,1,NULL
UNION ALL
SELECT 'The implications of adding fees and costs to the loan / or of debt consolidation','General',15,0,1,1,NULL
UNION ALL
SELECT 'You have considered and discussed why it is not appropriate for the client to take out a mortgage which is not a bridging loan','Bridging Loans',1,0,1,1,NULL
UNION ALL
SELECT 'Client is aware that they will have to demonstrate to the Lender that a clearly understood and credible repayment strategy is in place','Bridging Loans',2,0,1,1,NULL
UNION ALL
SELECT 'Client has confirmed in writing that they are aware of the consequences of losing the protections of the rules on suitability and have made a positive election to proceed with an execution-only sale','Execution-Only',1,0,1,1,NULL
UNION ALL
SELECT 'Client has identified the product that they require, and has specified the Lender, interest rate, rate type, Purchase Price, loan amount, the term of the mortgage and repayment basis (except High Net Worth clients and clients completing contract variations)','Execution-Only',2,0,1,1,NULL)question
JOIN administration..TMortgageChecklistCategory category on question.Category = category.MortgageChecklistCategoryName and category.TenantId = @NewTenantId

--Since the parent question Id should differ as per tenant, taking the parent question and 
--getting the Id of that Question for new tenant and accordingly updating the parentQuestionId for new tenant
--It should take care if question text gets changed, this shouldn't be changed.So avoiding the hardcodings.
UPDATE TMortgageChecklistQuestion SET ParentQuestionId = y.NewQuestionId
from TMortgageChecklistQuestion x join
(select a.MortgageChecklistQuestionId as NewQuestionId,a.Question,a.ParentQuestionId,a.MortgageChecklistCategoryId,b.MortgageChecklistQuestionId as OldQuestionId,a.TenantId
 from TMortgageChecklistQuestion a JOIN
 TMortgageChecklistQuestion b on a.Question = b.Question
 where a.TenantId = @NewTenantId and b.TenantId = @SourceTenantId 
 and b.MortgageChecklistQuestionId IN (select ParentQuestionId FROM TMortgageChecklistQuestion WHERE 
TenantId = @SourceTenantId))y on x.TenantId = y.TenantId
where x.ParentQuestionId = 1 and x.TenantId = @NewTenantId

COMMIT
GO
