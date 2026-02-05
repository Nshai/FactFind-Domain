SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomCreateNewBusinessIntegrationLifeCycle]   
	@TenantId bigint
AS

DECLARE	  @CurrentAdviceTypeId	BIGINT
		, @CurrentLifeCycleId	BIGINT
		, @StampUser			VARCHAR(50)
		, @LifeCycleName		VARCHAR(150)
		, @StampAction			VARCHAR(50)
		, @ConcurrencyId		BIGINT		
		, @ErrorMessage VARCHAR(MAX)	
				
		SELECT 
			@LifeCycleName = 'New Business - Integration',
			@StampAction = 'C',
			@StampUser = '0',
			@ConcurrencyId = 1
							
		-- 3. Get all Plan Types which should support that life cycle
		-- 'Cash Account', 'Insurance / Investment Bond', 'Maximum Investment Plan', 'Offshore Bond',	'General Investment Account', 'Money Purchase Contracted', 
		-- 'Personal Pension Plan', 'Appropriate Personal Pension', 'SIPP', 'Pension Fund Withdrawal', 's32 Buyout Bond', 'ISA'
		CREATE TABLE #LifeCyclePlanTypes (PlanTypeId BIGINT)
		INSERT INTO	
			#LifeCyclePlanTypes
		VALUES (1),(3),(4),(8),(22),(28),(31),(39),(44),(72),(105),(114)

		DECLARE @AdviceTypeId INT, @LIfeCycleId INT

		SELECT @AdviceTypeId = MAX(AdviceTypeId) FROM TAdviceType
		SELECT @LifeCycleId = MAX(LifeCycleId) FROM TLifeCycle

		--print @AdviceTypeId
		--print @LifeCycleId

		IF(@AdviceTypeId < @LifeCycleId)
		DBCC CHECKIDENT('TAdviceType', RESEED, @LifeCycleId)

		IF(@LifeCycleId < @AdviceTypeId)
		DBCC CHECKIDENT('TLifeCycle', RESEED, @AdviceTypeId)

		-- 4. For current Tenant
						
			-- 4.1. Check if Tenant support all statuses for that Life Cycle
			DECLARE @TenantStatusCount bigint
			SELECT 
				@TenantStatusCount  = count(*) 
			FROM
				TStatus as s
			WHERE
				IndigoClientId = @TenantId
				AND s.Name IN ('Draft', 'Deleted', 'Submitted to Provider', 'In force', 'Out of Force', 'Paid Up')

			-- 4.2. verify the tenant has all required statuses for the new life cycle
			IF	(@TenantStatusCount < 6)
			BEGIN

				SET @ErrorMessage = 'New Business - Integration life cycle cannot be created for TenantId ' +  convert(varchar, @TenantId) + '. Tenant does not have all required statuses.'
				RAISERROR(@ErrorMessage, 16, 1)	
			END

			-- 4.3. Create Advice Case for that life cycle
			INSERT TAdviceType
				([Description], 
				IntelligentOfficeAdviceType, 
				ArchiveFg,
				IndigoClientId, 
				ConcurrencyId, 
				IsSystem)
			OUTPUT
				inserted.[Description], 
				inserted.IntelligentOfficeAdviceType, 
				inserted.ArchiveFg, 
				inserted.IndigoClientId, 
				inserted.ConcurrencyId, 
				inserted.AdviceTypeId, 
				@StampAction, 
				GETDATE(), 
				@StampUser,
				inserted.IsSystem
			INTO
				TAdviceTypeAudit
				(inserted.[Description], 
				inserted.IntelligentOfficeAdviceType, 
				inserted.ArchiveFg, 
				inserted.IndigoClientId, 
				inserted.ConcurrencyId, 
				inserted.AdviceTypeId, 
				StampAction, 
				StampDateTime, 
				StampUser,
				IsSystem)
			VALUES
				(@LifeCycleName, 
				@LifeCycleName, 
				0,
				@TenantId, 
				@ConcurrencyId,
				1)

			SET @CurrentAdviceTypeId = IDENT_CURRENT('TAdviceType')
		
			-- 4.4. Create Life Cycle
			INSERT
				[dbo].[TLifeCycle]
				(Name, 
				Descriptor, 
				[Status], 
				PreQueueBehaviour, 
				PostQueueBehaviour, 
				CreatedDate, 
				CreatedUser, 
				IndigoClientId, 
				ConcurrencyId)
			OUTPUT 
				inserted.Name, 
				inserted.Descriptor, 
				inserted.[Status], 
				inserted.PreQueueBehaviour, 
				inserted.PostQueueBehaviour, 
				inserted.CreatedDate, 
				inserted.CreatedUser, 
				inserted.IndigoClientId, 
				inserted.ConcurrencyId, 
				inserted.LifeCycleId, 
				@StampAction, 
				GETDATE(), 
				@StampUser
			INTO
				[dbo].[TLifeCycleAudit]
				(Name, 
				Descriptor, 
				[Status], 
				PreQueueBehaviour, 
				PostQueueBehaviour, 
				CreatedDate, 
				CreatedUser, 
				IndigoClientId, 
				ConcurrencyId, 
				LifeCycleId, 
				StampAction, 
				StampDateTime, 
				StampUser)
			VALUES
				(@LifeCycleName,
				@LifeCycleName,
				1,
				'N/A',
				'N/A',
				GETDATE(),
				@StampUser,
				@TenantId,
				@ConcurrencyId)
			SET @CurrentLifeCycleId	=  IDENT_CURRENT('TLifeCycle')

			-- 4.5. Link the Life Cycle with the Advise Type for the list of ProductTypes
			INSERT INTO 
				TLifeCycle2RefPlanType
				(LifeCycleId, 
				RefPlanTypeId, 
				AdviceTypeId, 
				ConcurrencyId)
			OUTPUT
				inserted.LifeCycleId, 
				inserted.RefPlanTypeId, 
				inserted.AdviceTypeId, 
				inserted.ConcurrencyId, 
				inserted.LifeCycle2RefPlanTypeId, 
				@StampAction, 
				GETDATE(), 
				@StampUser
			INTO
				[dbo].[TLifeCycle2RefPlanTypeAudit]
				(LifeCycleId, 
				RefPlanTypeId, 
				AdviceTypeId, 
				ConcurrencyId, 
				LifeCycle2RefPlanTypeId, 
				StampAction, 
				StampDateTime, 
				StampUser)
			SELECT
				@CurrentLifeCycleId,
				PlanTypeId,
				@CurrentAdviceTypeId,
				@ConcurrencyId
			FROM	
				#LifeCyclePlanTypes p

			-- 4.6. Create Life Cycle STEPS for the NBI cycle
			CREATE TABLE #TLifeCycleStepTemp
			(	
				LifeCycleStepId		BIGINT,
				StatusId			bigint,
				ConcurrencyId		bigint
			)

			INSERT INTO
				TLifeCycleStep
				(StatusId, 
				LifeCycleId, 
				ConcurrencyId,
				IsSystem)
			OUTPUT
				inserted.LifeCycleStepId,
				inserted.StatusId, 
				inserted.ConcurrencyId
			INTO
				#TLifeCycleStepTemp
				(LifeCycleStepId,
				StatusId,
				ConcurrencyId)
			SELECT
				s.StatusId,
				@CurrentLifeCycleId,
				@ConcurrencyId,
				1 -- all life cycle steps are system
			FROM
				TStatus as s
			WHERE
				IndigoClientId = @TenantId
				AND s.Name IN ('Draft', 'Deleted', 'Submitted to Provider', 'In force', 'Out of Force', 'Paid Up')
				 
			INSERT INTO
				[dbo].[TLifeCycleStepAudit]
				(StatusId, 
				LifeCycleId, 
				ConcurrencyId, 
				LifeCycleStepId, 
				StampAction, 
				StampDateTime, 
				StampUser,
				IsSystem)
			SELECT
				StatusId, 
				@CurrentLifeCycleId, 
				ConcurrencyId, 
				LifeCycleStepId, 
				@StampAction, 
				getdate(), 
				@StampUser,
				1
			FROM 
				#TLifeCycleStepTemp
				
			CREATE TABLE #NBILifeCycleSteps
			(	
				LifeCycleStepId		BIGINT,
				StatusId			bigint,
				StatusName		VARCHAR(150)
			)
		
			INSERT INTO	
				#NBILifeCycleSteps
				(LifeCycleStepId,
				StatusName)
			SELECT
				LifeCycleStepId,
				s.Name
			FROM
				#TLifeCycleStepTemp lcs
			INNER JOIN
				TStatus as s on s.StatusId = lcs.StatusId
			WHERE
				s.IndigoClientId = @TenantId 
		
			-- CREATE INDEX on the StatusName
			CREATE CLUSTERED INDEX IX_DlpLifeCycleSteps_LifeCycleStepId ON #NBILifeCycleSteps(LifeCycleStepId)
			
			-- 4.7. Create Transitions
			CREATE TABLE #NBILifeCycleTransitions
			(	FromLifeCycleStepId BIGINT,
				ToLifeCycleStepId	BIGINT,
				OrderNumber			BIGINT,
				TransitionType		VARCHAR(150),
				HideStep			BIT
			)

			DECLARE @DraftStepId	BIGINT,
					@STPStepId		BIGINT,
					@InForceId		BIGINT,
					@PaidUpId		BIGINT,
					@OutOfForce		BIGINT,
					@DeletedId		BIGINT,
					@NTUId			BIGINT
			
			SELECT
				@DraftStepId = (SELECT Top 1 LifeCycleStepId FROM #NBILifeCycleSteps WHERE StatusName = 'Draft')
				, @STPStepId = (SELECT Top 1 LifeCycleStepId FROM #NBILifeCycleSteps WHERE StatusName = 'Submitted to Provider')
				, @InForceId = (SELECT Top 1 LifeCycleStepId FROM #NBILifeCycleSteps WHERE StatusName = 'In Force')
				, @PaidUpId = (SELECT Top 1 LifeCycleStepId FROM #NBILifeCycleSteps WHERE StatusName = 'Paid up')
				, @OutOfForce = (SELECT Top 1 LifeCycleStepId FROM #NBILifeCycleSteps WHERE StatusName = 'Out of Force')
				, @DeletedId = (SELECT Top 1 LifeCycleStepId FROM #NBILifeCycleSteps WHERE StatusName = 'Deleted')

			-- set up transitions
			INSERT INTO 
				#NBILifeCycleTransitions
				(FromLifeCycleStepId, ToLifeCycleStepId, OrderNumber, TransitionType)
			SELECT 
				@DraftStepId as FromLifeCycleStepId, @STPStepId as ToLifeCycleStepId, 1 as OrderNumber, 'Non-Compliance' as TransitionType
			UNION ALL 
			SELECT
				@STPStepId, @InForceId, 2, null
			UNION ALL 
			SELECT
				@InForceId, @OutOfForce, 3, null
			UNION ALL 
			SELECT
				@InForceId, @DeletedId, 4, null
			UNION ALL 
			SELECT
				@InForceId, @PaidUpId, 5, null

			-- create transitions
			INSERT INTO 
				[dbo].[TLifeCycleTransition]
				(LifeCycleStepId, 
				ToLifeCycleStepId, 
				OrderNumber, 
				[Type], 
				HideStep, 
				AddToCommissionsFg, 
				ConcurrencyId)
			OUTPUT
				inserted.LifeCycleStepId, 
				inserted.ToLifeCycleStepId, 
				inserted.OrderNumber, 
				inserted.[Type], 
				inserted.HideStep, 
				inserted.AddToCommissionsFg, 
				inserted.ConcurrencyId, 
				inserted.LifeCycleTransitionId, 
				@StampAction, 
				getdate(), 
				@StampUser
			INTO
				[dbo].[TLifeCycleTransitionAudit]
				(LifeCycleStepId, 
				ToLifeCycleStepId, 
				OrderNumber, 
				[Type], 
				HideStep, 
				AddToCommissionsFg, 
				ConcurrencyId, 
				LifeCycleTransitionId, 
				StampAction, 
				StampDateTime, 
				StampUser)
			SELECT
				FromLifeCycleStepId, 
				ToLifeCycleStepId, 
				OrderNumber, 
				TransitionType, 
				0, 
				NULL, 
				@ConcurrencyId
			FROM
				#NBILifeCycleTransitions

			-- 4.8. Delete tenant
			
			-- Drop all temp tables in the while
			IF (SELECT OBJECT_ID('tempdb..#TLifeCycleStepTemp')) IS NOT NULL
				DROP TABLE #TLifeCycleStepTemp

			IF (SELECT OBJECT_ID('tempdb..#NBILifeCycleSteps')) IS NOT NULL
				DROP TABLE #NBILifeCycleSteps

			IF (SELECT OBJECT_ID('tempdb..#NBILifeCycleTransitions')) IS NOT NULL
				DROP TABLE #NBILifeCycleTransitions