SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[spCustomTransitionRule_CheckClientServiceStatus]
  @PolicyBusinessId bigint,
  @ErrorMessage varchar(512) output
AS
BEGIN
 DECLARE @Owners TABLE
                    (
                        OwnerNumber INT IDENTITY (1, 1) PRIMARY KEY,
                        PolicyOwnerId BIGINT,
                        CRMContactId BIGINT
                    )

    INSERT INTO @Owners (PolicyOwnerId, CRMContactId)
    SELECT po.PolicyOwnerId,
           po.CRMContactId
    FROM TPolicyOwner po
             JOIN TPolicyBusiness pb ON pb.PolicyDetailId = po.PolicyDetailId
             JOIN crm..TCRMContact CRM ON CRM.CRMContactId = po.CRMContactId
    WHERE pb.PolicyBusinessId = @PolicyBusinessId
    ORDER BY po.PolicyOwnerId ASC

    DECLARE @Owner1Id BIGINT
    DECLARE @Owner2Id BIGINT

    SELECT @Owner1Id = CRMContactId FROM @Owners A WHERE OwnerNumber = 1
    SELECT @Owner2Id = CRMContactId FROM @Owners A WHERE OwnerNumber = 2

    DECLARE @Valid1 INT = 1
    DECLARE @Valid2 INT = 1

    SELECT @Valid1 = IIF(crm.RefServiceStatusId IS NOT NULL, 1, 0)
    FROM CRM..TCRMContact crm
    WHERE CRMContactId = @Owner1Id

       IF (@Owner2Id IS NOT NULL)
        BEGIN
            SELECT @Valid2 = IIF(crm.RefServiceStatusId IS NOT NULL, 1, 0)
            FROM CRM..TCRMContact crm
            WHERE CRMContactId = @Owner2Id
        END

       IF (@Valid1 = 0)
        SELECT @ErrorMessage = 'OwnerId'
     IF (@Valid2 = 0 AND @Owner2Id IS NOT NULL AND @Valid1 = 1)
         SELECT @ErrorMessage = 'SecondaryOwnerId'
     IF (@Valid2 = 0 AND @Owner2Id IS NOT NULL AND @Valid1 = 0)
         SELECT @ErrorMessage = 'OwnerId+SecondaryOwnerId'

       IF (LEN(ISNULL(@ErrorMessage, '')) > 0)
        BEGIN
            SET @ErrorMessage = @ErrorMessage + '_&OwnerId=' + CONVERT(VARCHAR(50), ISNULL(@Owner1Id, ''))
                + '&SecondaryOwnerId=' + CONVERT(VARCHAR(50), ISNULL(@Owner2Id, ''))
        END
END
GO