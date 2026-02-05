SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomPopulateScheduleScratchTable]
AS
/*
2013-Feb-12     : Changed to introduce new window for aegon
Author     : KK   On 2012-Dec-04
Purpose  : Populate TValScheduleScratch table with all the plans eligible for scheduled valuation, 
                  This SP is called by a SQL jobs and the output in TValScheduleScratch is used by service running
Notes:
Providers are picked up as per the service hours
Update SubmitAtOrAfter time is updated for the first ie where SubmitSequenceByProvider = 1, other plans will be updated by SpCustomUpdateScheduleScratchTable

new behaviours
1) adviser schedule            - excluded plans won't be picked up
2) client level schedules    - pbid's scheduled by multiple client's - only the first one would be valued
3) client level schedule      - excluded plan's won't get valued
4) wrappen in pb id's won't get valued individually

to do
1) even bulk schedules must use the plans identified by this SP, which will help to improve the performance con is when being forced will have to have an alternative
2) if the plan is already valued - should we value again or not - may be yes?
*/

/* to be verified
 IO Schedule OpTime - IOStartTime, IOEndTime - used when updating the SubmitAtOrAfter column    
 NextOccurrence - Used to retrieve schedule to process
 should we check the IO password expired/locked etc., 
*/
/* 
Change Log
09-Apr-2013 Replaced call to dbo.FindValidPlansForValuation with dbo.FindValidPlansForValuationFromOvernightJob - IO-7542
28-Oct-2013 Added servicing adviser extension logic in retrieving the plans
*/

SET NOCOUNT OFF

DECLARE @CurrentDateTime DATETIME = GETDATE()
DECLARE @CurrentDT AS DATETIME = @CurrentDateTime, @WindowFrom AS DATETIME, @WindowTo AS DATETIME;
DECLARE @AegonWindow BIT = 0
DECLARE @frequencyTable AS TABLE (f_identifier VARCHAR(50), f_id BIGINT)
	INSERT INTO @frequencyTable 
			VALUES
				('Annually', 1),
                ('Bi-Annually', 2),
				('Half Yearly', 2),
				('Quarterly', 3),
				('Monthly', 4),
				('Fortnightly', 5),
				('Weekly', 6),
				('Daily', 7),
				('Single', 8)

--Below modes are just a replica type called ValuationServiceType in NIO  dt 2012-12-07, kk
Declare @None int = 0x0, @Manual int = 0x1, @UnderlyingFund int = 0x2, @RealTime int = 0x4,
		@RealTimeBatch int = 0x8,@BulkProvider int = 0x10, @BulkManual int = 0x20,@BulkHidden int = 0x40, @bulkmanualtemplate int = 0x80
        
--ScheduledLevel constants - needs to be in lower case
Declare @FIRM_SCHEDULE varchar(50), @ADVISER_SCHEDULE varchar(50), @CLIENT_SCHEDULE varchar(50), @BULK_MANUAL_SCHEDULE varchar(50)
Select @FIRM_SCHEDULE = 'firm', @ADVISER_SCHEDULE = 'adviser', @CLIENT_SCHEDULE = 'client',  @BULK_MANUAL_SCHEDULE = 'bulkmanual'

exec SpCustomDeleteValuationSchedule        --delete schedules for indigoclients whos status isn't active
    
			IF DATEPART(hh, @CurrentDT) < 3
                BEGIN
                    SET @WindowFrom = DATEADD(N, 0, DATEADD(HH, 00, CONVERT (VARCHAR (11), @CurrentDT, 121)));
                    SET @WindowTo = DATEADD(N, 0, DATEADD(HH, 3, CONVERT (VARCHAR (11), @CurrentDT, 121)));
                    SET @AegonWindow = 1
                END
			ELSE   
				BEGIN
            IF DATEPART(hh, @CurrentDT) < 18
                BEGIN
                    SET @WindowFrom = DATEADD(N, 0, DATEADD(HH, 00, CONVERT (VARCHAR (11), @CurrentDT, 121)));
                    SET @WindowTo = DATEADD(N, 0, DATEADD(HH, 18, CONVERT (VARCHAR (11), @CurrentDT, 121)));
                END
            ELSE
                BEGIN
                    SET @WindowFrom = DATEADD(N, 0, DATEADD(HH, 18, CONVERT (VARCHAR (11), @CurrentDT, 121)));
                    SET @WindowTo = DATEADD(N, 59, DATEADD(HH, 23, CONVERT (VARCHAR (11), @CurrentDT, 121)));
                END;
			    END

            IF OBJECT_ID('tempdb..#EligibleProviders') IS NOT NULL DROP TABLE #EligibleProviders
            CREATE TABLE #EligibleProviders
            (
                BaseProvider   BIGINT,
                RefProdProviderId BIGINT,
                ScheduledLevel varchar	(255)
            );

            ;WITH   EligibleProviders
            AS     (
                    --'real time batch' and 'bulk manual' enabled providers
					(SELECT sc.RefProdProviderId
                           ,(Dateadd(n, CONVERT (INT, SubString(sc.ScheduleStartTime, 4, 2)), dateadd(hh, CONVERT (INT, SubString(sc.ScheduleStartTime, 1, 2)), CONVERT (DATETIME, CONVERT (VARCHAR (11), @CurrentDT, 121))))) AS scheduledTime
                           ,NULL As Scheduledlevel
                    FROM   TValScheduleConfig AS sc WITH (NOLOCK)
                           INNER JOIN
                           tvalproviderhoursofoperation AS ho WITH (NOLOCK)
                           ON sc.RefProdProviderId = ho.RefProdProviderId
                              AND LOWER(DATENAME(dw, @CurrentDT)) = IsNull(HO.DayOfTheWeek, LOWER(DATENAME(dw, @CurrentDT)))
                           INNER JOIN TValProviderConfig PC with (nolock) on sc.RefProdProviderId = pc.RefProdProviderId
                    WHERE  IsEnabled = 1 and (pc.SupportedService & @RealTimeBatch = @RealTimeBatch or pc.SupportedService & @BulkManual = @BulkManual or pc.SupportedService & @bulkmanualtemplate = @bulkmanualtemplate ))
   
                    --'bulk automated' download
                    UNION

					(SELECT sc.RefProdProviderId
                           ,(Dateadd(n, CONVERT (INT, SubString(bc.DownloadTime, 4, 2)), dateadd(hh, CONVERT (INT, SubString(bc.DownloadTime, 1, 2)), CONVERT (DATETIME, CONVERT (VARCHAR (11), @CurrentDT, 121))))) AS scheduledTime
                           ,@FIRM_SCHEDULE As Scheduledlevel
                    FROM   TValScheduleConfig AS sc WITH (NOLOCK)
                           INNER JOIN TValBulkConfig bc with (nolock) on sc.RefProdProviderId = bc.RefProdProviderId AND LOWER(DATENAME(dw, @CurrentDT)) = lower(bc.DownloadDay)
                           INNER JOIN TValProviderConfig pc with (nolock) on bc.RefProdProviderId = pc.RefProdProviderId
                    WHERE  IsEnabled = 1 and pc.SupportedService & @BulkProvider = @BulkProvider)

                    UNION
    
                    --'bulk automated' import
					(SELECT sc.RefProdProviderId
                           ,(Dateadd(n, CONVERT (INT, SubString(bc.ProcessTime, 4, 2)), dateadd(hh, CONVERT (INT, SubString(bc.ProcessTime, 1, 2)), CONVERT (DATETIME, CONVERT (VARCHAR (11), @CurrentDT, 121))))) AS scheduledTime
                           ,@FIRM_SCHEDULE As Scheduledlevel
                    FROM   TValScheduleConfig AS sc WITH (NOLOCK)
                           INNER JOIN TValBulkConfig bc with (nolock) on sc.RefProdProviderId = bc.RefProdProviderId AND LOWER(DATENAME(dw, @CurrentDT)) = lower(bc.ProcessDay)
                           INNER JOIN TValProviderConfig pc with (nolock) on bc.RefProdProviderId = pc.RefProdProviderId
                    WHERE  IsEnabled = 1 and pc.SupportedService & @BulkProvider = @BulkProvider)
                   )
            INSERT INTO #EligibleProviders (BaseProvider, RefProdProviderId,ScheduledLevel )
            SELECT RefProdProviderId, RefProdProviderId,  Scheduledlevel
            FROM   EligibleProviders
			WHERE  
					(@AegonWindow = 0 AND scheduledTime BETWEEN @WindowFrom AND @WindowTo)
					OR
					(@AegonWindow = 1 AND RefProdProviderId = 321)

            INSERT INTO #EligibleProviders (BaseProvider, RefProdProviderId, ScheduledLevel) --Lookup providers - ASSUMING THAT LINKED PROVIDER IS NOT DESIGNED TO HAVE A FIRM LEVEL VALUATION SET
            SELECT MappedRefProdProviderId, LK.RefProdProviderId, NULL
            FROM   #EligibleProviders AS EP
                   INNER JOIN
                   TValLookUp AS LK
                   ON EP.RefProdProviderId = LK.MappedRefProdProviderId;
    
--'ELIGIBLE SCHEDULES FOR THE RUN'
            IF OBJECT_ID('tempdb..#EligibleSchedules') IS NOT NULL DROP TABLE #EligibleSchedules
            CREATE TABLE #EligibleSchedules
            (
                Id   BIGINT  IDENTITY (1, 1),
                ValScheduleId     BIGINT       ,
                ValScheduleItemId BIGINT       ,
                IndigoClientId    BIGINT       ,
                RefProdProviderId BIGINT       ,
                PortalCRMContactId BIGINT,
                ScheduledLevel    VARCHAR (255)
            );
            INSERT INTO
                #EligibleSchedules (ValScheduleId, ValScheduleItemId, IndigoClientId, RefProdProviderId, PortalCRMContactId, ScheduledLevel)
            SELECT   
                T1.ValScheduleId,T2.ValscheduleItemId,T1.IndigoClientId,T1.RefProdProviderId, IsNull(T1.PortalCRMContactId, 0), T1.ScheduledLevel
            FROM     
                PolicyManagement..TValSchedule AS T1 WITH (NOLOCK)
                     INNER JOIN PolicyManagement..TValScheduleItem AS T2 WITH (NOLOCK) ON T1.ValScheduleId = T2.ValScheduleId
                     INNER JOIN  #EligibleProviders AS T3 ON T1.RefProdProviderId = T3.RefProdProviderId
            WHERE    
                     T1.IsLocked = 0 AND T1.Startdate IS NOT NULL 
                     AND T2.NextOccurrence IS NOT NULL AND T2.NextOccurrence <= @WindowTo
                     AND ISNULL(RefValScheduleItemStatusId,1) IN (1, 5)
					 AND ( 
                                (ISNULL(T1.ScheduledLevel,'') = @FIRM_SCHEDULE AND ISNULL(T3.ScheduledLevel,'') = @FIRM_SCHEDULE) 
                                OR 
                                (ISNULL(T1.ScheduledLevel,'') <> @FIRM_SCHEDULE AND ISNULL(T3.ScheduledLevel,'') = '') 
                            )
            ORDER BY T1.ValScheduleId, T2.NextOccurrence;

            --deletes any schedules set up by users who are not access granted
            ;WITH ValidPortalUsers AS
            (
                SELECT ValScheduleID FROM 
                        #EligibleSchedules ES 
                                INNER JOIN Administration..TUser U WITH (NOLOCK) ON ES.PortalCRMContactId =  U.CRMContactId
                                AND U.Status NOT LIKE 'Access Granted%'
                WHERE 
                        ES.ScheduledLevel in (@ADVISER_SCHEDULE ,@CLIENT_SCHEDULE) 
            )

            DELETE A
            FROM #EligibleSchedules A INNER JOIN ValidPortalUsers B ON A.ValScheduleId = B.ValScheduleID
            WHERE A.ScheduledLevel in (@ADVISER_SCHEDULE ,@CLIENT_SCHEDULE)

            --deletes adviser and client schedules which are setup as unipass but hasn't got a valid unipass
            ;WITH ValidCredentials AS
            (
                SELECT ValScheduleID FROM 
                        #EligibleSchedules ES 
                                INNER JOIN TValProviderConfig PC WITH (NOLOCK) ON ES.RefProdProviderId = PC.refprodproviderid  
                                INNER JOIN administration..tcertificate C WITH (NOLOCK) ON ES.PortalCRMContactId = C.crmcontactid
                WHERE 
                        ES.ScheduledLevel in (@ADVISER_SCHEDULE ,@CLIENT_SCHEDULE) 
                        AND PC.AuthenticationType = 1
                        AND @currentDT <= C.ValidUntil
    
                UNION ALL

                SELECT ValScheduleID FROM 
                        #EligibleSchedules ES 
                                INNER JOIN TValProviderConfig PC WITH (NOLOCK) ON ES.RefProdProviderId = PC.refprodproviderid  
                                INNER JOIN TValportalSetup C WITH (NOLOCK) ON ES.RefProdProviderId =  C.Refprodproviderid AND ES.PortalCRMContactId =  C.CRMContactId
                WHERE 
                        ES.ScheduledLevel in (@ADVISER_SCHEDULE ,@CLIENT_SCHEDULE) 
                        AND PC.AuthenticationType = 0
            )

            DELETE A
            FROM #EligibleSchedules A LEFT OUTER JOIN ValidCredentials B ON A.ValScheduleId = B.ValScheduleID
            WHERE A.ScheduledLevel in (@ADVISER_SCHEDULE ,@CLIENT_SCHEDULE)  AND B.ValScheduleID IS NULL

			IF @AegonWindow = 1
			BEGIN
				DELETE ES FROM #EligibleSchedules ES JOIN TValSchedule S ON ES.ValScheduleId = S.ValScheduleId WHERE Frequency like 'Daily'
			END
			

--'ELIGIBLE PLANS FOR THE RUN'
			IF (select object_id('tempdb..#ExtendValuationsByServicingadviser')) is not null drop table #ExtendValuationsByServicingadviser
			SELECT  Value ValueByServicingAdviser, IndigoClientId 
			into #ExtendValuationsByServicingadviser
			FROM administration..TIndigoClientPreference  with (nolock) WHERE PreferenceName = 'ExtendValuationsByServicingadviser' AND Value = '1' 

            IF OBJECT_ID('tempdb..#EligiblePlans') IS NOT NULL DROP TABLE #EligiblePlans
            Create Table #EligiblePlans(                
					Id bigint IDENTITY (1, 1),        
					IndigoClientId bigint,         
					PolicyBusinessId bigint,   
					RefProdProviderId bigint,              
					ClientCRMContactId bigint,        
					PractitionerId bigint,        
					PractitionerCRMContactId bigint, --Selling Adviser CRMContactId   ?????
					ScheduledLevel varchar(255) ,
					ValScheduleId bigint
				);

            if (select object_id('tempdb..#validplans')) is not null
            drop table #validplans

            create table #validplans
	                (IndigoClientId bigint , PolicyBusinessId bigint, OwnerCRM bigint, BaseProvider bigint, RefProdProviderId bigint,
	                SellingPractitioner  bigint, SellingCRM bigint, ServicingPractitioner bigint, ServicingCRM bigint, ValueByServicingAdviser bigint,
	                TopupPolicyBusinessId bigint, SellingAdviserStatus varchar(100), ServicingAdviserStatus varchar(100))
            insert #validplans  exec SpFindValidPlansForValuationForOvernightJob 

            ;WITH ValidPlans AS
            (
               select * from #validplans
            )
            INSERT INTO #EligiblePlans
            (
             IndigoClientId,PolicyBusinessId,RefProdProviderId,ClientCRMContactId,PractitionerId,PractitionerCRMContactId,ScheduledLevel, ValScheduleId 
            )
            SELECT
                    es.IndigoClientId, vp1.PolicyBusinessId, es.RefProdProviderId,OwnerCRM,SellingPractitioner, SellingCRM, @ADVISER_SCHEDULE , es.valscheduleid 
            FROM 
                    ValidPlans VP1
						LEFT JOIN #ExtendValuationsByServicingadviser X on X.IndigoClientId = vp1.IndigoClientId
                        INNER JOIN #EligibleSchedules ES ON VP1.BaseProvider = ES.RefProdProviderId AND VP1.IndigoClientId = ES.indigoclientid 
                                                AND 
                                                (
                                                        (COALESCE(X.ValueByServicingAdviser,0)  = 0 AND ES.PortalCRMContactId = VP1.SellingCRM and VP1.SellingAdviserStatus like 'Access Granted%')
                                                    OR
                                                        (COALESCE(X.ValueByServicingAdviser,0)  = 1 AND ( (ES.PortalCRMContactId = VP1.SellingCRM and VP1.SellingAdviserStatus like 'Access Granted%') OR ( VP1.SellingAdviserStatus NOT like 'Access Granted%' AND VP1.ServicingAdviserStatus LIKE 'Access Granted%' AND ES.PortalCRMContactId = VP1.ServicingCRM) ) )
                                                )
												AND ES.scheduledlevel = @ADVISER_SCHEDULE
                        LEFT JOIN twrapperpolicybusiness WPB WITH (NOLOCK) ON VP1.policybusinessid = WPB.policybusinessid
            WHERE wpb.policybusinessid IS NULL

            INSERT INTO #EligiblePlans
            (
             IndigoClientId,PolicyBusinessId,RefProdProviderId,ClientCRMContactId,PractitionerId,PractitionerCRMContactId,ScheduledLevel, ValScheduleId 
            )
            SELECT  
                es.IndigoClientId, SP.PolicyBusinessId, es.RefProdProviderId,SP.ClientCRMContactId, NULL, SP.PortalCRMContactId,   @CLIENT_SCHEDULE, es.valscheduleid  
            FROM 
                        TValschedulepolicy SP WITH (NOLOCK) INNER JOIN #EligibleSchedules ES ON SP.ValScheduleId = ES.ValScheduleId  AND ES.scheduledlevel = @CLIENT_SCHEDULE
                        LEFT JOIN twrapperpolicybusiness WPB WITH (NOLOCK) ON SP.policybusinessid = WPB.policybusinessid
                        LEFT JOIN TValExcludedPlan EP WITH (NOLOCK) ON EP.PolicyBusinessId = SP.PolicyBusinessId 
            WHERE wpb.policybusinessid IS NULL AND EP.PolicyBusinessId IS NULL

--'Alright finally populating the table'

begin try

	begin tran

DELETE FROM [TValScheduleScratch]
OUTPUT 
      deleted.[ValScheduleId],deleted.[Guid],deleted.[ScheduledLevel],deleted.[ProcessOrder],deleted.[IndigoClientId],deleted.[RefProdProviderId]
      ,deleted.[ClientCRMContactId],deleted.[UserCredentialOption],deleted.[PortalCRMContactId],deleted.[UserId],deleted.[Frequency]
      ,deleted.[IsLocked],deleted.[UserNameForFileAccess],deleted.[Password2ForFileAccess],deleted.[BulkValuationType],deleted.[ScheduleDelay]
      ,deleted.[AlwaysAvailableFg],deleted.[DayOfTheWeek],deleted.[StartHour],deleted.[EndHour],deleted.[StartMinute],deleted.[EndMinute]
      ,deleted.[ValScheduleItemId],deleted.[ValQueueId],deleted.[NextOccurrence],deleted.[LastOccurrence],deleted.[RefValScheduleItemStatusId]
      ,deleted.[SaveAsFilePathAndName],deleted.[PolicyBusinessId],deleted.[AcquiredBy],deleted.[AcquiredAt],deleted.[AcquiredExpireTime]
      ,deleted.[IsProcessed],deleted.[SubmitSequenceByProvider],deleted.[SubmitAtOrAfter],deleted.[ValScheduleScratchId],@CurrentDateTime
INTO [NewTValScheduleScratchAudit]
           ([ValScheduleId],[Guid],[ScheduledLevel],[ProcessOrder],[IndigoClientId],[RefProdProviderId],[ClientCRMContactId],[UserCredentialOption]
           ,[PortalCRMContactId],[UserId],[Frequency],[IsLocked],[UserNameForFileAccess],[Password2ForFileAccess],[BulkValuationType],[ScheduleDelay]
           ,[AlwaysAvailableFg],[DayOfTheWeek],[StartHour],[EndHour],[StartMinute],[EndMinute],[ValScheduleItemId],[ValQueueId],[NextOccurrence]
           ,[LastOccurrence],[RefValScheduleItemStatusId],[SaveAsFilePathAndName],[PolicyBusinessId],[AcquiredBy],[AcquiredAt],[AcquiredExpireTime]
           ,[IsProcessed],[SubmitSequenceByProvider],[SubmitAtOrAfter],[ValScheduleScratchId],[StampDateTime])

        truncate table TValScheduleScratch
    
        ;WITH EligibleForValuation AS
        (
            SELECT
                T1.ValScheduleId, T1.Guid, T1.ScheduledLevel, T1.IndigoClientId, T1.RefProdProviderId, T1.ClientCRMContactId, T1.UserCredentialOption,
                T1.PortalCRMContactId, T1.Frequency, T1.IsLocked, T1.UserNameForFileAccess, T1.Password2ForFileAccess, 
                T2.ValScheduleItemId, T2.ValQueueId,  T2.NextOccurrence, T2.LastOccurrence, T2.RefValScheduleItemStatusId, T2.SaveAsFilePathAndName, T6.PolicyBusinessId,
                T4.BulkValuationType, T4.ScheduleDelay, 
                TU.UserId
            FROM   #EligibleSchedules AS DT
                   INNER JOIN TValSchedule AS T1 WITH (NOLOCK) ON T1.ValscheduleId = DT.ValscheduleId
                   INNER JOIN TValScheduleItem AS T2 WITH (NOLOCK) ON T1.ValScheduleId = T2.ValScheduleId
                   INNER JOIN TValProviderConfig AS T4 WITH (NOLOCK) ON T1.RefProdProviderId = T4.RefProdProviderId
                   INNER JOIN Administration..TUser AS TU WITH (NOLOCK) ON TU.CRMContactId = T1.PortalCRMContactId
                   INNER JOIN #EligiblePlans AS T6 WITH (NOLOCK) ON T6.ValScheduleId = T2.ValScheduleId
            WHERE  T2.NextOccurrence <= @WindowTo
                   AND T1.ScheduledLevel IN (@CLIENT_SCHEDULE, @ADVISER_SCHEDULE)
            UNION ALL
            SELECT 
                T1.ValScheduleId, T1.Guid, T1.ScheduledLevel, T1.IndigoClientId, T1.RefProdProviderId, T1.ClientCRMContactId, T1.UserCredentialOption,
                T1.PortalCRMContactId, T1.Frequency, T1.IsLocked, T1.UserNameForFileAccess, T1.Password2ForFileAccess, 
                T2.ValScheduleItemId, T2.ValQueueId,  T2.NextOccurrence, T2.LastOccurrence, T2.RefValScheduleItemStatusId, T2.SaveAsFilePathAndName, 0,
                T4.BulkValuationType, T4.ScheduleDelay, 0
            FROM   #EligibleSchedules AS DT
                   INNER JOIN TValSchedule AS T1 WITH (NOLOCK) ON T1.ValscheduleId = DT.ValscheduleId
                   INNER JOIN TValScheduleItem AS T2 WITH (NOLOCK) ON T1.ValScheduleId = T2.ValScheduleId
                   INNER JOIN TValProviderConfig AS T4 WITH (NOLOCK) ON T1.RefProdProviderId = T4.RefProdProviderId
            WHERE  T2.NextOccurrence <= @WindowTo
                   AND T1.ScheduledLevel IN (@FIRM_SCHEDULE, @BULK_MANUAL_SCHEDULE)
        )
		INSERT INTO TValScheduleScratch 
            ( ValScheduleId, Guid, ScheduledLevel, ProcessOrder, IndigoClientId, RefProdProviderId, ClientCRMContactId, UserCredentialOption, PortalCRMContactId, UserId, Frequency, IsLocked, UserNameForFileAccess, Password2ForFileAccess, BulkValuationType, ScheduleDelay, ValScheduleItemId, ValQueueId, NextOccurrence, LastOccurrence, RefValScheduleItemStatusId, SaveAsFilePathAndName, PolicyBusinessId)
        SELECT ValScheduleId, Guid, ScheduledLevel,
                    CASE 
                        WHEN IsNull(ScheduledLevel, '') = @CLIENT_SCHEDULE THEN 1 
                        WHEN IsNull(ScheduledLevel, '') = @BULK_MANUAL_SCHEDULE THEN 2 
                        WHEN IsNull(ScheduledLevel, '') = @FIRM_SCHEDULE THEN 3 
                        WHEN IsNull(ScheduledLevel, '') = @ADVISER_SCHEDULE THEN 4 
                    END,
                    IndigoClientId ,RefProdProviderId , 
                    IsNull(ClientCRMContactId, 0) ,
                    IsNull(UserCredentialOption, '') , 
                    IsNull(PortalCRMContactId, 0) ,
                    IsNull(UserId, 0) , 
                    IsNull(Frequency, '') , 
                    IsNull(IsLocked, 0) ,
                    IsNull(UserNameForFileAccess, '') , 
                    Password2ForFileAccess, 
                    IsNull(BulkValuationType, '') ,
                    IsNull(ScheduleDelay, 0) , 
                    IsNull(ValScheduleItemId, 0), 
                    IsNull(ValQueueId, 0), 
                    IsNull(CONVERT (VARCHAR (24), NextOccurrence, 120), ''),
                    IsNull(CONVERT (VARCHAR (24), LastOccurrence, 120), ''), 
                    IsNull(RefValScheduleItemStatusId, 0), 
                    IsNull(SaveAsFilePathAndName, ''), 
                    IsNull(PolicyBusinessId, 0) 
        FROM   EligibleForValuation

--'duplicate policybusiness id - leaving the most prioritised'
    DELETE T1 
        FROM TValScheduleScratch t1
        INNER JOIN 
            (SELECT ROW_NUMBER() OVER (PARTITION BY policybusinessid ORDER BY ProcessOrder ASC) rNumber, ValScheduleScratchId 
                FROM TValScheduleScratch with (nolock) ) T2
                ON t1.ValSchedulescratchid = t2.ValScheduleScratchId WHERE rNumber > 1 and policybusinessid > 0

--'If no provider hours of operation defined, assume not available - i.e. cant request a valuation'
        UPDATE  TValScheduleScratch
            SET AlwaysAvailableFg = IsNull(T5.AlwaysAvailableFg, 0),
                DayOfTheWeek      = IsNull(T5.DayOfTheWeek, ''),
                StartHour         = IsNull(T5.StartHour, 0),
                EndHour           = IsNull(T5.EndHour, 0),
                StartMinute       = IsNull(T5.StartMinute, 0),
                EndMinute         = IsNull(T5.EndMinute, 0)
        FROM    PolicyManagement..TValSchedule AS T1 WITH (NOLOCK)
                LEFT OUTER JOIN
                PolicyManagement..TValProviderHoursOfOperation AS T5 WITH (NOLOCK)
                ON T1.RefProdProviderId = T5.RefProdProviderId
                   AND LOWER(DATENAME(dw, @CurrentDateTime)) = IsNull(T5.DayOfTheWeek, LOWER(DATENAME(dw, @CurrentDateTime)))
        WHERE   TValScheduleScratch.RefProdProviderId = T5.RefProdProviderId;
    
--'Update SubmitSequence - grouped by RefProdProviderId ORDER BY ProcessOrder, ValScheduleId'
        UPDATE  A
            SET A.SubmitSequenceByProvider = B.SubmitSequenceByProvider
        FROM    TValScheduleScratch AS A with (nolock)
                INNER JOIN
                (SELECT ValScheduleScratchId,
                        ROW_NUMBER() OVER (PARTITION BY RefProdProviderId ORDER BY ProcessOrder, ft.f_id, ValScheduleId) AS SubmitSequenceByProvider
                 FROM   TValScheduleScratch with (nolock) LEFT JOIN @frequencyTable ft ON Frequency = ft.f_identifier ) AS B
                ON A.ValScheduleScratchId = B.ValScheduleScratchId;

--'done this so we can process schedule during the day; Update SubmitAtOrAfter time: By default we provide a 1 sec Delay'
        DECLARE @DayTimeScheduleStartTime AS VARCHAR (24);

        SET @DayTimeScheduleStartTime = CONVERT (VARCHAR (24), @CurrentDateTime, 121);

        UPDATE  A
            SET SubmitAtOrAfter = CASE 
                    WHEN RefValScheduleItemStatusId in (1,5) AND ScheduledLevel IN ( @FIRM_SCHEDULE, @BULK_MANUAL_SCHEDULE)  THEN NextOccurrence 
                    ELSE 
                            CASE 
                                WHEN @AegonWindow = 1 THEN DATEADD(s, 1 * 1, DATEADD(n, 00, DATEADD(hh, 00,CONVERT (VARCHAR (11), GETDATE(), 121))))
                                WHEN ScheduleDelay = 0 THEN dateadd(s, 1 * SubmitSequenceByProvider, Dateadd(n, CONVERT (INT, SUBSTRING(B.ScheduleStartTime, 4, 2)), dateadd(hh, CONVERT (INT, SUBSTRING(B.ScheduleStartTime, 1, 2)), CONVERT (VARCHAR (11), @CurrentDateTime, 121)))) 
                                ELSE dateadd(s, (ScheduleDelay) * SubmitSequenceByProvider, Dateadd(n, CONVERT (INT, SUBSTRING(B.ScheduleStartTime, 4, 2)), dateadd(hh, CONVERT (INT, SUBSTRING(B.ScheduleStartTime, 1, 2)), CONVERT (VARCHAR (11), @CurrentDateTime, 121)))) 
                            END 
                    END
        FROM    TValScheduleScratch AS A with (nolock)
                INNER JOIN
                TValScheduleConfig AS B with (nolock)
                ON A.RefProdProviderId = B.RefProdProviderId
                   AND A.SubmitSequenceByProvider = 1; --* 
	commit tran
end try
begin catch
 PRINT 'Unhandled error: ' + CAST(ERROR_NUMBER() AS VARCHAR(10))  
        + ', ' + ERROR_MESSAGE();  
      IF XACT_STATE() <> 0 ROLLBACK;
end catch
GO