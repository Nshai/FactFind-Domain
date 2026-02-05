SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomGetFeeNextDueDates]	
	@FeeIds  VARCHAR(8000),
	@TenantId BIGINT,
	@CurrentUserDate datetime
AS

--DECLARE	@FeeIds  VARCHAR(8000) ='1032,1033,1034,1035,1036,1037,1038,1039,1040,1041,1042,1043,1047,1048,1049,1059,1060,1061,1062,1063,1064,1065,1066,1067,1068,1069,1070,1071,1072,1073,1074,1075,1076,1044,1045,1046,1050,1051,1052,1053,1054,1055,1056,1057,1058,1077,1078,1079,1080,1081,1029,1030,1031';
--DECLARE @TenantId INT = 10155;

DECLARE @FeeList TABLE (FeeId bigint PRIMARY KEY) 

INSERT INTO @FeeList(FeeId)
SELECT CONVERT(INT, ISNULL(Value, '0'))   FROM  policymanagement.dbo.FnSplit(@FeeIds, ',') parslist 

-- Get Previous statuses for fees
IF OBJECT_ID('tempdb..#PreviousFeeStatuses') IS NOT NULL DROP TABLE #PreviousFeeStatuses

SELECT feeid, feestatusid into #PreviousFeeStatuses FROM
(
SELECT   this.FeeId, FeeStatusId, this.[Status], row_number() over(partition by this.feeid order by this.FeeStatusId desc ) r_number
		FROM   PolicyManagement.dbo.TFeeStatus this
		JOIN @FeeList fl on fl.FeeId = this.FeeId
) a where r_number = 2

-- Get Current statuses for fees
IF OBJECT_ID('tempdb..#CurrentFeeStatuses') IS NOT NULL
DROP TABLE #CurrentFeeStatuses

SELECT this.FeeId, MAX(this.FeeStatusId) as FeeStatusId INTO #CurrentFeeStatuses
		FROM   PolicyManagement.dbo.TFeeStatus this
		JOIN @FeeList feeList  ON this.FeeId = feeList.FeeId	
		GROUP BY this.FeeId

	
IF OBJECT_ID('tempdb..#fees') IS NOT NULL DROP TABLE #fees

SELECT DISTINCT fee.feeid,
                fee.indigoclientid,
                fee.nextduedate,
                fee.isrecurring,
                feeStatus.feestatusid,
                feeStatus.[status] CurrenStatus,
				prevfeeStatus.FeeStatusId PreviousStatusId,
				prevfeeStatus.[Status] PreviousStatus,
                fee.startdate,
                fee.enddate,
                fee.advisefeetypeid,
                refadvisefeeType.refadvisefeetypeid,
                refadvisefeeType.NAME  RefAdviseFeeTypeName,
                reffeecharginType.refadvisefeechargingtypeid,
                reffeecharginType.NAME AdviseFeeChargingTypeName,
                feeInstalment.nextinstalmentdate Nextinstallmentdate,
                feeRecurrence.nextexpectationdate NextRecurrenceDueDate
INTO  #fees
FROM   policymanagement.dbo.tfee fee
		JOIN @FeeList feeList
				ON fee.FeeId = feeList.FeeId

		JOIN #CurrentFeeStatuses currentStatus 
				ON fee.feeid = currentStatus.FeeId
		JOIN policymanagement.dbo.tfeestatus feeStatus
				ON currentStatus.FeeStatusId = feeStatus.FeeStatusId

		LEFT JOIN #PreviousFeeStatuses previousStatus
				ON fee.feeid = previousStatus.FeeId 
		LEFT JOIN policymanagement.dbo.tfeestatus prevfeeStatus
				ON prevfeeStatus.FeeStatusId = previousStatus.FeeStatusId
		
		LEFT JOIN policymanagement.dbo.tadvisefeetype advisefeeType
				ON fee.advisefeetypeid = advisefeeType.advisefeetypeid

		LEFT JOIN policymanagement.dbo.trefadvisefeetype refadvisefeeType
				ON advisefeeType.refadvisefeetypeid = refadvisefeeType.refadvisefeetypeid

		LEFT JOIN policymanagement.dbo.tadvisefeechargingdetails feechargin
				ON fee.advisefeechargingdetailsid = feechargin.advisefeechargingdetailsid

		LEFT JOIN policymanagement.dbo.tadvisefeechargingtype feecharginType
				ON feechargin.advisefeechargingtypeid = feecharginType.advisefeechargingtypeid

		LEFT JOIN policymanagement.dbo.trefadvisefeechargingtype reffeecharginType
				ON reffeecharginType.refadvisefeechargingtypeid = feecharginType.refadvisefeechargingtypeid

		LEFT JOIN policymanagement.dbo.tfeerecurrence feeRecurrence
				ON fee.feeid = feeRecurrence.feeid

		LEFT JOIN policymanagement.dbo.tfeeinstalment feeInstalment
				ON fee.feeid = feeInstalment.feeid    

WHERE  fee.IndigoClientId = @TenantId



IF OBJECT_ID('tempdb..#FeeNextDueDates') IS NOT NULL DROP TABLE #FeeNextDueDates
CREATE TABLE #FeeNextDueDates(FeeId INT, NextDueDate Date)

-- Add Installment Fee next due date
INSERT INTO #FeeNextDueDates(FeeId, NextDueDate)
SELECT 
		FeeId, 
		Nextinstallmentdate
FROM #fees
WHERE  RefAdviseFeeTypeName <>'On-going Fee' and IsRecurring = 1 and CurrenStatus <> 'Draft' AND CurrenStatus <> 'Cancelled' AND CurrenStatus <> 'NTU'


-- Add Ongoing fee next due date for percentage charging types
INSERT INTO #FeeNextDueDates(FeeId, NextDueDate)
SELECT
		FeeId,
		CASE WHEN EndDate < NextRecurrenceDueDate 
		THEN NULL
		ELSE NextRecurrenceDueDate
		END NextDueDate -- check with end date
FROM #fees
WHERE  RefAdviseFeeTypeName ='On-going Fee' AND (CurrenStatus <> 'Draft' AND CurrenStatus <> 'Cancelled' AND CurrenStatus <> 'NTU')
AND NOT (PreviousStatus<>'Due' AND CurrenStatus = 'Submitted For T & C')
AND ISNULL(RefAdviseFeeChargingTypeId,0) IN (2, 3, 8, 9, 10) 
-- 'PERCENTAGE_CONTRIBUTION_AMOUNT', 'PERCENTAGE_ASSET_FUNDS_INVESTED_FIXED', 'PERCENTAGE_REGULAR_CONTRIBUTION_AMOUNT', 
-- 'PERCENTAGE_LUMPSUM_CONTRIBUTION_AMOUNT', 'PERCENTAGE_TRANSFER_CONTRIBUTION_AMOUNT'


-- Add Ongoing fee next due date for Fixed and fixed range and no charging types
IF OBJECT_ID('tempdb..#OngoingFixedFees') IS NOT NULL
DROP TABLE #OngoingFixedFees

SELECT
	FeeId,
	StartDate,
	0 IsProcessed
INTO #OngoingFixedFees
FROM #fees
Where  RefAdviseFeeTypeName ='On-going Fee' AND (CurrenStatus <> 'Draft' AND CurrenStatus <> 'Cancelled' AND CurrenStatus <> 'NTU') 
AND NOT (PreviousStatus<>'Due' AND CurrenStatus = 'Submitted For T & C')
AND ISNULL(RefAdviseFeeChargingTypeId, 0) IN (0, 1, 5) --'FIXED_PRICE', 'FIXED_PRICE_RANGE' OR RefAdviseFeeChargingTypeId = null or 0


WHILE(EXISTS(SELECT 1 FROM #OngoingFixedFees WHERE IsProcessed = 0))
BEGIN 
		DECLARE @FeeId INT 
		DECLARE @StartDate DateTime 
		DECLARE @NextDueDate DateTime 

		SELECT TOP 1 
			@FeeId = FeeId, 
			@StartDate= ISNULL(StartDate, @CurrentUserDate)
		FROM #ongoingFixedFees WHERE IsProcessed = 0

		DECLARE @work0 TABLE (NextDueDate DATE)
 
		INSERT INTO @work0
		EXEC dbo.SpNCustomNextExpectationDueDate @FeeId, @StartDate ,  @StartDate , @CurrentUserDate, @NextDueDate OUTPUT

		 INSERT INTO #feeNextDueDates(FeeId, NextDueDate)
		 SELECT @FeeId, NextDueDate
		 FROM @work0

		UPDATE #OngoingFixedFees SET IsProcessed = 1 WHERE FeeId = @FeeId
END

SELECT
	FeeId,
	NextDueDate
FROM #FeeNextDueDates





