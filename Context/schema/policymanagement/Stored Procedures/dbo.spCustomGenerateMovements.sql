SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[spCustomGenerateMovements]
	@TimeFrameHours INT = 2,
	@TenantId INT = null
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

if (@TimeFrameHours > 0 ) 
Begin 
	Set @TimeFrameHours = @TimeFrameHours * -1
end

Declare @LastRunDateTime datetime = GETDATE() -- this is important, if the job takes a long time we will know what time it was BEFORE it begain processing.
Declare @DateTimeToGoBack datetime = DATEADD(HOUR, @TimeFrameHours, GETDATE())
Declare @Preference_Name varchar(20) = 'GenerateMovements'
Declare @MaxMoney money = 922337203685477.58

IF OBJECT_ID('tempdb..#Tenants') IS NOT NULL DROP TABLE #Tenants
Create Table #Tenants(TenantId INT)


--Get whichever tenants have The Tenant Preference 
Insert into #Tenants 
Select Distinct IndigoClientId 
from administration..TIndigoClientPreference
WHERE PreferenceName = @Preference_Name
AND (ISNULL(@TenantId, 0) = 0 OR (ISNULL(@TenantId, 0) != 0 AND IndigoClientId = @TenantId))


Create clustered index IDX_TenantId ON #tenants(TenantId)


If not exists (Select TenantId from #Tenants) 
BEGIN
	print 'ZERO tenants configured'
	return
END


IF OBJECT_ID('tempdb..#MovementTriggerAudits') IS NOT NULL 
	DROP TABLE #MovementTriggerAudits
Create Table #MovementTriggerAudits(PolicyBusinessId INT null, FeeId INT null, PayAdjustId INT null, TenantId int, 
	[Type] varchar(500), TriggerSource VarChar(200), Action varChar(50), TriggerTimeStamp datetime, TimeStamp datetime)

-----------------------------------
/* IMPORTANT - changes in audit tables can be initiated by sysem (StampUser = '0') */
-----------------------------------
--Get Plan Triggers 
	--TPolicyBusiness (DueDate)
	--TPolicyExpectedCommission 
	--TpolicyStateus
INSERT INTO #MovementTriggerAudits
SELECT PolicyBusinessId, null, null, IndigoClientId, 'PlanModified', 'TPolicyBusiness', StampAction,	StampDateTime, GETDATE()  
from TPolicyBusinessAudit A
INNER JOIN #Tenants B on A.IndigoClientId = B.TenantId 
WHERE A.StampDateTime >= @DateTimeToGoBack


INSERT INTO #MovementTriggerAudits
SELECT A.PolicyBusinessId, null, null, B.IndigoClientId, 'Expectation Modified', 'TPolicyExpectedCommission', StampAction,	StampDateTime, GETDATE()  
from TPolicyExpectedCommissionAudit A
inner join TPolicyBusiness B ON A.PolicyBusinessId = B.PolicyBusinessId
INNER JOIN #Tenants C on B.IndigoClientId = C.TenantId 
WHERE A.StampDateTime >= @DateTimeToGoBack


INSERT INTO #MovementTriggerAudits
SELECT A.PolicyBusinessId, null, null, B.IndigoClientId, 'Expectation Modified', 'TStatusHistory', StampAction,	StampDateTime, GETDATE()  
from TStatusHistoryAudit A
inner join TPolicyBusiness B ON A.PolicyBusinessId = B.PolicyBusinessId
INNER JOIN #Tenants C on B.IndigoClientId = C.TenantId 
WHERE A.StampDateTime >= @DateTimeToGoBack AND A.StampUser <> '0' -- DEF-6184 - Skip system changes

-----------------------------------
--Get Fee Triggers 
	--TFee (DueDate)
	--TPolicyExpectedCommission 
	--TpolicyStateus
INSERT INTO #MovementTriggerAudits
SELECT null, FeeId, null, IndigoClientId, 'Fee Modified', 'TFee', StampAction,	StampDateTime, GETDATE()  
from TFeeAudit A
INNER JOIN #Tenants B on A.IndigoClientId = B.TenantId 
WHERE A.StampDateTime >= @DateTimeToGoBack


INSERT INTO #MovementTriggerAudits
SELECT null, A.FeeId, null, B.IndigoClientId, 'Fee Status Modified', 'TFeeStatus', StampAction,	StampDateTime, GETDATE()  
from TFeeStatusAudit A
inner join Tfee B ON A.FeeId = B.FeeId
INNER JOIN #Tenants C on B.IndigoClientId = C.TenantId 
WHERE A.StampDateTime >= @DateTimeToGoBack


INSERT INTO #MovementTriggerAudits
SELECT  null, null, PayAdjustId, A.IndClientId, 'Adjustment Modifed - Adviser', 'TPayAdjust', StampAction , StampDateTime, GETDATE()  
from commissions..TPayAdjustAudit A
Inner join CRM..TPractitioner B ON A.CRMContactID = B.CRMContactId -- adviser Adjustments only
INNER JOIN #Tenants C on A.IndClientId = C.TenantId 
WHERE A.StampDateTime >= @DateTimeToGoBack


-------------------------------------
Create nonclustered index idx_TenantId_PolicyBusinessId ON #MovementTriggerAudits( TenantId, PolicyBusinessId)
Create nonclustered index idx_TenantId_FeeId ON #MovementTriggerAudits( TenantId, FeeId)
Create nonclustered index idx_TenantId_PayAdjustId ON #MovementTriggerAudits( TenantId, PayAdjustId)


IF OBJECT_ID('tempdb..#MovementTriggers') IS NOT NULL 
	DROP TABLE #MovementTriggers


Select Distinct PolicybusinessId, FeeId, PayAdjustId, TenantID, Max(TriggertimeStamp) as MaxTriggertimeStamp 
INTO #MovementTriggers
from #MovementTriggerAudits group by PolicybusinessId, FeeId, PayAdjustId, TenantId


	Declare @LocalDeleted_Status varchar(20) = 'Deleted'
	Declare @LocalNTU_Status varchar(20) = 'NTU'
	Declare @LocalFee_Due_Status varchar(20) = 'Due'
	Declare @LocalFee_Cancelled_Status varchar(20) = 'Cancelled'
	Declare @LocalFee_Paid varchar(20) = 'Paid'
	Declare @LocalFee_PaymentReceived varchar(20) = 'Payment Received'
	
	IF OBJECT_ID('tempdb..#Plans') IS NOT NULL DROP TABLE #Plans

	CREATE TABLE #Plans(TenantId INT, PolicyBusinessId INT, IsPayawayReceived INT default(0), SellingAdviserId Int, RecevingAdviserId INT, 
	 CommissionTypeName varchar(200), IsRecurring Int, MaxTriggerTimeStamp datetime, PolicyStartDate datetime, CanSnapShot int default(0), HasMovement int default (0),
		BandingRate decimal (10,2) default(0), 
		GrossAmount money default(0),
		IntroducerAmount money default(0), ClientAmount money default(0), 
		AdviserAmount money default(0), NetAmount money default(0), 
		PayawayReceivedPercentage decimal (10,2) default(0), Introducers varchar(200), Clients varchar(200) , Advisers varchar(200)
	
	)

	
	--Will only snap shot if Has a Policy Start Date,  has an expected commission, AND is not Deleted status
	insert into #Plans
	(TenantId, PolicyBusinessId, SellingAdviserId, RecevingAdviserId,  CommissionTypeName, IsRecurring, MaxTriggerTimeStamp, PolicyStartDate, CanSnapShot, HasMovement, BandingRate)
	Select distinct A.TenantId, A.PolicyBusinessId, Rate.PractitionerId, rate.CRAPractitionerId, C.CommissionTypeName, C.RecurringCommissionFg, 
	MaxTriggerTimeStamp, pb.PolicyStartDate, 1, Case When M.MovementID IS NOT NULL THEN 1 ELSE 0 END, rate.BandingRate
	FROM #movementTriggers A
	INNER JOIN TPolicyBusiness pb ON A.TenantId = pb.IndigoClientId AND A.PolicyBusinessId = pb.PolicyBusinessId
	INNER JOIN TPolicyExpectedCommission B ON A.PolicyBusinessId = B.PolicyBusinessId
	INNER JOIN TRefCommissionType C ON B.RefCommissionTypeId = C.RefCommissionTypeId
	INNER JOIN policymanagement..TStatusHistory D ON A.PolicyBusinessId = D.PolicyBusinessId AND D.CurrentStatusFG = 1 -- CURRENT STATUS 
	INNER JOIN policymanagement..TStatus E ON D.StatusId = E.StatusId AND E.IntelligentOfficeStatusType != @LocalDeleted_Status -- All but Deleted plans wow
	INNER JOIN policymanagement..TPolicyBusinessext ext  on A.PolicyBusinessId = ext.PolicyBusinessId
	INNER JOIN commissions..VwAdviserAndCRABanding rate ON A.TenantId =  rate.IndigoClientID AND  ext.BandingTemplateId = rate.BandingTemplateId -- this tells us exactly which rate to use and if a CRA is going to ovverride it
	LEFT JOIN  TMovement M ON A.TenantId = M.TenantId AND A.PolicyBusinessId = M.PolicyBusinessId AND C.CommissionTypeName = M.IncomeTypeName
	WHERE pb.PolicyStartDate IS NOT NULL 
	AND E.IntelligentOfficeStatusType NOT IN( @LocalDeleted_Status, @LocalNTU_Status) -- All but Deleted/NTU plans wow 
	AND C.RecurringCommissionFg = 0 


	insert into #Plans 
	(TenantId, PolicyBusinessId, SellingAdviserId, RecevingAdviserId, IsPayawayReceived,  CommissionTypeName, IsRecurring, MaxTriggerTimeStamp, PolicyStartDate, CanSnapShot, HasMovement, BandingRate)
	Select distinct A.TenantId, A.PolicyBusinessId, Rate.PractitionerId, rate.CRAPractitionerId, 
		ISNULL(M.IsPayawayReceived,0), C.CommissionTypeName, C.RecurringCommissionFg, 
		A.MaxTriggerTimeStamp, pb.PolicyStartDate, 0, Case When M.MovementID IS NOT NULL THEN 1 ELSE 0 END, rate.BandingRate
	FROM #movementTriggers A
	INNER JOIN TPolicyBusiness pb ON A.TenantId = pb.IndigoClientId AND A.PolicyBusinessId = pb.PolicyBusinessId
	INNER JOIN TPolicyExpectedCommission B ON A.PolicyBusinessId = B.PolicyBusinessId
	INNER JOIN TRefCommissionType C ON B.RefCommissionTypeId = C.RefCommissionTypeId
	INNER JOIN policymanagement..TStatusHistory D ON A.PolicyBusinessId = D.PolicyBusinessId AND D.CurrentStatusFG = 1 -- CURRENT STATUS 
	INNER JOIN policymanagement..TStatus E ON D.StatusId = E.StatusId AND E.IntelligentOfficeStatusType != @LocalDeleted_Status -- All but Deleted plans wow
	INNER JOIN policymanagement..TPolicyBusinessext ext  on A.PolicyBusinessId = ext.PolicyBusinessId
	INNER JOIN commissions..VwAdviserAndCRABanding rate ON A.TenantId =  rate.IndigoClientID AND  ext.BandingTemplateId = rate.BandingTemplateId -- this tells us exactly which rate to use and if a CRA is going to ovverride it
	LEFT JOIN  TMovement M ON A.TenantId = M.TenantId AND A.PolicyBusinessId = M.PolicyBusinessId AND C.CommissionTypeName = M.IncomeTypeName
	LEFT JOIN #Plans p ON A.TenantId = P.TenantId AND A.PolicyBusinessId = p.PolicyBusinessId 
	WHERE p.PolicyBusinessId IS NULL
	AND C.RecurringCommissionFg = 0 

	insert into #Plans -- Deleted innit (Reverted Previous CHange which causes numbers to run away)
	(TenantId, PolicyBusinessId, SellingAdviserId, RecevingAdviserId, IsPayawayReceived,  CommissionTypeName, IsRecurring, MaxTriggerTimeStamp, PolicyStartDate, CanSnapShot, HasMovement, BandingRate, PayawayReceivedPercentage) -- note for deleted , the max trigger date time is used
	Select distinct A.TenantId, A.PolicyBusinessId, m.PractitionerId, m.PractitionerId,  m.IsPayawayReceived, m.IncomeTypeName, M.IsRecurring, 
		A.MaxTriggerTimeStamp, A.MaxTriggerTimeStamp, 0, 1, m.Percentage, m.Percentage
	FROM #movementTriggers A
	INNER JOIN  TMovement M ON A.TenantId = M.TenantId AND A.PolicyBusinessId = M.PolicyBusinessId 
	LEFT JOIN #Plans p ON A.TenantId = P.TenantId AND A.PolicyBusinessId = p.PolicyBusinessId and M.IncomeTypeName = P.CommissionTypeName
	WHERE p.PolicyBusinessId IS NULL
	AND M.IsRecurring= 0 

	-- Remove any rows in #Plans that have Movement Gross or net amounts that sum up larger than max money
	DELETE p FROM #Plans p
	INNER JOIN (
		SELECT m.TenantId, m.PolicyBusinessId, m.PractitionerId, m.IncomeTypeName, m.IsPayawayReceived
		FROM   #Plans    p
		JOIN   TMovement m ON p.TenantId = m.TenantId AND p.PolicyBusinessId = m.PolicyBusinessId AND p.CommissionTypeName = m.IncomeTypeName AND p.RecevingAdviserId = m.PractitionerId AND p.IsPayawayReceived = m.IsPayawayReceived
		GROUP BY m.TenantId, m.PolicyBusinessId, m.PractitionerId, m.IncomeTypeName, m.IsPayawayReceived
		HAVING ABS(SUM(CONVERT(Decimal(24,2), m.GrossAmount))) > @MaxMoney OR ABS(SUM(CONVERT(Decimal(24,2), m.NetAmount))) > @MaxMoney
	) as t ON p.TenantId = t.TenantId AND p.PolicyBusinessId = t.PolicyBusinessId AND p.RecevingAdviserId = t.PractitionerId AND p.CommissionTypeName = t.IncomeTypeName AND p.IsPayawayReceived = t.IsPayawayReceived
	WHERE p.CanSnapShot = 0 AND p.HasMovement = 1 AND p.IsRecurring = 0

	--GET FEES MOFOS!
	IF OBJECT_ID('tempdb..#Fees') IS NOT NULL DROP TABLE #Fees

	CREATE TABLE #Fees(TenantId INT, FeeId INT, LinkedToPolicyBusinessId Int null, IsPayawayReceived INT default(0), SellingAdviserId Int, RecevingAdviserId INT, 
	 IncomeTypeName varchar(200), IsRecurring Int, IsPaidByProvider Int, MaxTriggerTimeStamp datetime, FeeDate datetime, CanSnapShot int default(0), HasMovement int default (0),
		BandingRate decimal (10,2) default(0), GrossAmount money default(0), VATAmount money default(0),   IntroducerAmount money default(0), ClientAmount money default(0), AdviserAmount money default(0), NetAmount money default(0), 
		PayawayReceivedPercentage decimal (10,2) default(0), Introducers varchar(200), Clients varchar(200) , Advisers varchar(200)
	
	)


	insert into #Fees
	(TenantId, FeeId, SellingAdviserId, RecevingAdviserId,  IncomeTypeName, IsRecurring, IsPaidByProvider, MaxTriggerTimeStamp, FeeDate, CanSnapShot, HasMovement, BandingRate, GrossAmount, VATAmount)

	Select distinct MT.TenantId, A.FeeId, Rate.PractitionerId, rate.CRAPractitionerId, E.Name, D.IsRecurring, G.IsPaidByProvider,
		MaxTriggerTimeStamp, 
		Case When D.IsRecurring = 1 THEN A.StartDate ELSE A.SentToClientDate END,
		1, Case When M.MovementID IS NOT NULL THEN 1 ELSE 0 END, rate.BandingRate, 
			
		--Fee amount is IMPORTANT - if it is Cancelled status Then .... it is either 0 OR ... it is the Difference between the Net amount and a Creait note.
		CASE 
			WHEN B.Status = @LocalFee_Cancelled_Status  AND cn.CreditNoteId IS  NULL THEN 0
			
			ELSE A.NetAmount - ISNULL(cn.NetAmount, 0) -- It is possible to change the Status to something other than cancelled before the snapshot ... so ... this Credit note still exists
		END,

		CASE 
			WHEN B.Status = @LocalFee_Cancelled_Status  AND cn.CreditNoteId IS NULL THEN 0
			
			ELSE A.VATAmount - ISNULL(cn.VATAmount, 0) -- It is possible to change the Status to something other than cancelled before the snapshot ... so ... this Credit note still exists
		END
	
	

	FROM #movementTriggers MT
	INNER JOIN policymanagement..TFee A ON MT.TenantId = A.IndigoClientId AND MT.FeeId = A.FeeId
	Inner join policymanagement..VwFeeCurrentStatus B ON A.FeeId = B.FeeID
	inner join policymanagement..TAdviseFeeType C on A.AdviseFeeTypeId = C.AdviseFeeTypeId
	inner join policymanagement..TRefAdviseFeeType D ON c.RefAdviseFeeTypeId = d.RefAdviseFeeTypeId
	INNER join policymanagement..VwFeeChargingType E ON E.TenantId = A.IndigoClientId and A.FeeId = E.FeeId -- NO Charging Type then NO Fee MOVEMENT !!!! BITCHES !!!!
	Inner join policymanagement..TAdvisePaymentType F ON A.AdvisePaymentTypeId = F.AdvisePaymentTypeId
	inner join policymanagement..TRefAdvisePaidBy G On F.RefAdvisePaidById = G.RefAdvisePaidById
	INNER JOIN policymanagement..TFeeRetainerOwner own ON A.IndigoClientId = own.IndigoClientId AND A.FeeId = own.FeeId 
	INNER JOIN commissions..VwAdviserAndCRABanding rate ON rate.IndigoClientID = A.IndigoClientId AND  own.BandingTemplateId = rate.BandingTemplateId -- this tells us exactly which rate to use and if a CRA is going to ovverride it
	LEFT JOIN  TMovement M ON MT.TenantId = M.TenantId AND MT.FeeId = M.FeeId AND E.Name = M.IncomeTypeName
	Left Join TCreditNote cn ON A.IndigoClientId = cn.IndigoClientId AND A.FeeId = cn.FeeId
	WHERE A.SentToClientDate IS NOT NULL

	-- See Ticket IP-22780
	AND B.[Status] in ( @LocalFee_Due_Status, @LocalFee_Paid, @LocalFee_PaymentReceived, @LocalFee_Cancelled_Status)

	AND D.IsRecurring = 0
	--NOTE Fees with no chargin type are wierd !!!!


	--Other Fees
	insert into #Fees
	(TenantId, FeeId, SellingAdviserId, RecevingAdviserId,  IncomeTypeName, IsRecurring, IsPayawayReceived, IsPaidByProvider, MaxTriggerTimeStamp, FeeDate, CanSnapShot, HasMovement, BandingRate, GrossAmount, VATAmount)

	Select distinct MT.TenantId, A.FeeId, Rate.PractitionerId, rate.CRAPractitionerId, E.Name, D.IsRecurring, ISNULL(M.IsPayawayReceived, 0), G.IsPaidByProvider,
		MT.MaxTriggerTimeStamp, 
		Case When D.IsRecurring = 1 THEN A.StartDate ELSE A.SentToClientDate END,
		0, Case When M.MovementID IS NOT NULL THEN 1 ELSE 0 END, rate.BandingRate, 0, 0
	FROM #movementTriggers MT
	INNER JOIN policymanagement..TFee A ON MT.TenantId = A.IndigoClientId AND MT.FeeId = A.FeeId
	Inner join policymanagement..VwFeeCurrentStatus B ON A.FeeId = B.FeeID
	inner join policymanagement..TAdviseFeeType C on A.AdviseFeeTypeId = C.AdviseFeeTypeId
	inner join policymanagement..TRefAdviseFeeType D ON c.RefAdviseFeeTypeId = d.RefAdviseFeeTypeId
	Left join policymanagement..VwFeeChargingType E ON E.TenantId = A.IndigoClientId and A.FeeId = E.FeeId -- NO Charging Type then NO Fee MOVEMENT !!!! BITCHES !!!!
	Inner join policymanagement..TAdvisePaymentType F ON A.AdvisePaymentTypeId = F.AdvisePaymentTypeId
	inner join policymanagement..TRefAdvisePaidBy G On F.RefAdvisePaidById = G.RefAdvisePaidById
	INNER JOIN policymanagement..TFeeRetainerOwner own ON A.IndigoClientId = own.IndigoClientId AND A.FeeId = own.FeeId 
	INNER JOIN commissions..VwAdviserAndCRABanding rate ON rate.IndigoClientID = A.IndigoClientId AND  own.BandingTemplateId = rate.BandingTemplateId -- this tells us exactly which rate to use and if a CRA is going to ovverride it
	LEFT JOIN  TMovement M ON MT.TenantId = M.TenantId AND MT.FeeId = M.FeeId AND E.Name = M.IncomeTypeName
	LEFT JOIN #Fees fee ON A.IndigoClientId = fee.TenantId AND A.FeeId = fee.FeeId 
	WHERE fee.FeeId IS NULL
	AND D.IsRecurring = 0

	--Deleted Fees
	insert into #Fees
	(TenantId, FeeId, SellingAdviserId, RecevingAdviserId,  IncomeTypeName, IsRecurring, IsPayawayReceived, IsPaidByProvider, 
		MaxTriggerTimeStamp, FeeDate, CanSnapShot, HasMovement, BandingRate, GrossAmount, VATAmount, Advisers)
	Select distinct MT.TenantId, M.FeeId, m.PractitionerId, m.PractitionerId, m.IncomeTypeName, M.IsRecurring, M.IsPayawayReceived,0,
		MT.MaxTriggerTimeStamp, MT.MaxTriggerTimeStamp, 0, 1, 0, 0, 0, m.AdviserName
	FROM #movementTriggers MT
	--Inner Join  TMovement M ON MT.TenantId = M.TenantId AND MT.FeeId = M.FeeId 
	Inner Join (
		Select M2.TenantId, M2.FeeId, M2.PractitionerId, M2.IncomeTypeName, M2.IsRecurring, M2.IsPayawayReceived, M2.AdviserName
		From #movementTriggers MT2
		Join TMovement M2 ON MT2.TenantId = M2.TenantId AND MT2.FeeId = M2.FeeId 
		Group By M2.TenantId, M2.FeeId, M2.PractitionerId, M2.IncomeTypeName, M2.IsRecurring, M2.IsPayawayReceived, M2.AdviserName
	) M ON MT.TenantId = M.TenantId AND MT.FeeId = M.FeeId 
	LEFT JOIN #Fees fee ON mt.TenantId = fee.TenantId AND MT.FeeId = fee.FeeId 
	WHERE fee.FeeId IS NULL
	AND M.IsRecurring = 0
	
	-- Lookup banding rate for fee/adviser where the fee still exists
	Update a
	Set BandingRate = rate.BandingRate
	From #Fees a
	INNER JOIN policymanagement..TFeeRetainerOwner own ON A.TenantId = own.IndigoClientId AND A.FeeId = own.FeeId 
	INNER JOIN commissions..VwAdviserAndCRABanding rate ON rate.IndigoClientID = A.TenantId AND  own.BandingTemplateId = rate.BandingTemplateId
	Where rate.BandingRate = 0

	-- look at the most recent audit record to find the banding template where the fee does not exist
	Update a
	Set BandingRate = rate.BandingRate
	From #Fees a
	INNER JOIN (
		Select Max(AuditId) as AuditId, ownAudit2.FeeId, IndigoClientId as TenantId
		From policymanagement..TFeeRetainerOwnerAudit ownAudit2
		join #Fees f on ownAudit2.FeeId = f.FeeId and ownAudit2.IndigoClientId = f.TenantId
		Group by ownAudit2.IndigoClientId, ownAudit2.FeeId
	) lastAudit On a.FeeId = lastAudit.FeeId and a.TenantId = lastAudit.TenantId
	Join policymanagement..TFeeRetainerOwnerAudit own On lastAudit.AuditId = own.AuditId and A.TenantId = own.IndigoClientId
	INNER JOIN commissions..VwAdviserAndCRABanding rate ON rate.IndigoClientID = A.TenantId AND  own.BandingTemplateId = rate.BandingTemplateId
	Where rate.BandingRate = 0


	--Are any Fees linked to Plans
	Update A
		Set A.LinkedToPolicyBusinessId = B.PolicyBusinessId
	From #Fees A
	Inner join 
	(
		Select A.FeeId, Max(PolicyBusinessId) as PolicyBusinessId from #Fees A
		Inner join policymanagement..TFee2Policy B ON A.FeeId = B.FeeId
		group by A.FeeId
	) B ON A.FeeId = B.FeeId


	

-- Get the Expected Amount for plans
Update A
Set A.GrossAmount = ISNULL(B.Amount	, 0)
from #Plans A INNER JOIN 
(
	Select A.PolicyBusinessId, A.CommissionTypeName, Sum(B.ExpectedAmount) as Amount 
	from #Plans A
	inner Join policymanagement..TPolicyExpectedCommission B ON A.PolicyBusinessId = B.PolicyBusinessId
	inner join policymanagement..TRefCommissionType C ON B.RefCommissionTypeId = C.RefCommissionTypeId and A.CommissionTypeName = C.CommissionTypeName
	WHERE A.CanSnapShot = 1
	Group BY A.PolicyBusinessId, A.CommissionTypeName
	
) B ON A.PolicyBusinessId = B.PolicyBusinessId and A.CommissionTypeName = B.CommissionTypeName
WHERE A.CanSnapShot = 1



IF OBJECT_ID('tempdb..#Adjustments') IS NOT NULL DROP TABLE #Adjustments

	CREATE TABLE #Adjustments(TenantId INT, PayAdjustId INT, RecevingAdviserId INT, 
		CommissionTypeName varchar(200), MaxTriggerTimeStamp datetime, CanSnapShot int default(0), HasMovement int default (0),
		NetAmount money default(0)		
	
	)


	insert into #Adjustments
	(TenantId, PayAdjustId, RecevingAdviserId,  CommissionTypeName,  MaxTriggerTimeStamp, CanSnapShot, HasMovement, NetAmount)

	Select distinct MT.TenantId, A.PayAdjustId, B.PractitionerId, T.Descriptor,
		MaxTriggerTimeStamp, 1, Case When M.MovementID IS NOT NULL THEN 1 ELSE 0 END, A.Amount * T.Multiplier

	FROM #MovementTriggers MT
	INNER JOIN commissions..TPayAdjust A ON MT.TenantId = A.IndClientId AND MT.PayAdjustId = A.PayAdjustId
	Inner join commissions..TRefAdjType T ON A.RefAdjTypeId = T.RefAdjTypeId
	INNER JOIN CRM..TPractitioner B ON A.IndClientId = B.IndClientId AND A.CRMContactID = B.CRMContactId -- advisers only
	LEFT JOIN  TMovement M ON MT.TenantId = M.TenantId AND MT.PayAdjustId = M.PayAdjustId AND M.IncomeTypeName = T.Descriptor
	WHERE T.Descriptor != 'System'


	insert into #Adjustments -- deleted 
	(TenantId, PayAdjustId, RecevingAdviserId,  CommissionTypeName,  MaxTriggerTimeStamp, CanSnapShot, HasMovement, NetAmount)

	Select distinct MT.TenantId, M.PayAdjustId,M.PractitionerId, M.IncomeTypeName, MaxTriggerTimeStamp, 0, 1, 0

	FROM #MovementTriggers MT
	left JOIN commissions..TPayAdjust A ON MT.TenantId = A.IndClientId AND MT.PayAdjustId = A.PayAdjustId
	INNER JOIN  TMovement M ON MT.TenantId = M.TenantId AND MT.PayAdjustId = M.PayAdjustId
	Where A.PayAdjustId IS NULL

--Time to #SnapShot !
--Snapshot PLAN SPLITS
Update A
Set 
	A.IntroducerAmount = (( ISNULL(PolicyIntroducerSplits.SplitPercent, 0) * A.GrossAmount) / 100 ),
	A.Introducers = PolicyIntroducerSplits.Introducers,
	A.ClientAmount = (( ISNULL(PolicyClientSplits.SplitPercent, 0) * A.GrossAmount) / 100 ),
	A.Clients = PolicyClientSplits.Clients,
	A.AdviserAmount = (( ISNULL(PolicyAdviserSplits.SplitPercent, 0) * A.GrossAmount) / 100 ),
	A.Advisers = PolicyAdviserSplits.Advisers
FROM #Plans A
LEFT JOIN
(
	--Policy INtroducer Splits
	Select A.PolicyBusinessId, CommissionTypeName, ISNULL(Sum(B.SplitPercent), 0) AS SplitPercent, 
	MIN(ISNULL(D.CorporateName, '') + '' + ISNULL(D.FirstName, '') + ' ' + ISNULL(D.LastName, '')) as Introducers 
	FROM #Plans A
	Inner Join commissions..TSplit B ON A.TenantId  = B.IndClientId AND  A.PolicyBusinessId = B.PolicyId
	inner Join commissions..TPaymentEntity C ON B.PaymentEntityId = C.PaymentEntityId
	inner Join crm..TCRMContact D ON B.PaymentEntityCRMId = D.CRMContactId
	Where 1=1
	AND A.CanSnapShot = 1
	AND ((A.IsRecurring = 0 AND B.InitialFG = 1) OR(A.IsRecurring = 1 AND B.RenewalsFG = 1))
	AND C.RefIntroducerTypeId IS NOT NULL
	Group by A.PolicyBusinessId , CommissionTypeName
) PolicyIntroducerSplits ON A.PolicyBusinessId = PolicyIntroducerSplits.PolicyBusinessId
LEFT JOIN
	(
	--Policy Client Splits
	Select A.PolicyBusinessId, CommissionTypeName, ISNULL(Sum(B.SplitPercent), 0) AS SplitPercent ,
		MIN(ISNULL(D.CorporateName, '') + '' + ISNULL(D.FirstName, '') + ' ' + ISNULL(D.LastName, '')) as Clients 
	FROM #Plans A
	Inner Join commissions..TSplit B ON A.TenantId  = B.IndClientId AND  A.PolicyBusinessId = B.PolicyId
	inner Join commissions..TPaymentEntity C ON B.PaymentEntityId = C.PaymentEntityId
	inner Join crm..TCRMContact D ON B.PaymentEntityCRMId = D.CRMContactId
	Where 1=1
	AND A.CanSnapShot = 1
	AND ((A.IsRecurring = 0 AND B.InitialFG = 1) OR(A.IsRecurring = 1 AND B.RenewalsFG = 1))
	ANd  C.ClientFg = 1
	Group by A.PolicyBusinessId, CommissionTypeName 
) PolicyClientSplits ON A.PolicyBusinessId = PolicyClientSplits.PolicyBusinessId
LEFT JOIN
	(
	--Policy Adviser Splits - Treat Banding Partner ship and normal payway as the same (CDV using 100% banding on 100% Banding partnership is the same as a 100% split)
	Select A.PolicyBusinessId,CommissionTypeName, ISNULL(Sum(B.SplitPercent), 0) AS SplitPercent ,
		MIN(ISNULL(D.CorporateName, '') + '' + ISNULL(D.FirstName, '') + ' ' + ISNULL(D.LastName, '')) as Advisers 
	FROM #Plans A
	Inner Join commissions..TSplit B ON A.TenantId  = B.IndClientId AND  A.PolicyBusinessId = B.PolicyId
	inner Join commissions..TPaymentEntity C ON B.PaymentEntityId = C.PaymentEntityId
	inner Join crm..TCRMContact D ON B.PaymentEntityCRMId = D.CRMContactId
	Where 1=1
	AND A.CanSnapShot = 1
	AND ((A.IsRecurring = 0 AND B.InitialFG = 1) OR(A.IsRecurring = 1 AND B.RenewalsFG = 1))
	and  C.PractitionerFG = 1
	and ISNULL(B.PartnershipType,0) IN (0,1)
	Group by A.PolicyBusinessId , CommissionTypeName
) PolicyAdviserSplits ON A.PolicyBusinessId = PolicyAdviserSplits.PolicyBusinessId
Where 1=1
AND A.CanSnapShot = 1 
-- IP-35695 removed the A.CanSnapShot = 1 becasue 'Introducers' was not updated for canceled fees




Update A
Set GrossAmount = ISNULL(GrossAmount, 0),
	IntroducerAmount = ISNULL(IntroducerAmount, 0),
	ClientAmount = ISNULL(ClientAmount, 0),
	AdviserAmount = ISNULL(AdviserAmount, 0),
	NetAmount = (ISNULL(GrossAmount, 0) - ISNULL(IntroducerAmount, 0) - ISNULL(ClientAmount, 0) - ISNULL(AdviserAmount, 0)) * ISNULL(A.BandingRate, 0) / 100
	From #PLans A
	where  A.CanSnapShot = 1
	

-- Client Paid Fee Splits 
-- IP-38493 Client Paid Fees INitial Splits DO NOT SET THE INITIA FLAG !!!!
Update A
Set 
	A.IntroducerAmount = (( ISNULL(FeeIntroducerSplits.SplitPercent, 0) * A.GrossAmount) / 100 ),
	A.Introducers = FeeIntroducerSplits.Introducers,
	A.ClientAmount = (( ISNULL(FeeClientSplits.SplitPercent, 0) * A.GrossAmount) / 100),
	A.Clients = FeeClientSplits.clients,
	A.AdviserAmount = (( ISNULL(FeeAviserSplits.SplitPercent, 0) * A.GrossAmount) / 100 ),
	A.Advisers = FeeAviserSplits.Advisers
FROM #Fees A
LEFT JOIN
(
	--Fee INtroducer Splits
	Select A.FeeId, IncomeTypeName, Sum(B.SplitPercent) AS splitPercent , 
		MIN(ISNULL(D.CorporateName, '') + '' + ISNULL(D.FirstName, '') + ' ' + ISNULL(D.LastName, '')) as Introducers 
	FROM #Fees A
	Inner Join commissions..TSplit B ON A.TenantId = B.IndClientId and A.FeeId = B.FeeId
	inner Join commissions..TPaymentEntity C ON B.PaymentEntityId = C.PaymentEntityId
	inner Join crm..TCRMContact D ON B.PaymentEntityCRMId = D.CRMContactId
	
	Where 1=1
	AND A.CanSnapShot = 1
	AND ((A.IsRecurring = 0) OR(A.IsRecurring = 1 AND B.RenewalsFG = 1))
	AND C.RefIntroducerTypeId IS NOT NULL
	and A.IsPaidByProvider = 0
	Group by A.FeeId , A.IncomeTypeName

) FeeIntroducerSplits ON A.FeeId = FeeIntroducerSplits.FeeId
LEFT JOIN
(	
	--Fee Client Splits
	Select A.FeeId, IncomeTypeName, Sum(B.SplitPercent) AS splitPercent , 
		MIN(ISNULL(D.CorporateName, '') + '' + ISNULL(D.FirstName, '') + ' ' + ISNULL(D.LastName, '')) as Clients 
	FROM #Fees A
	Inner Join commissions..TSplit B ON A.TenantId = B.IndClientId and A.FeeId = B.FeeId
	inner Join commissions..TPaymentEntity C ON B.PaymentEntityId = C.PaymentEntityId
	inner Join crm..TCRMContact D ON B.PaymentEntityCRMId = D.CRMContactId
	
	Where 1=1
	AND A.CanSnapShot = 1
	AND ((A.IsRecurring = 0) OR(A.IsRecurring = 1 AND B.RenewalsFG = 1))
	AND C.ClientFg = 1
	and A.IsPaidByProvider = 0
	Group by A.FeeId , A.IncomeTypeName
) FeeClientSplits ON A.FeeId = FeeClientSplits.FeeId
LEFT JOIN
(
--Fee Client Splits
	--Fee Client Splits
	Select A.FeeId, IncomeTypeName, Sum(B.SplitPercent) AS splitPercent , 
		MIN(ISNULL(D.CorporateName, '') + '' + ISNULL(D.FirstName, '') + ' ' + ISNULL(D.LastName, '')) as Advisers 
	FROM #Fees A
	Inner Join commissions..TSplit B ON A.TenantId = B.IndClientId and A.FeeId = B.FeeId
	inner Join commissions..TPaymentEntity C ON B.PaymentEntityId = C.PaymentEntityId
	inner Join crm..TCRMContact D ON B.PaymentEntityCRMId = D.CRMContactId
	
	Where 1=1
	AND A.CanSnapShot = 1
	AND ((A.IsRecurring = 0 ) OR(A.IsRecurring = 1 AND B.RenewalsFG = 1))
	and  C.PractitionerFG = 1
	and A.IsPaidByProvider = 0
	AND ISNULL(B.PartnershipType,0) IN (0,1)
	Group by A.FeeId , IncomeTypeName
) FeeAviserSplits ON A.FeeId = FeeAviserSplits.FeeId
Where 1=1
AND A.IsPaidByProvider = 0 -- ONLY CLIENT PAID FEES USE FEE SPLITS
AND A.CanSnapShot = 1
-- IP-35695 removed the A.CanSnapShot = 1 becasue 'Introducers' was not updated for canceled fees
	

	

	
-- provider PAID FEES USE THE  plan split
Update A
Set 
	A.IntroducerAmount = (( ISNULL(FeeIntroducerSplits.SplitPercent, 0) * A.GrossAmount) / 100 ),
	A.Introducers = FeeIntroducerSplits.Introducers,
	A.ClientAmount = (( ISNULL(FeeClientSplits.SplitPercent, 0) * A.GrossAmount) / 100),
	A.Clients = FeeClientSplits.clients,
	A.AdviserAmount = (( ISNULL(FeeAdviserSplits.SplitPercent, 0) * A.GrossAmount) / 100 ),
	A.Advisers = FeeAdviserSplits.Advisers
FROM #Fees A
LEFT JOIN
(
	--Fee INtroducer Splits
	Select A.FeeId, IncomeTypeName, Sum(B.SplitPercent) AS splitPercent , 
		MIN(ISNULL(D.CorporateName, '') + '' + ISNULL(D.FirstName, '') + ' ' + ISNULL(D.LastName, '')) as Introducers 
	FROM #Fees A	
	Inner Join commissions..TSplit B ON A.TenantId = B.IndClientId and A.LinkedToPolicyBusinessId = B.PolicyId -- fees linked to policy Splits
	inner Join commissions..TPaymentEntity C ON B.PaymentEntityId = C.PaymentEntityId
	inner Join crm..TCRMContact D ON B.PaymentEntityCRMId = D.CRMContactId
	Where A.CanSnapShot = 1
	AND ((A.IsRecurring = 0 and b.InitialFG=1) OR(A.IsRecurring = 1 AND B.RenewalsFG = 1))
	AND C.RefIntroducerTypeId IS NOT NULL
	and A.IsPaidByProvider = 1
	Group by A.FeeId , A.IncomeTypeName
) FeeIntroducerSplits ON A.FeeId = FeeIntroducerSplits.FeeId
LEFT JOIN
(	
	--Fee Client Splits
	Select A.FeeId, IncomeTypeName, Sum(B.SplitPercent) AS splitPercent , 
		MIN(ISNULL(D.CorporateName, '') + '' + ISNULL(D.FirstName, '') + ' ' + ISNULL(D.LastName, '')) as Clients 
	FROM #Fees A	
	Inner Join commissions..TSplit B ON A.TenantId = B.IndClientId and A.LinkedToPolicyBusinessId = B.PolicyId -- fees linked to policy Splits
	inner Join commissions..TPaymentEntity C ON B.PaymentEntityId = C.PaymentEntityId
	inner Join crm..TCRMContact D ON B.PaymentEntityCRMId = D.CRMContactId
	Where A.CanSnapShot = 1
	AND ((A.IsRecurring = 0 and b.InitialFG=1) OR(A.IsRecurring = 1 AND B.RenewalsFG = 1))
	AND C.ClientFg = 1
	and A.IsPaidByProvider = 1
	Group by A.FeeId , A.IncomeTypeName
) FeeClientSplits ON A.FeeId = FeeClientSplits.FeeId
LEFT JOIN
	(
	--Fee Adviser Splits
	Select A.FeeId, IncomeTypeName, Sum(B.SplitPercent) AS splitPercent , 
		MIN(ISNULL(D.CorporateName, '') + '' + ISNULL(D.FirstName, '') + ' ' + ISNULL(D.LastName, '')) as Advisers 
	FROM #Fees A	
	Inner Join commissions..TSplit B ON A.TenantId = B.IndClientId and A.LinkedToPolicyBusinessId = B.PolicyId -- fees linked to policy Splits
	inner Join commissions..TPaymentEntity C ON B.PaymentEntityId = C.PaymentEntityId
	inner Join crm..TCRMContact D ON B.PaymentEntityCRMId = D.CRMContactId
	Where A.CanSnapShot = 1
	AND ((A.IsRecurring = 0 and b.InitialFG=1) OR(A.IsRecurring = 1 AND B.RenewalsFG = 1))
	AND C.PractitionerFG = 1
	and A.IsPaidByProvider = 1
	AND ISNULL(B.PartnershipType,0) IN (0,1)
	Group by A.FeeId, IncomeTypeName 
) FeeAdviserSplits ON A.FeeId = FeeAdviserSplits.FeeId
INNER join policymanagement..TFee2Policy ftp ON A.FeeId = ftp.FeeId  --  FEES LINKED TO PLANS use the plansplit
Where A.IsPaidByProvider = 1
and  A.CanSnapShot = 1


Update A
Set GrossAmount = ISNULL(GrossAmount, 0),
	VATAmount = ISNULL(VATAmount, 0),
	IntroducerAmount = ISNULL(IntroducerAmount, 0),
	ClientAmount = ISNULL(ClientAmount, 0),
	AdviserAmount = ISNULL(AdviserAmount, 0),
	NetAmount = (ISNULL(GrossAmount, 0) - ISNULL(IntroducerAmount, 0) - ISNULL(ClientAmount, 0) - ISNULL(AdviserAmount, 0)) * ISNULL(A.BandingRate, 0) / 100
	From #Fees A
	where A.CanSnapShot = 1



INSERT INTO #PLANS
(	TenantId , PolicyBusinessId , IsPayawayReceived, SellingAdviserId , RecevingAdviserId ,  CommissionTypeName , IsRecurring , MaxTriggerTimeStamp, PolicyStartDate , CanSnapShot , HasMovement ,
	 GrossAmount , NetAmount , 
	PayawayReceivedPercentage , Advisers
)
Select
	A.TenantId, A.PolicyBusinessId, 1, PolicyAdviserSplitsReceived.PractitionerId, PolicyAdviserSplitsReceived.CRAPractitionerId,  PolicyAdviserSplitsReceived.CommissionTypeName, A.IsRecurring, A.MaxTriggerTimeStamp, A.PolicyStartDate, A.CanSnapShot, A.HasMovement,
	0, 
	NetAmount = ((ISNULL(PolicyAdviserSplitsReceived.SplitPercent, 0) * A.GrossAmount) / 100 ), 
	PayawayReceivedPercentage = ISNULL(PolicyAdviserSplitsReceived.SplitPercent, 0),
	ISNULL(PolicyAdviserSplitsReceived.Advisers, '')

FROM #Plans A
INNER JOIN
(
	--Policy Adviser Splits - Treat Banding Partner ship and normal payway as the same (CDV using 100% banding on 100% Banding partnership is the same as a 100% split)
	Select A.PolicyBusinessId, cra.PractitionerId, CRA.CRAPractitionerId ,CommissionTypeName, ISNULL(Sum(B.SplitPercent), 0) AS SplitPercent,
		MIN(ISNULL(D.CorporateName, '') + '' + ISNULL(D.FirstName, '') + ' ' + ISNULL(D.LastName, '')) as Advisers  
	FROM #Plans A
	Inner Join commissions..TSplit B ON A.TenantId = B.IndClientId AND  A.PolicyBusinessId = B.PolicyId
	inner Join commissions..TPaymentEntity C ON B.PaymentEntityId = C.PaymentEntityId	
	inner Join crm..TCRMContact D ON B.PaymentEntityCRMId = D.CRMContactId
	Inner join CRM..TPractitioner E ON B.IndClientId = E.IndClientId AND B.PaymentEntityCRMId = E.CRMContactId
	INNER JOIN commissions..VwAdviserAndCRABanding cra ON A.TenantId =  cra.IndigoClientId AND  E.PractitionerId =  cra.PractitionerId -- this tells us exactly which rate to use and if a CRA is going to ovverride it
	Where A.CanSnapShot = 1
	AND ((A.IsRecurring = 0 AND B.InitialFG = 1) OR(A.IsRecurring = 1 AND B.RenewalsFG = 1))
	and  C.PractitionerFG = 1
	and ISNULL(B.PartnershipType,0) IN (0,1)
	Group by A.PolicyBusinessId, cra.PractitionerId, CRA.CRAPractitionerId, PaymentEntityCRMId , CommissionTypeName
) PolicyAdviserSplitsReceived ON A.PolicyBusinessId = PolicyAdviserSplitsReceived.PolicyBusinessId and A.CommissionTypeName = PolicyAdviserSplitsReceived.CommissionTypeName
Where A.CanSnapShot = 1


--Client paid Fees PawayReceived
INSERT INTO #Fees
(	TenantId , FeeId , IsPayawayReceived, SellingAdviserId , RecevingAdviserId ,  IncomeTypeName , IsRecurring, IsPaidByProvider , MaxTriggerTimeStamp, FeeDate , CanSnapShot , HasMovement ,
	 GrossAmount, VATAmount , NetAmount , 
	PayawayReceivedPercentage , Advisers
)
Select
	A.TenantId, A.FeeId, 1, ClientPaidAdviserSplitsReceived.PractitionerId, ClientPaidAdviserSplitsReceived.CRAPractitionerId,  ClientPaidAdviserSplitsReceived.IncomeTypeName, A.IsRecurring, A.IsPaidByProvider, A.MaxTriggerTimeStamp, A.FeeDate, A.CanSnapShot, A.HasMovement,
	0, 0, --Gross and Vat are zero for payaways received
	NetAmount = ((ISNULL(ClientPaidAdviserSplitsReceived.SplitPercent, 0) * A.GrossAmount) / 100 ), 
	PayawayReceivedPercentage = ISNULL(ClientPaidAdviserSplitsReceived.SplitPercent, 0),
	ISNULL(ClientPaidAdviserSplitsReceived.Advisers, '')

FROM #Fees A
INNER JOIN
(
	--Policy Adviser Splits - Treat Banding Partner ship and normal payway as the same (CDV using 100% banding on 100% Banding partnership is the same as a 100% split)
	Select A.FeeId, cra.PractitionerId, CRA.CRAPractitionerId ,IncomeTypeName, ISNULL(Sum(B.SplitPercent), 0) AS SplitPercent ,
		MIN(ISNULL(D.CorporateName, '') + '' + ISNULL(D.FirstName, '') + ' ' + ISNULL(D.LastName, '')) as Advisers  
	FROM #Fees A
	Inner Join commissions..TSplit B ON A.TenantId = B.IndClientId AND  A.FeeId = B.FeeId
	inner Join commissions..TPaymentEntity C ON B.PaymentEntityId = C.PaymentEntityId	
	inner Join crm..TCRMContact D ON B.PaymentEntityCRMId = D.CRMContactId
	Inner join CRM..TPractitioner E ON B.IndClientId = E.IndClientId AND B.PaymentEntityCRMId = E.CRMContactId
	INNER JOIN commissions..VwAdviserAndCRABanding cra ON A.TenantId =  cra.IndigoClientId AND  E.PractitionerId =  cra.PractitionerId -- this tells us exactly which rate to use and if a CRA is going to ovverride it
	Where A.CanSnapShot = 1
	AND ((A.IsRecurring = 0) OR(A.IsRecurring = 1 AND B.RenewalsFG = 1))
	and  C.PractitionerFG = 1
	and ISNULL(B.PartnershipType,0) IN (0,1)
	and A.IsPaidByProvider = 0
	Group by A.FeeId, cra.PractitionerId, CRA.CRAPractitionerId, PaymentEntityCRMId , IncomeTypeName
) ClientPaidAdviserSplitsReceived ON A.FeeId = ClientPaidAdviserSplitsReceived.FeeId and A.IncomeTypeName = ClientPaidAdviserSplitsReceived.IncomeTypeName
Where A.CanSnapShot = 1
and A.IsPaidByProvider = 0



--Provider paid Fees PawayReceived
INSERT INTO #Fees
(	TenantId , FeeId, LinkedToPolicyBusinessId , IsPayawayReceived, SellingAdviserId , RecevingAdviserId ,  IncomeTypeName , IsRecurring , IsPaidByProvider, MaxTriggerTimeStamp, FeeDate , CanSnapShot , HasMovement ,
	 GrossAmount, VATAmount , NetAmount , 
	PayawayReceivedPercentage , Advisers
)
Select
	A.TenantId, A.FeeId, A.LinkedToPolicyBusinessId, 1, ClientPaidAdviserSplitsReceived.PractitionerId, ClientPaidAdviserSplitsReceived.CRAPractitionerId,  ClientPaidAdviserSplitsReceived.IncomeTypeName, A.IsRecurring, A.IsPaidByProvider, A.MaxTriggerTimeStamp, A.FeeDate, A.CanSnapShot, A.HasMovement,
	0, 0,
	NetAmount = ((ISNULL(ClientPaidAdviserSplitsReceived.SplitPercent, 0) * A.GrossAmount) / 100 ), 
	PayawayReceivedPercentage = ISNULL(ClientPaidAdviserSplitsReceived.SplitPercent, 0),
	ISNULL(ClientPaidAdviserSplitsReceived.Advisers, '')

FROM #Fees A
INNER JOIN
(
	--Policy Adviser Splits - Treat Banding Partner ship and normal payway as the same (CDV using 100% banding on 100% Banding partnership is the same as a 100% split)
	Select A.FeeId, cra.PractitionerId, CRA.CRAPractitionerId ,IncomeTypeName, ISNULL(Sum(B.SplitPercent), 0) AS SplitPercent ,
		MIN(ISNULL(D.CorporateName, '') + '' + ISNULL(D.FirstName, '') + ' ' + ISNULL(D.LastName, '')) as Advisers  
	FROM #Fees A
	Inner Join commissions..TSplit B ON A.TenantId = B.IndClientId AND  A.LinkedToPolicyBusinessId = B.PolicyId -- Provider paid fees use Policy Splits
	inner Join commissions..TPaymentEntity C ON B.PaymentEntityId = C.PaymentEntityId	
		inner Join crm..TCRMContact D ON B.PaymentEntityCRMId = D.CRMContactId
	Inner join CRM..TPractitioner E ON B.IndClientId = E.IndClientId AND B.PaymentEntityCRMId = E.CRMContactId
	INNER JOIN commissions..VwAdviserAndCRABanding cra ON A.TenantId =  cra.IndigoClientId AND  E.PractitionerId =  cra.PractitionerId -- this tells us exactly which rate to use and if a CRA is going to ovverride it
	Where A.CanSnapShot = 1
	AND ((A.IsRecurring = 0 and B.InitialFG=1) OR(A.IsRecurring = 1 AND B.RenewalsFG = 1))
	and  C.PractitionerFG = 1
	and ISNULL(B.PartnershipType,0) IN (0,1)
	and A.IsPaidByProvider = 1
	Group by A.FeeId, cra.PractitionerId, CRA.CRAPractitionerId, PaymentEntityCRMId , IncomeTypeName
) ClientPaidAdviserSplitsReceived ON A.FeeId = ClientPaidAdviserSplitsReceived.FeeId and A.IncomeTypeName = ClientPaidAdviserSplitsReceived.IncomeTypeName
Where A.CanSnapShot = 1
and A.IsPaidByProvider = 1





--All Plan movements that Don't exist must exist :-)
Insert into TMovement 
Select TenantId, RecevingAdviserId,  PolicyBusinessId, null, null, IsRecurring, null, IsPayawayReceived, 
	Case When PolicyStartDate > MaxTriggerTimeStamp Then PolicyStartDate Else MaxTriggerTimeStamp End, 
	getdate(),  CommissionTypeName, Case when IsPayawayReceived = 0 Then BandingRate Else PayawayReceivedPercentage END,
	GrossAmount,  IntroducerAmount, Introducers, ClientAmount, Clients, AdviserAmount, Advisers, NetAmount, 0, @LastRunDateTime

from #Plans
Where CanSnapShot = 1 and HasMovement = 0	
	

--All Fee movements that Don't exist must exist :-)
Insert into TMovement 
Select TenantId, RecevingAdviserId,  null, FeeId, LinkedToPolicyBusinessId, IsRecurring, null, IsPayawayReceived, 
	Case when FeeDate > MaxTriggerTimeStamp Then FeeDate else MaxTriggerTimeStamp end, 
	getdate(),  IncomeTypeName, Case when IsPayawayReceived = 0 Then BandingRate Else PayawayReceivedPercentage END, 
	GrossAmount,  IntroducerAmount, Introducers, ClientAmount, Clients, AdviserAmount, Advisers, NetAmount, VATAmount, @LastRunDateTime

from #Fees
Where CanSnapShot = 1 and HasMovement = 0	
	
	



--All Adjusment movements that Don't exist must exist :-)
Insert into TMovement 
Select TenantId, RecevingAdviserId,  null, null, null, 0, PayAdjustId, 0, MaxTriggerTimeStamp, getdate(),  CommissionTypeName, 0, 0, 0, null, 0, null, 0, null,  NetAmount, 0, @LastRunDateTime

from #Adjustments
Where CanSnapShot = 1 and HasMovement = 0	

	IF OBJECT_ID('tempdb..#PlanMovementSnapShot') IS NOT NULL DROP TABLE #PlanMovementSnapShot

	CREATE TABLE #PlanMovementSnapShot(ExistsInPlans int, TenantId INT, PolicyBusinessId INT, IsRecurring int, CommissionTypeName varchar(200), IsPayawayReceived INT default(0), RecevingAdviserId INT, 
		LastTriggeredTimeStamp datetime, GrossAmount money, VATAmount money,   IntroducerAmount money, IntroducerName varchar(200) , ClientAmount money, ClientName varchar(200), AdviserAmount money, AdviserName varchar(200), NetAmount money
	
	)
	
	--These Are Plan Movements that are new or exist in the current snapshot - i.e.e split added or edited
	Insert into #PlanMovementSnapShot
	Select 1, A.TenantId, A.PolicyBusinessId, A.IsRecurring, A.CommissionTypeName, A.IsPayawayReceived, A.RecevingAdviserId,
		Max(ISNULL(B.MovementDateTime, A.MaxTriggerTimeStamp)) as MaxMovementTriggerDate,
		Sum(ISNULL(B.GrossAmount, 0)) as GrossAmount,
		Sum(ISNULL(B.VATAmount, 0)) as VATAmount,
		Sum(ISNULL(B.IntroducerAmount, 0)) as IntroducerAmount,
		COALESCE(A.Introducers, Max(b.IntroducerName)),
		Sum(ISNULL(B.ClientAmount, 0)) as ClientAmount,
		A.Clients,
		Sum(ISNULL(B.AdviserAmount, 0)) as AdviserAmount,
		A.Advisers,
		Sum(ISNULL(B.NetAmount, 0)) as NetAmount
	from #Plans A
	Left Join TMovement B ON A.TenantId = B.TenantId AND A.PolicyBusinessId = B.PolicyBusinessId And A.CommissionTypeName = B.IncomeTypeName and A.IsPayawayReceived = B.IsPayawayReceived And A.RecevingAdviserId = B.PractitionerId
	Where HasMovement = 1
	Group By A.TenantId, A.PolicyBusinessId, A.IsRecurring, A.CommissionTypeName, A.IsPayawayReceived, A.RecevingAdviserId, A.Introducers,A.Clients, A.Advisers
	
	--These are Plan movements that exist  but are NOT in the the current snapshot - i.e.e  Split deleted
	Insert into #PlanMovementSnapShot
	Select 0, A.TenantId, A.PolicyBusinessId, A.IsRecurring, A.IncomeTypeName, A.IsPayawayReceived, A.PractitionerId,
		Max(A.MovementDateTime) as MaxMovementTriggerDate,
		Sum(A.GrossAmount) as GrossAmount,
		Sum(A.VATAmount) as VATAmount,
		Sum(A.IntroducerAmount) as IntroducerAmount,
		A.IntroducerName,
		Sum(A.ClientAmount) as ClientAmount,
		A.ClientName,
		Sum(A.AdviserAmount) as AdviserAmount,
		A.AdviserName,
		Sum(A.NetAmount) as NetAmount
	from TMovement A
	Inner join 
	(
		Select distinct A.TenantId , A.PolicyBusinessId , A.CommissionTypeName, Max(MaxTriggerTimeStamp) as MaxtriggerTimeStamp  from #Plans A where  HasMovement = 1
		Group By A.TenantId , A.PolicyBusinessId , A.CommissionTypeName
	) C ON A.TenantId = C.TenantId and A.PolicyBusinessId = C.PolicyBusinessId and A.IncomeTypeName = C.CommissionTypeName
	Left Join #Plans B ON A.TenantId = B.TenantId AND A.PolicyBusinessId = B.PolicyBusinessId And A.IncomeTypeName = B.CommissionTypeName and A.IsPayawayReceived = B.IsPayawayReceived And A.PractitionerId = B.RecevingAdviserId
	WHERE B.PolicyBusinessId IS NULL
	Group By  A.TenantId, A.PolicyBusinessId, A.IsRecurring, A.IncomeTypeName, A.IsPayawayReceived, A.PractitionerId, a.IntroducerName, A.ClientName, A.AdviserName
	
	IF OBJECT_ID('tempdb..#FeeMovementSnapShot') IS NOT NULL DROP TABLE #FeeMovementSnapShot

	CREATE TABLE #FeeMovementSnapShot(ExistsInFees int, TenantId INT, FeeId INT, LinkedToPolicyBusinessId INT, IsRecurring INT, IncomeTypeName varchar(200), IsPayawayReceived INT default(0), RecevingAdviserId INT, 
		LastTriggeredTimeStamp datetime, GrossAmount money, VATAmount money,  IntroducerAmount money, IntroducerName varchar(200) , ClientAmount money, ClientName varchar(200), AdviserAmount money, AdviserName varchar(200), NetAmount money
	
	)
	



	--These Are Fee Movements that are new or exist in the current snapshot - i.e.e split added or edited
	Insert into #FeeMovementSnapShot
	Select 1, A.TenantId, A.FeeId, A.LinkedToPolicyBusinessId, A.IsRecurring, A.IncomeTypeName, A.IsPayawayReceived, A.RecevingAdviserId,
		Max(ISNULL(B.MovementDateTime, A.MaxTriggerTimeStamp)) as MaxMovementTriggerDate,
		Sum(ISNULL(B.GrossAmount, 0)) as GrossAmount,
		Sum(ISNULL(B.VATAmount, 0)) as VATAmount,
		Sum(ISNULL(B.IntroducerAmount, 0)) as IntroducerAmount,
		COALESCE(A.Introducers, Max(b.IntroducerName)),
		Sum(ISNULL(B.ClientAmount, 0)) as ClientAmount,
		A.Clients,
		Sum(ISNULL(B.AdviserAmount, 0)) as AdviserAmount,
		A.Advisers,
		Sum(ISNULL(B.NetAmount, 0)) as NetAmount
	from #Fees A
	Left Join TMovement B ON A.TenantId = B.TenantId AND A.FeeId = B.FeeId And A.IncomeTypeName = B.IncomeTypeName and A.IsPayawayReceived = B.IsPayawayReceived And A.RecevingAdviserId = B.PractitionerId
	Where HasMovement = 1
	Group By A.TenantId, A.FeeId, A.LinkedToPolicyBusinessId, A.IsRecurring, A.IncomeTypeName, A.IsPayawayReceived, A.RecevingAdviserId, A.Introducers,A.Clients, A.Advisers



	
	--These are Fee movements that exist  but are NOT in the the current snapshot - i.e.e  Split deleted
	Insert into #FeeMovementSnapShot
	Select 0, A.TenantId, A.FeeId, C.LinkedToPolicyBusinessId, A.IsRecurring, A.IncomeTypeName, A.IsPayawayReceived, A.PractitionerId,
		Max(A.MovementDateTime) as MaxMovementTriggerDate,
		Sum(A.GrossAmount) as GrossAmount,
		Sum(A.VATAmount) as VATAmount,
		Sum(A.IntroducerAmount) as IntroducerAmount,
		A.IntroducerName,
		Sum(A.ClientAmount) as ClientAmount,
		A.ClientName,
		Sum(A.AdviserAmount) as AdviserAmount,
		A.AdviserName,
		Sum(A.NetAmount) as NetAmount
	from TMovement A
	Inner join 
	(
		Select distinct A.TenantId , A.FeeId, A.LinkedToPolicyBusinessId , A.IncomeTypeName, Max(MaxTriggerTimeStamp) as MaxtriggerTimeStamp  from #Fees A where  HasMovement = 1
		Group By A.TenantId , A.FeeId,  A.LinkedToPolicyBusinessId , A.IncomeTypeName
	) C ON A.TenantId = C.TenantId and A.FeeId = C.FeeId and A.IncomeTypeName = C.IncomeTypeName
	Left Join #Fees B ON A.TenantId = B.TenantId AND A.FeeId = B.FeeId And A.IncomeTypeName = B.IncomeTypeName and A.IsPayawayReceived = B.IsPayawayReceived And A.PractitionerId = B.RecevingAdviserId
	WHERE B.FeeId IS NULL
	Group By  A.TenantId, A.FeeId,  C.LinkedToPolicyBusinessId, A.IsRecurring, A.IncomeTypeName, A.IsPayawayReceived, A.PractitionerId, a.IntroducerName, A.ClientName, A.AdviserName


	IF OBJECT_ID('tempdb..#AdjustmentSnapShot') IS NOT NULL DROP TABLE #AdjustmentSnapShot

	CREATE TABLE #AdjustmentSnapShot(ExistsInAdjustments int, TenantId INT, PayAdjustId INT, CommissionTypeName varchar(200), RecevingAdviserId INT, 
		LastTriggeredTimeStamp datetime, NetAmount money
	
	)
	
	
	--These Are Adjustment Movements that are new or exist in the current snapshot - i.e.e  added or edited
	Insert into #AdjustmentSnapShot
	Select 1, A.TenantId, A.PayAdjustId, A.CommissionTypeName, A.RecevingAdviserId,
		Max(ISNULL(B.MovementDateTime, A.MaxTriggerTimeStamp)) as MaxMovementTriggerDate,
		Sum(ISNULL(B.NetAmount, 0)) as NetAmount
	from #Adjustments A
	Left Join TMovement B ON A.TenantId = B.TenantId AND A.PayAdjustId = B.PayAdjustId And A.CommissionTypeName = B.IncomeTypeName And A.RecevingAdviserId = B.PractitionerId
	Where HasMovement = 1
	Group By A.TenantId,  A.PayAdjustId, A.CommissionTypeName,  A.RecevingAdviserId


	
	--These are Fee movements that exist  but are NOT in the the current snapshot - i.e.e   deleted
	Insert into #AdjustmentSnapShot
	Select 0, A.TenantId, A.PayAdjustId, A.IncomeTypeName, A.PractitionerId,
		Max(A.MovementDateTime) as MaxMovementTriggerDate,
		Sum(A.NetAmount) as NetAmount
	from TMovement A
	Inner join 
	(
		Select distinct A.TenantId , A.PayAdjustId , A.CommissionTypeName, Max(MaxTriggerTimeStamp) as MaxtriggerTimeStamp  from #Adjustments A where  HasMovement = 1
		Group By A.TenantId , A.PayAdjustId , A.CommissionTypeName
	) C ON A.TenantId = C.TenantId and A.PayAdjustId = C.PayAdjustId 
	Left Join #Adjustments B ON A.TenantId = B.TenantId AND A.PayAdjustId = B.PayAdjustId And A.PractitionerId = B.RecevingAdviserId
	WHERE B.CanSnapShot = 0
	Group By  A.TenantId, A.PayAdjustId, A.IncomeTypeName, A.PractitionerId

	
	----OKAAAY MOVEMENT TIMEEEEEEEE
	
	--Plan Movements
	INSERT INTO TMovement
	
	Select  TenantId, RecevingAdviserId,  PolicyBusinessId, null, null, IsRecurring, null, IsPayawayReceived,  
		Case When PolicyStartDate > MaxTriggerTimeStamp Then PolicyStartDate Else MaxTriggerTimeStamp End, 
		getdate(),  CommissionTypeName, ISNULL(Percentage, 0), 
		GrossAmountDifference, IntroducerAmountDifference, Introducers, ClientAmountDifference, Clients, AdviserAmountDifference, Advisers, NetAmountDifference, 0, @LastRunDateTime
	
	FROM (
			Select A.TenantId, A.MaxTriggerTimeStamp, A.PolicyStartDate, A.IsPayawayReceived, A.RecevingAdviserId, A.PolicyBusinessId, A.IsRecurring, A.CommissionTypeName, 
			Case when A.IsPayawayReceived = 0 Then A.BandingRate Else A.PayawayReceivedPercentage END as Percentage,  
			ISNULL(a.GrossAmount, 0) - ISNULL(b.GrossAmount, 0) AS GrossAmountDifference, 
			ISNULL(a.IntroducerAmount, 0) - ISNULL(b.IntroducerAmount, 0) AS IntroducerAmountDifference,
			A.Introducers,
			ISNULL(a.ClientAmount, 0) - ISNULL(b.ClientAmount, 0)AS ClientAmountDifference,
			A.Clients,
			ISNULL(a.AdviserAmount, 0) - ISNULL(b.AdviserAmount, 0)AS AdviserAmountDifference,
			A.Advisers,
			ISNULL(a.NetAmount, 0) - ISNULL(b.NetAmount, 0)AS NetAmountDifference		

			from #Plans A
			INNER JOIN #PlanMovementSnapShot  B ON A.TenantId = B.TenantId AND A.PolicyBusinessId = B.PolicyBusinessId and A.CommissionTypeName = B.CommissionTypeName and A.IsPayawayReceived = B.IsPayawayReceived AND A.RecevingAdviserId = B.RecevingAdviserId
			WHERE HasMovement = 1 AND B.ExistsInPlans = 1
			AND (ISNULL(a.GrossAmount, 0) - ISNULL(b.GrossAmount, 0) != 0
				OR	ISNULL(a.IntroducerAmount, 0) - ISNULL(b.IntroducerAmount, 0) != 0
				OR	ISNULL(a.ClientAmount, 0) - ISNULL(b.ClientAmount, 0)!= 0
				OR	ISNULL(a.AdviserAmount, 0) - ISNULL(b.AdviserAmount, 0)!= 0
				OR	ISNULL(a.NetAmount, 0) - ISNULL(b.NetAmount, 0)!= 0
			)
	
			UNION ALL

			Select A.TenantId, C.MaxTriggerTimeStamp, C.PolicyStartDate, A.IsPayawayReceived, A.RecevingAdviserId, A.PolicyBusinessId, A.IsRecurring, A.CommissionTypeName, 
				Case when B.IsPayawayReceived = 0 Then B.BandingRate Else B.PayawayReceivedPercentage END as Percentage,   
				ISNULL(b.GrossAmount, 0) - ISNULL(a.GrossAmount, 0), 
				ISNULL(b.IntroducerAmount, 0) - ISNULL(a.IntroducerAmount, 0),
				A.IntroducerName,
				ISNULL(b.ClientAmount, 0) - ISNULL(a.ClientAmount, 0),
				A.ClientName,
				ISNULL(b.AdviserAmount, 0) - ISNULL(a.AdviserAmount, 0),
				A.AdviserName,
				ISNULL(b.NetAmount, 0) - ISNULL(a.NetAmount, 0)

			from #PlanMovementSnapShot A
			Inner join 
			(
				Select distinct A.TenantId , A.PolicyBusinessId , A.CommissionTypeName, Max(MaxTriggerTimeStamp) as MaxtriggerTimeStamp, Max(PolicyStartDate) as PolicyStartDate  from #Plans A where  HasMovement = 1
				Group By A.TenantId , A.PolicyBusinessId , A.CommissionTypeName
			) C ON A.TenantId = C.TenantId and A.PolicyBusinessId = C.PolicyBusinessId and A.CommissionTypeName = C.CommissionTypeName
			Left JOIN #Plans  B ON A.TenantId = B.TenantId AND A.PolicyBusinessId = B.PolicyBusinessId and A.CommissionTypeName = B.CommissionTypeName and A.IsPayawayReceived = B.IsPayawayReceived AND A.RecevingAdviserId = B.RecevingAdviserId
			WHERE  A.ExistsInPlans = 0 AND B.PolicyBusinessId IS NULL
			AND (ISNULL(b.GrossAmount, 0) - ISNULL(a.GrossAmount, 0) != 0
				OR	ISNULL(b.IntroducerAmount, 0) - ISNULL(a.IntroducerAmount, 0) != 0
				OR	ISNULL(b.ClientAmount, 0) - ISNULL(a.ClientAmount, 0)!= 0
				OR	ISNULL(b.AdviserAmount, 0) - ISNULL(a.AdviserAmount, 0)!= 0
				OR	ISNULL(b.NetAmount, 0) - ISNULL(a.NetAmount, 0)!= 0
			)
	
	
		) AS PlanMovements



	--Fee MOvemnets
	INSERT INTO TMovement	
	Select  TenantId, RecevingAdviserId,  null, FeeId, LinkedToPolicyBusinessId, IsRecurring, null, IsPayawayReceived,  
		Case When FeeDate > MaxTriggerTimeStamp Then FeeDate Else MaxTriggerTimeStamp End,
		getdate(),  IncomeTypeName, isnull(Percentage,0),
		GrossAmountDifference, IntroducerAmountDifference, Introducers, ClientAmountDifference, Clients, AdviserAmountDifference, Advisers, NetAmountDifference, VATAmountDifference, @LastRunDateTime
	
	FROM (
			Select A.TenantId, A.MaxTriggerTimeStamp, A.FeeDate, A.IsPayawayReceived, A.RecevingAdviserId, A.FeeId, A.LinkedToPolicyBusinessId, A.IsRecurring, A.IncomeTypeName,  
				Case when A.IsPayawayReceived = 0 Then A.BandingRate Else A.PayawayReceivedPercentage END as Percentage,  
				ISNULL(a.GrossAmount, 0) - ISNULL(b.GrossAmount, 0) AS GrossAmountDifference, 
				ISNULL(a.VATAmount, 0) - ISNULL(b.VATAmount, 0) AS VATAmountDifference, 
				ISNULL(a.IntroducerAmount, 0) - ISNULL(b.IntroducerAmount, 0) AS IntroducerAmountDifference,
				a.Introducers,
				ISNULL(a.ClientAmount, 0) - ISNULL(b.ClientAmount, 0)AS ClientAmountDifference,
				a.Clients,
				ISNULL(a.AdviserAmount, 0) - ISNULL(b.AdviserAmount, 0)AS AdviserAmountDifference,
				A.Advisers,
				ISNULL(a.NetAmount, 0) - ISNULL(b.NetAmount, 0)AS NetAmountDifference		

			from #Fees A
			INNER JOIN #FeeMovementSnapShot  B ON A.TenantId = B.TenantId AND A.FeeId = B.FeeId and A.IncomeTypeName = B.IncomeTypeName and A.IsPayawayReceived = B.IsPayawayReceived AND A.RecevingAdviserId = B.RecevingAdviserId
			WHERE HasMovement = 1 AND B.ExistsInFees = 1
			AND (ISNULL(a.GrossAmount, 0) - ISNULL(b.GrossAmount, 0) != 0
				OR	ISNULL(a.VATAmount, 0) - ISNULL(b.VATAmount, 0) != 0
				OR	ISNULL(a.IntroducerAmount, 0) - ISNULL(b.IntroducerAmount, 0) != 0
				OR	ISNULL(a.ClientAmount, 0) - ISNULL(b.ClientAmount, 0)!= 0
				OR	ISNULL(a.AdviserAmount, 0) - ISNULL(b.AdviserAmount, 0)!= 0
				OR	ISNULL(a.NetAmount, 0) - ISNULL(b.NetAmount, 0)!= 0
			)
	
			UNION ALL

			Select A.TenantId, C.MaxTriggerTimeStamp, C.FeeDate, A.IsPayawayReceived, A.RecevingAdviserId, A.FeeId, A.LinkedToPolicyBusinessId, A.IsRecurring, A.IncomeTypeName, 
				Case when A.IsPayawayReceived = 0 Then B.BandingRate Else B.PayawayReceivedPercentage END as Percentage,  
				ISNULL(b.GrossAmount, 0) - ISNULL(a.GrossAmount, 0), 
				ISNULL(b.VATAmount, 0) - ISNULL(a.VATAmount, 0), 
				ISNULL(b.IntroducerAmount, 0) - ISNULL(a.IntroducerAmount, 0),
				A.IntroducerName,
				ISNULL(b.ClientAmount, 0) - ISNULL(a.ClientAmount, 0),
				A.ClientName,
				ISNULL(b.AdviserAmount, 0) - ISNULL(a.AdviserAmount, 0),
				A.AdviserName,
				ISNULL(b.NetAmount, 0) - ISNULL(a.NetAmount, 0)

			from #FeeMovementSnapShot A
			Inner join 
			(
				Select distinct A.TenantId , A.FeeId , A.IncomeTypeName, Max(MaxTriggerTimeStamp) as MaxtriggerTimeStamp, Max(FeeDate) as FeeDate  from #Fees A where  HasMovement = 1
				Group By A.TenantId , A.FeeId , A.IncomeTypeName
			) C ON A.TenantId = C.TenantId and A.FeeId = C.FeeId and A.IncomeTypeName = C.IncomeTypeName
			Left JOIN #Fees  B ON A.TenantId = B.TenantId AND A.FeeId = B.FeeId and A.IncomeTypeName = B.IncomeTypeName and A.IsPayawayReceived = B.IsPayawayReceived AND A.RecevingAdviserId = B.RecevingAdviserId
			WHERE  A.ExistsInFees = 0 AND B.FeeId IS NULL
			AND (ISNULL(b.GrossAmount, 0) - ISNULL(a.GrossAmount, 0) != 0
				OR	ISNULL(b.VATAmount, 0) - ISNULL(a.VATAmount, 0) != 0
				OR	ISNULL(b.IntroducerAmount, 0) - ISNULL(a.IntroducerAmount, 0) != 0
				OR	ISNULL(b.ClientAmount, 0) - ISNULL(a.ClientAmount, 0)!= 0
				OR	ISNULL(b.AdviserAmount, 0) - ISNULL(a.AdviserAmount, 0)!= 0
				OR	ISNULL(b.NetAmount, 0) - ISNULL(a.NetAmount, 0)!= 0
			)
	
		) AS FeeMovements


	

	--Adjustment MOvemnets
	INSERT INTO TMovement	
	Select  TenantId, RecevingAdviserId,  null, null, null,0,  PayAdjustId, 0, MaxTriggerTimeStamp, getdate(),  CommissionTypeName, 0, 
			0, 0, null, 0, null, 0, null, NetAmountDifference, 0, @LastRunDateTime
	
	FROM (
			Select A.TenantId, A.MaxTriggerTimeStamp, A.RecevingAdviserId, A.PayAdjustId, A.CommissionTypeName,  
				ISNULL(a.NetAmount, 0) - ISNULL(b.NetAmount, 0) AS NetAmountDifference		

			from #Adjustments A
			INNER JOIN #AdjustmentSnapShot  B ON A.TenantId = B.TenantId AND A.PayAdjustId = B.PayAdjustId and A.CommissionTypeName = B.CommissionTypeName AND A.RecevingAdviserId = B.RecevingAdviserId
			WHERE HasMovement = 1 AND B.ExistsInAdjustments = 1
			AND (ISNULL(a.NetAmount, 0) - ISNULL(b.NetAmount, 0)!= 0
			)
	
			UNION ALL
			
			Select A.TenantId, C.MaxTriggerTimeStamp, A.RecevingAdviserId, A.PayAdjustId, A.CommissionTypeName, 
				ISNULL(a.NetAmount, 0) - ISNULL(b.NetAmount, 0) AS NetAmountDifference	

			from #AdjustmentSnapShot A
			Inner join 
			(
				Select distinct A.TenantId , A.PayAdjustId , A.CommissionTypeName, Max(MaxTriggerTimeStamp) as MaxtriggerTimeStamp  from #Adjustments A where  HasMovement = 1
				Group By A.TenantId , A.PayAdjustId , A.CommissionTypeName
			) C ON A.TenantId = C.TenantId and A.PayAdjustId = C.PayAdjustId and A.CommissionTypeName = C.CommissionTypeName
			Left JOIN #Adjustments  B ON A.TenantId = B.TenantId AND A.PayAdjustId = B.PayAdjustId and A.CommissionTypeName = B.CommissionTypeName  AND A.RecevingAdviserId = B.RecevingAdviserId
			WHERE  A.ExistsInAdjustments = 0 AND B.PayAdjustId IS NULL
			AND (ISNULL(b.NetAmount, 0) - ISNULL(a.NetAmount, 0)!= 0
			)
	
		) AS AdjustmentMovements




	--Select top 1000 * from policymanagement..TMovement 
	--where policybusinessid = 1060
	--order by 1 desc

----Delete from TMovement where movementid = 60
--	--Select * from policymanagement..TMovement 
--	--where policybusinessid = 1060
--	--order by PolicyBusinessId desc, IncomeTypeName, IsPayawayReceived desc, PractitionerId , CreatedDateTime desc
	