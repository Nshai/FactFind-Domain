USE policymanagement

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)

/*
Summary
-----------------------------------------------------------------------------------------------
Prepare a migration script for AU 'Wrap > Wrap Investment' migration. 

DatabaseName        TableName               Expected Rows
-----------------------------------------------------------------------------------------------
PolicyManagement    TRefPlanType2ProdSubType          1
PolicyManagement    RefPlanType          1
*/

SELECT 
    @ScriptGUID = '72A78E4C-88DC-457E-92AC-9CA67FA709A3', 
    @Comments = 'SE-6403 Prepare a migration script for AU "Wrap > Wrap Investment" migration'  

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRY
	BEGIN TRANSACTION
     
 DECLARE
     @StampActionUpdate CHAR(1) = 'U',
     @StampActionCreate CHAR(1) = 'C',
     @StampDateTime DATETIME = getdate(),
     @StampUserSystem CHAR(1) = '0',
     @OldRefPlanType INT = 113,
     @OldRefPlanType2ProdSubTypeId INT = 1204

            UPDATE TRefPlanType 
               SET [RetireFg] = 1
           OUTPUT 
                deleted.PlanTypeName,
                deleted.WebPage,
                deleted.OrigoRef,
                deleted.QuoteRef,
                deleted.NBRef,
                deleted.RetireFg,
                deleted.RetireDate,
                deleted.FindFg,
                deleted.SchemeType,
                deleted.IsWrapperFg,
                deleted.AdditionalOwnersFg,
                deleted.Extensible,
                deleted.ConcurrencyId,
                deleted.RefPlanTypeId,
                @StampActionUpdate, 
                @StampDateTime,
                @StampUserSystem,
                deleted.IsTaxQualifying
           INTO TRefPlanTypeAudit
                ( PlanTypeName,
                WebPage,
                OrigoRef,
                QuoteRef,
                NBRef,
                RetireFg,
                RetireDate,
                FindFg,
                SchemeType,
                IsWrapperFg,
                AdditionalOwnersFg,
                Extensible,
                ConcurrencyId,
                RefPlanTypeId,
                StampAction, 
                StampDateTime,
                StampUser,
                IsTaxQualifying)
            WHERE RefPlanTypeId = @OldRefPlanType

           UPDATE TRefPlanType2ProdSubType
                SET [IsArchived] = 1
           OUTPUT 
                deleted.RefPlanTypeId,
                deleted.ProdSubTypeId,
                deleted.RefPortfolioCategoryId,
                deleted.RefPlanDiscriminatorId,
                deleted.DefaultCategory,
                deleted.ConcurrencyId,
                deleted.RefPlanType2ProdSubTypeId,
                @StampActionUpdate, 
                @StampDateTime,
                @StampUserSystem,
                deleted.IsArchived,
                deleted.IsConsumerFriendly,
                deleted.RegionCode
           INTO TRefPlanType2ProdSubTypeAudit
                ( RefPlanTypeId,
                ProdSubTypeId,
                RefPortfolioCategoryId,
                RefPlanDiscriminatorId,
                DefaultCategory,
                ConcurrencyId,
                RefPlanType2ProdSubTypeId,
                StampAction, 
                StampDateTime,
                StampUser,
                IsArchived,
                IsConsumerFriendly,
                RegionCode)
         WHERE RefPlanType2ProdSubTypeId = @OldRefPlanType2ProdSubTypeId


    INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)

    COMMIT TRANSACTION
END TRY
BEGIN CATCH
    
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
    ;THROW

END CATCH


SET XACT_ABORT OFF
SET NOCOUNT OFF

RETURN;