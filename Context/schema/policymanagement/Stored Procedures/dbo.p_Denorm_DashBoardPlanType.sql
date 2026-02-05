create procedure [dbo].[p_Denorm_DashBoardPlanType]
as
begin

	set transaction isolation level read uncommitted

	begin tran
		truncate table policymanagement..TDashBoardPlanTypeDN
		insert policymanagement..TDashBoardPlanTypeDN
		SELECT tpb.PractitionerId, tpb.IndigoClientId, tpds.RefPlanType2ProdSubTypeId, rpt2pst.RefPlanTypeId, tpb.PolicyBusinessId, tpd.PolicyDetailId
		FROM TPolicyBusiness tpb 
		JOIN TPolicyDetail tpd ON tpd.PolicyDetailId = tpb.PolicyDetailId  
		JOIN TPlanDescription tpds ON tpds.PlanDescriptionId = tpd.PlanDescriptionId  
		JOIN policymanagement..TStatusHistory Sh  ON tpb.PolicyBusinessId = Sh.PolicyBusinessId  AND sh.CurrentStatusFG=1 
		JOIN policymanagement..TStatus S ON S.StatusId = Sh.StatusId  AND S.IntelligentOfficeStatusType !='Deleted'
		JOIN policymanagement..TRefPlanType2ProdSubType rpt2pst ON rpt2pst.RefPlanType2ProdSubTypeId = tpds.RefPlanType2ProdSubTypeId
		group by tpb.PractitionerId, tpb.IndigoClientId, tpds.RefPlanType2ProdSubTypeId, rpt2pst.RefPlanTypeId,tpb.PolicyBusinessId, tpd.PolicyDetailId

	if @@ERROR = 0
		commit tran
	else 
		rollback

	begin tran
		truncate table policymanagement..TDashBoardPlanTypeCommissionDN
		insert policymanagement..TDashBoardPlanTypeCommissionDN
		SELECT isnull(p.CRMContactId,0) as CRMContactID, tpb.IndigoClientId, rpt2pst.RefPlanTypeId, isnull(SUM(convert(money,p.Amount)),0) Amount
		FROM TPolicyBusiness tpb 
		left join commissions..TPayment p  ON tpb.PolicyBusinessId = p.PolicyId  
		JOIN TPolicyDetail tpd ON tpd.PolicyDetailId = tpb.PolicyDetailId  
		JOIN TPlanDescription tpds ON tpds.PlanDescriptionId = tpd.PlanDescriptionId  
		JOIN policymanagement..TStatusHistory Sh  ON tpb.PolicyBusinessId = Sh.PolicyBusinessId  AND sh.CurrentStatusFG=1 
		JOIN policymanagement..TStatus S ON S.StatusId = Sh.StatusId  AND S.IntelligentOfficeStatusType !='Deleted'
		JOIN policymanagement..TRefPlanType2ProdSubType rpt2pst ON rpt2pst.RefPlanType2ProdSubTypeId = tpds.RefPlanType2ProdSubTypeId
		where p.CRMContactId is not null
		group by p.CRMContactId, tpb.IndigoClientId, rpt2pst.RefPlanTypeId

		if @@ERROR = 0
		commit tran
	else 
		rollback

	begin tran
	
		truncate table Commissions..TDashBoardCommission12MonthDN;
		with cte as (SELECT IndClientId,PeriodComHistId, ROW_NUMBER() over (partition by IndClientId order by PeriodComHistId desc) as rownumber,StartDatetime,EndDatetime,[Description]
		FROM	 commissions..TPeriodComHist 
		WHERE	 EndDatetime IS NOT NULL) 
		insert into Commissions..TDashBoardCommission12MonthDN ([IndclientId],[CRMContactId],[PeriodComHistId],[Amount])
		SELECT p.IndClientId, p.CRMContactId, pa.PeriodComHistId, ISNULL(SUM(Amount),0) as Amount
		FROM 	 commissions..TPayment p 
		JOIN cte As pa on p.PeriodComHistId = pa.PeriodComHistId
		WHERE (p.AllocatedDate BETWEEN pa.StartDatetime and pa.EndDatetime OR p.AllocatedDate IS NULL)
		and pa.rownumber <= 12
		GROUP BY p.IndClientId,p.crmcontactid, pa.PeriodComHistId
	
	if @@ERROR = 0
		commit tran
	else 
		rollback

	begin tran
		truncate table commissions..TDashBoardPaymentGroupKPI;
		WITH PeriodComHistRanked AS(SELECT IndClientId, PeriodComHistId, ROW_NUMBER() OVER(PARTITION BY IndClientId ORDER BY StartDateTime DESC) AS PeriodNo FROM commissions..TPeriodComHist WHERE EndDateTime IS NOT NULL)
		SELECT IndClientId, PeriodComHistId, PeriodNo
		INTO #MostRecent2ComHist
		FROM PeriodComHistRanked
		WHERE PeriodNo <= 2

		insert commissions..TDashBoardPaymentGroupKPI 
		SELECT P.PeriodComHistId, p.IndClientId, p.CRMContactId, p.LeadPractitionerId, p.PaymentEntityId, sum(FCIRecognition) as FCIRecognition, sum(Amount) as Amount
		FROM commissions..TPayment P
		JOIN #MostRecent2ComHist ComHist ON p.PeriodComHistId = ComHist.PeriodComHistId AND p.IndClientId = ComHist.IndClientId
		group by P.PeriodComHistId, p.IndClientId, p.CRMContactId, p.LeadPractitionerId, p.PaymentEntityId

	if @@ERROR = 0
		commit tran
	else 
		rollback

end
