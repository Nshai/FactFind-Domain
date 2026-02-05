SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE dbo.nio_DeleteGroupSchemeMembersWithDeletedPlans
@GroupSchemeId BIGINT,
@TenantId BIGINT

AS

SET NOCOUNT ON

DECLARE @RowsAffected BIGINT
SET @RowsAffected = 0

BEGIN

	IF EXISTS(
			SELECT 
				1
			FROM
				PolicyManagement.dbo.TGroupSchemeMember GSM
				JOIN PolicyManagement.dbo.TStatusHistory SH ON SH.PolicyBusinessId = GSM.PolicyBusinessId
				JOIN PolicyManagement.dbo.TStatus S ON S.StatusId = SH.StatusId	
			WHERE
				GSM.GroupSchemeId = @GroupSchemeId
				AND 
				GSM.TenantId = @TenantId
				AND
				S.IntelligentOfficeStatusType = 'Deleted' 
			)
	BEGIN

		BEGIN TRAN

			INSERT INTO
				PolicyManagement.dbo.TGroupSchemeMemberAudit
				(
				GroupSchemeId,
				TenantId,
				CRMContactId,
				GroupSchemeCategoryId,
				PolicyBusinessId,
				JoiningDate,
				LeavingDate,
				IsLeaver,
				ConcurrencyId,
				GroupSchemeMemberId,
				StampAction,
				StampDateTime,
				StampUser
				)
			SELECT
				GSM.GroupSchemeId,
				GSM.TenantId,
				GSM.CRMContactId,
				GSM.GroupSchemeCategoryId,
				GSM.PolicyBusinessId,
				GSM.JoiningDate,
				GSM.LeavingDate,
				GSM.IsLeaver,
				GSM.ConcurrencyId,
				GSM.GroupSchemeMemberId,
				'D',
				getdate(),
				'999999999'
			FROM
				PolicyManagement.dbo.TGroupSchemeMember GSM
				JOIN PolicyManagement.dbo.TStatusHistory SH ON SH.PolicyBusinessId = GSM.PolicyBusinessId
				JOIN PolicyManagement.dbo.TStatus S ON S.StatusId = SH.StatusId	
			WHERE
				GSM.GroupSchemeId = @GroupSchemeId
				AND 
				GSM.TenantId = @TenantId
				AND
				S.IntelligentOfficeStatusType = 'Deleted'

			SET @RowsAffected = @@ROWCOUNT 

			DELETE
				PolicyManagement.dbo.TGroupSchemeMember
			WHERE
				GroupSchemeMemberId IN
				(
				SELECT
					GSM.GroupSchemeMemberId
				FROM
					PolicyManagement.dbo.TGroupSchemeMember GSM
					JOIN PolicyManagement.dbo.TStatusHistory SH ON SH.PolicyBusinessId = GSM.PolicyBusinessId
					JOIN PolicyManagement.dbo.TStatus S ON S.StatusId = SH.StatusId	
				WHERE
					GSM.GroupSchemeId = @GroupSchemeId
					AND 
					GSM.TenantId = @TenantId
					AND
					S.IntelligentOfficeStatusType = 'Deleted'
				)

		COMMIT
	
	END

SET NOCOUNT OFF

SELECT @RowsAffected

END
GO
