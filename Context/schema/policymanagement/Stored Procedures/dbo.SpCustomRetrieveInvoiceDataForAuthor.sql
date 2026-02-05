create procedure [dbo].[SpCustomRetrieveInvoiceDataForAuthor]    
@InvoiceId bigint,
@TenantId int = 0
    
as    
    
--DECLARE @InvoiceId bigint    
--SET @InvoiceId = 45  
    
if (@TenantId = 0)
	select @TenantId = Tenantid from TInvoice with (nolock) where InvoiceId = @InvoiceId

SELECT       
1 as tag,      
null as parent,      
-- invoice fields      
i.InvoiceId as [Invoice!1!InvoiceId],      
i.Description as [Invoice!1!Description],      
i.ExternalReference as [Invoice!1!ExternalReference],      
i.SequentialRef as [Invoice!1!SystemReference],     
convert(varchar(10),i.InvoiceDate,103) as [Invoice!1!InvoiceDate],    
convert(varchar(10),i.SentToClientDate,103) as [Invoice!1!SentToClientDate],    
-- fee fields      
null as [Fee!2!FeeId],      
null as [Fee!2!FeeReference],      
null as [Fee!2!FeeType],      
null as [Fee!2!FeeChargingType],      
null as [Fee!2!FeePercent],      
null as [Fee!2!NetFeeAmount],      
null as [Fee!2!VATAmount],      
null as [Fee!2!DiscountAmount],      
null as [Fee!2!DiscountPercent],      
null as [Fee!2!TotalFeeAmount],      
null as [Fee!2!InitialPeriod],      
null as [Fee!2!NextDueDate],      
null as [Fee!2!Frequency],      
null as [Fee!2!InvoiceDate],      
null as [Fee!2!FeeDescription],      
null as [Fee!2!RelatedPlanNumber],      
null as [Fee!2!RelatedPlanType],      
null as [Fee!2!RelatedPlanProvider],      
-- task fields      
null as [Task!3!TaskId],      
null as [Task!3!TaskReference],      
null as [Task!3!FeeReference],      
null as [Task!3!TaskCategory],      
null as [Task!3!TaskType],      
null as [Task!3!Subject],      
null as [Task!3!DateCompleted],      
null as [Task!3!CompletedBy],      
null as [Task!3!ActualTimeHours]      
      
FROM TInvoice i      
WHERE InvoiceId = @InvoiceId      
      
UNION      
      
SELECT       
2 as tag,      
1 as parent,      
-- invoice fields      
i.InvoiceId,      
null,      
null,      
null,      
null,      
null,     
-- fee fields      
f.FeeId,      
f.SequentialRef,      
aft.Name,      
raft.Name,      
case when f.FeePercentage IS NULL then afcd.PercentageOfFee/100 else f.FeePercentage/100 end,
f.NetAmount,      
f.VatAmount,      
case when isnull(d.Amount,0) = 0 then null else d.amount end,      
case when isnull(d.Percentage,0) = 0 then null else d.percentage/100 end,     
f.NetAmount + f.VatAmount,      
f.InitialPeriod,      
convert(varchar(10),fr.NextExpectationDate, 103),    
CASE  f.IsRecurring                  
  WHEN 1 THEN CAST(FeeRetFequency.PeriodName as varchar)                  
  WHEN 0 THEN CAST(RecurringFrequency.PeriodName as varchar)     
  ELSE ''                  
END,      
convert(varchar(10),f.InvoiceDate, 103),     
f.description,      
dbo.fnGetRelatedPlanDetailsForFee(f.FeeId, 'PolicyNumber'),      
dbo.fnGetRelatedPlanDetailsForFee(f.FeeId, 'PlanType'),      
dbo.fnGetRelatedPlanDetailsForFee(f.FeeId, 'Provider'),      
-- task fields      
null,      
null,      
null,      
null,      
null,      
null,      
null,      
null,      
null      
      
FROM TInvoice i      
JOIN TInvoiceToFee ifee on ifee.InvoiceId= i.InvoiceId      
JOIN TFee f on f.FeeId = ifee.FeeId      
LEFT JOIN TFeeRecurrence fr on fr.FeeId = f.FeeId  
LEFT JOIN TAdviseFeeType aft on aft.AdviseFeeTypeId = f.AdviseFeeTypeId      
LEFT JOIN TAdviseFeeChargingDetails afcd on afcd.AdviseFeeChargingDetailsId = f.AdviseFeeChargingDetailsId      
LEFT JOIN TAdviseFeeChargingType afct on afct.AdviseFeeChargingTypeId = afcd.AdviseFeeChargingTypeId      
LEFT JOIN TRefAdviseFeeChargingType raft on raft.RefAdviseFeeChargingTypeId = afct.RefAdviseFeeChargingTypeId      
LEFT JOIN TDiscount d on d.discountid = f.discountid            
LEFT JOIN TRefVAT v on v.RefVATId = f.RefVATId     
LEFT JOIN TRefFeeRetainerFrequency FeeRetFequency ON FeeRetFequency.RefFeeRetainerFrequencyId = f.RefFeeRetainerFrequencyId               
LEFT JOIN TRefFeeRetainerFrequency RecurringFrequency ON RecurringFrequency.RefFeeRetainerFrequencyId = f.RecurringFrequencyId        
WHERE i.InvoiceId = @InvoiceId      
      
      
UNION      
      
SELECT       
3 as tag,      
2 as parent,      
-- invoice fields      
i.InvoiceId,      
null,      
null,      
null,      
null,      
null,      
-- fee fields      
f.FeeId,      
null,      
null,      
null,      
null,      
null,      
null,      
null,      
null,      
null,      
null,      
null,      
null,      
null,      
null,      
null,      
null,      
null,      
-- task fields      
t.TaskId,      
t.SequentialRef,      
f.SequentialRef,      
acp.Name,      
ac.Name,      
t.Subject,      
convert(varchar(10), t.DateCompleted,103),      
c.FirstName + ' ' + c.LastName,      
t.ActualTimeHrs      
      
FROM TInvoice i      
JOIN TInvoiceToFee ifee on ifee.InvoiceId= i.InvoiceId      
JOIN TFee f on f.FeeId = ifee.FeeId      
JOIN TFeeToTask ftt on ftt.FeeId = f.FeeId      
JOIN CRM..TTask t on t.TaskId = ftt.TaskId      
JOIN CRM..TOrganiserActivity oa on oa.TaskId = t.TaskId      
JOIN CRM..TActivityCategory ac on ac.ActivityCategoryId = oa.ActivityCategoryId      
JOIN CRM..TActivityCategoryParent acp on acp.ActivityCategoryParentId = oa.ActivityCategoryParentId      
LEFT JOIN Administration..TUser u on u.UserId = t.PerformedUserId      
LEFT JOIN CRM..TCRMContact c on c.CRMContactId = u.CRMContactId      
WHERE i.InvoiceId = @InvoiceId
and t.IndigoClientId = @TenantId
      
ORDER BY [Invoice!1!InvoiceId], [Fee!2!FeeId], [Task!3!TaskId]      
    
FOR XML EXPLICIT    
    