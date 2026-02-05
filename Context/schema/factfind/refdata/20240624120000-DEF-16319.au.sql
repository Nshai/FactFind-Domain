USE FACTFIND;

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)
/*
Summary
Move 'Defined Benefit' from 'Final Salary Schemes' to 'Pension Plans' for AU region.
DatabaseName        TableName                       Expected Rows
Factfind            dbo.TRefPlanTypeToSection              1
*/

SELECT 
    @ScriptGUID = '03A39806-E39F-4E43-810B-DF63BEB67462', 
    @Comments = 'DEF-16319 Adding a Defined Benefit to a Fact Find' 

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON


BEGIN TRY

        DECLARE @CurrentSectionName varchar(32) = 'Final Salary Schemes',
                @NewSectionName varchar(32) = 'Pension Plans',
                @PlanTypeName varchar(32) = 'Defined Benefit',
                @RegionCode varchar(2) = 'AU',
                @RefPlanTypeToSectionId int;

        BEGIN

        BEGIN TRANSACTION

            SELECT @RefPlanTypeToSectionId = PTS.RefPlanType2ProdSubTypeId
                FROM TRefPlanTypeToSection PTS
                JOIN PolicyManagement..TRefPlanType2ProdSubType P2P WITH(NOLOCK) ON P2P.RefPlanType2ProdSubTypeId = PTS.RefPlanType2ProdSubTypeId
                JOIN PolicyManagement..TRefPlanType PType WITH(NOLOCK) ON PType.RefPlanTypeId = P2P.RefPlanTypeId
            WHERE
                PTS.Section = @CurrentSectionName 
                AND PType.RetireFg = 0
                AND PType.PlanTypeName = @PlanTypeName
                AND P2P.RegionCode = @RegionCode

            UPDATE [dbo].[TRefPlanTypeToSection]
                SET [Section] = @NewSectionName
                WHERE RefPlanType2ProdSubTypeId = @RefPlanTypeToSectionId

           INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)


        COMMIT TRANSACTION
       END

END TRY
BEGIN CATCH

    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
    ;THROW

END CATCH

SET XACT_ABORT OFF
SET NOCOUNT OFF

RETURN;
