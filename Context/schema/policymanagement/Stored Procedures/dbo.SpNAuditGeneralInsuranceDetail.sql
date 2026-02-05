SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditGeneralInsuranceDetail]
	@StampUser varchar (255),
	@GeneralInsuranceDetailId bigint,
	@StampAction char(1)
AS

INSERT INTO [PolicyManagement].[dbo].[TGeneralInsuranceDetailAudit]
            (
				ProtectionId
				,SumAssured
				,AdditionalCoverAmount
				,Owner2PercentageOfSumAssured
				,ExcessAmount
				,RefInsuranceCoverCategoryId
				,InsuranceCoverOptions
				,RefInsuranceCoverAreaId
				,RefInsuranceCoverTypeId
				,IsCoverNoteIssued
				,ConcurrencyId
				,GeneralInsuranceDetailId
				,StampAction
				,StampDateTime
				,StampUser
				,PlanMigrationRef
				,PolicyBusinessID
				,IndigoClientId 
           )
Select 
	ProtectionId
	,SumAssured
	,AdditionalCoverAmount
	,Owner2PercentageOfSumAssured
	,ExcessAmount
	,RefInsuranceCoverCategoryId
	,InsuranceCoverOptions
	,RefInsuranceCoverAreaId
	,RefInsuranceCoverTypeId
	,IsCoverNoteIssued
	,ConcurrencyId
	,GeneralInsuranceDetailId
	,@StampAction
	,GetDate()
	,@StampUser
	,PlanMigrationRef
	,PolicyBusinessID
	,IndigoClientId 
FROM [PolicyManagement].[dbo].[TGeneralInsuranceDetail]
WHERE GeneralInsuranceDetailId = @GeneralInsuranceDetailId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
