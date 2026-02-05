SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spCustomTransitionRule_CheckClientSegment] @PolicyBusinessId BIGINT,
                                                                  @ErrorMessage VARCHAR(512) OUTPUT
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

    DECLARE @Valid1 INT
    DECLARE @Valid2 INT

    SELECT @Valid1 = IIF(crm.RefClientSegmentId IS NOT NULL, 1, 0)
    FROM CRM..TCRMContact crm
    WHERE CRMContactId = @Owner1Id

    IF @Valid1 IS NULL
        SET @Valid1 = 1

    IF (@Owner2Id IS NOT NULL)
        BEGIN
            SELECT @Valid2 = IIF(crm.RefClientSegmentId IS NOT NULL, 1, 0)
            FROM CRM..TCRMContact crm
            WHERE CRMContactId = @Owner2Id

            IF @Valid2 IS NULL
                SET @Valid2 = 1
        END

    IF (@Valid1 = 0)
        SELECT @ErrorMessage = 'PrimaryOwnerId'
     IF (@Valid2 = 0 AND @Owner2Id IS NOT NULL AND @Valid1 = 1)
         SELECT @ErrorMessage = 'SecondaryOwnerId'
     IF (@Valid2 = 0 AND @Owner2Id IS NOT NULL AND @Valid1 = 0)
         SELECT @ErrorMessage = 'PrimaryOwnerId+SecondaryOwnerId'

    IF (LEN(ISNULL(@ErrorMessage, '')) > 0)
        BEGIN
            SET @ErrorMessage = @ErrorMessage + '_&PrimaryOwnerId=' + CONVERT(VARCHAR(50), ISNULL(@Owner1Id, ''))
                + '&SecondaryOwnerId=' + CONVERT(VARCHAR(50), ISNULL(@Owner2Id, ''))

        END
END