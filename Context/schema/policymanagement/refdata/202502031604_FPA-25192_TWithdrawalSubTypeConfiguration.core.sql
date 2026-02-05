 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TWithdrawalSubTypeConfiguration
--    Join: 
--   Where: 
----------------------------------------------------------------------------- 
 
USE PolicyManagement 

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255), @currenttimestamp datetime	  
	  
SELECT
@ScriptGUID = 'c3abfabc-e884-4e3b-b713-1241826926e3',
@Comments = 'Updated Arrangement type values for table TWithdrawalSubTypeConfiguration',
@currenttimestamp = getutcdate()
 
-- check if this script has already run
IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
RETURN;
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
		TRUNCATE TABLE TWithdrawalSubTypeConfiguration;
		
        --insert the records
        SET IDENTITY_INSERT TWithdrawalSubTypeConfiguration ON; 
 
		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 1,'PensionContributionDrawdownPlan','Lump Sum','Annuity','Pension Commencement Lump Sum (PCLS)',0,1,1
		
		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 2,'PensionContributionDrawdownPlan','Lump Sum','UnCrystallised','Uncrystallised Funds Pension Lump Sum (UFPLS)',1,1,1

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 3,'PensionContributionDrawdownPlan','Lump Sum','UnCrystallised','Pension Commencement Excess Lump Sum (PCELS)',1,0,0

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 4,'PensionContributionDrawdownPlan','Lump Sum','UnCrystallised','Small Lump Sum',1,1,0

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 5,'PensionContributionDrawdownPlan','Lump Sum','UnCrystallised','Standalone Lump Sum',1,1,1

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 6,'PensionContributionDrawdownPlan','Lump Sum','UnCrystallised','Serious Ill-Health Lump Sum (SIHLS)',1,1,1

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 7,'PensionContributionDrawdownPlan','Lump Sum','UnCrystallised','Winding Up Lump Sum',1,1,0

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 8,'PensionContributionDrawdownPlan','Lump Sum','UnCrystallised','Winding Up Lump Sum Death Benefit',1,0,0

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 9,'PensionContributionDrawdownPlan','Lump Sum','UnCrystallised','Annual Allowance Tax Charge (Scheme Pays)',0,1,0

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 10,'PensionContributionDrawdownPlan','Lump Sum','UnCrystallised','Uncrystallised Funds Lump Sum Death Benefit',1,1,1

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 11,'PensionContributionDrawdownPlan','Lump Sum','UnCrystallised','Charity Lump Sum Death Payment',1,1,0

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 12,'PensionContributionDrawdownPlan','Lump Sum','UnCrystallised','Special Lump Sum Death Benefit Charge',0,1,0

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 13,'PensionContributionDrawdownPlan','Lump Sum','UnCrystallised','Refund of Excess Contribution Lump Sum',1,0,0

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 14,'PensionContributionDrawdownPlan','Lump Sum','UnCrystallised','Overseas Transfer Charge (OTC)',0,1,0

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 15,'PensionContributionDrawdownPlan','Lump Sum','UnCrystallised','Inheritance Tax Charge',0,1,0

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 16,'PensionContributionDrawdownPlan','Lump Sum','FAD','Pension Commencement Lump Sum (PCLS)',0,1,1

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 17,'PensionContributionDrawdownPlan','Lump Sum','FAD','Income',1,0,0

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 18,'PensionContributionDrawdownPlan','Lump Sum','FAD','Small Lump Sum',1,1,0

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 19,'PensionContributionDrawdownPlan','Lump Sum','FAD','Winding Up Lump Sum',1,1,0

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 20,'PensionContributionDrawdownPlan','Lump Sum','FAD','Winding Up Lump Sum Death Benefit',1,0,0

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 21,'PensionContributionDrawdownPlan','Lump Sum','FAD','Drawdown Pension Fund Lump Sum Death Benefit',1,1,1

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 22,'PensionContributionDrawdownPlan','Lump Sum','FAD','Charity Lump Sum Death Payment',1,1,0

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 23,'PensionContributionDrawdownPlan','Lump Sum','FAD','Special Lump Sum Death Benefit Charge',0,1,0

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 24,'PensionContributionDrawdownPlan','Lump Sum','FAD','Overseas Transfer Charge (OTC)',0,1,0

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 25,'PensionContributionDrawdownPlan','Lump Sum','FAD','Inheritance Tax Charge',0,1,0

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 26,'PensionContributionDrawdownPlan','Lump Sum','Capped','Pension Commencement Lump Sum (PCLS)',0,1,1

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 27,'PensionContributionDrawdownPlan','Lump Sum','Capped','Income',1,0,0

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 28,'PensionContributionDrawdownPlan','Lump Sum','Capped','Small Lump Sum',1,1,0

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 29,'PensionContributionDrawdownPlan','Lump Sum','Capped','Winding Up Lump Sum',1,1,0

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 30,'PensionContributionDrawdownPlan','Lump Sum','Capped','Winding Up Lump Sum Death Benefit',1,0,0

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 31,'PensionContributionDrawdownPlan','Lump Sum','Capped','Drawdown Pension Fund Lump Sum Death Benefit',1,1,1

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 32,'PensionContributionDrawdownPlan','Lump Sum','Capped','Charity Lump Sum Death Payment',1,1,0

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 33,'PensionContributionDrawdownPlan','Lump Sum','Capped','Special Lump Sum Death Benefit Charge',0,1,0

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 34,'PensionContributionDrawdownPlan','Lump Sum','Capped','Overseas Transfer Charge (OTC)',0,1,0

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 35,'PensionContributionDrawdownPlan','Lump Sum','Capped','Inheritance Tax Charge',0,1,0

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 36,'PensionContributionDrawdownPlan','Regular','Annuity','Pension Commencement Lump Sum (PCLS)',0,1,1

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 37,'PensionContributionDrawdownPlan','Regular','UnCrystallised','Uncrystallised Funds Pension Lump Sum (UFPLS)',1,1,1

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 38,'PensionContributionDrawdownPlan','Regular','UnCrystallised','Pension Commencement Excess Lump Sum (PCELS)',1,0,0

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 39,'PensionContributionDrawdownPlan','Regular','FAD','Pension Commencement Lump Sum (PCLS)',0,1,1

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 40,'PensionContributionDrawdownPlan','Regular','FAD','Income',1,0,0

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 41,'PensionContributionDrawdownPlan','Regular','Capped','Pension Commencement Lump Sum (PCLS)',0,1,1

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 42,'PensionContributionDrawdownPlan','Regular','Capped','Income',1,0,0

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 43,'PensionContributionDrawdownPlan','Transfer','UnCrystallised','Pension Debit',0,1,0

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 44,'PensionContributionDrawdownPlan','Transfer','FAD','Pension Debit',0,1,0

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 45,'PensionContributionDrawdownPlan','Transfer','Capped','Pension Debit',0,1,0

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 46,'PensionDefinedBenefitPlan','Lump Sum',Null,'Tax Free Lump Sum',0,1,0

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 47,'PensionDefinedBenefitPlan','Lump Sum',Null,'Income',1,0,0

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 48,'PensionDefinedBenefitPlan','Lump Sum',Null,'Small Lump Sum',1,1,0

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 49,'PensionDefinedBenefitPlan','Lump Sum',Null,'Trivial Commutation Lump Sum',1,1,0

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 50,'PensionDefinedBenefitPlan','Lump Sum',Null,'Trivial Commutation Lump Sum Death Benefit',1,0,0

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 51,'PensionDefinedBenefitPlan','Lump Sum',Null,'Standalone Lump Sum',1,1,1

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 52,'PensionDefinedBenefitPlan','Lump Sum',Null,'Serious Ill-Health Lump Sum (SIHLS)',1,1,1

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 53,'PensionDefinedBenefitPlan','Lump Sum',Null,'Defined Benefits Lump Sum Death Benefit',1,1,1

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 54,'PensionDefinedBenefitPlan','Lump Sum',Null,'Winding Up Lump Sum',1,1,0

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 55,'PensionDefinedBenefitPlan','Lump Sum',Null,'Winding Up Lump Sum Death Benefit',1,0,0

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 56,'PensionDefinedBenefitPlan','Lump Sum',Null,'Pension Protection Lump Sum Death Benefit',1,1,1

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 57,'PensionDefinedBenefitPlan','Lump Sum',Null,'Short Service Refund Lump Sum',1,0,0

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 58,'PensionDefinedBenefitPlan','Regular',Null,'Tax Free Lump Sum',0,1,0

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 59,'PensionDefinedBenefitPlan','Regular',Null,'Income',1,0,0

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 60,'PensionDefinedBenefitPlan','Transfer',Null,'Pension Debit',0,1,0

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 61,'AnnuityPlan','Lump Sum',Null,'Pension Commencement Lump Sum (PCLS)',0,1,1

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 62,'AnnuityPlan','Lump Sum',Null,'Income',1,0,0

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 63,'AnnuityPlan','Lump Sum',Null,'Annuity Protection Lump Sum Death Benefit',1,1,1

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 64,'AnnuityPlan','Lump Sum',Null,'Special Lump Sum Death Benefit Charge',0,1,0

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 65,'AnnuityPlan','Regular',Null,'Pension Commencement Lump Sum (PCLS)',0,1,1

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 66,'AnnuityPlan','Regular',Null,'Income',1,0,0

		INSERT INTO TWithdrawalSubTypeConfiguration([Id],[PlanType], [Type], [ArrangementType], [WithdrawalSubType], [IsTaxable], [IsTaxFree], [IsCrystallizedAmount])
		SELECT 67,'AnnuityPlan','Transfer',Null,'Pension Debit',0,1,0

 
        SET IDENTITY_INSERT TWithdrawalSubTypeConfiguration OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (@ScriptGUID, @Comments,null,@currenttimestamp)
 
   IF @starttrancount = 0
    COMMIT TRANSACTION
 
END TRY
BEGIN CATCH
    DECLARE @ErrorMessage varchar(1000), @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorNumber INT
    		SELECT @ErrorMessage = ERROR_MESSAGE() , @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorNumber = ERROR_NUMBER(), @ErrorLine = ERROR_LINE()
    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber, @ErrorLine)
END CATCH
 
 SET XACT_ABORT OFF
 SET NOCOUNT OFF
