SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[spCustomTransitionRule_CheckDOB]
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
    DECLARE @Valid2 INT= 1

    DECLARE @CRMContactType1 bigint
    DECLARE @CRMContactType2 bigint

	SELECT @CRMContactType1 = crm.CRMContactType FROM CRM..TCRMContact crm WHERE CRMContactId = @Owner1Id

    IF(@CRMContactType1 = 1)
    BEGIN 
        SELECT @Valid1 = IIF(crm.DOB IS NOT NULL, 1, 0)
        FROM CRM..TCRMContact crm
        WHERE CRMContactId = @Owner1Id
    END


       IF (@Owner2Id IS NOT NULL)
        BEGIN

               SELECT @CRMContactType2 = crm.CRMContactType FROM CRM..TCRMContact crm WHERE CRMContactId = @Owner2Id

               IF(@CRMContactType2 = 1)
               BEGIN
                   SELECT @Valid2 = IIF(crm.DOB IS NOT NULL, 1, 0)
                   FROM CRM..TCRMContact crm
                   WHERE CRMContactId = @Owner2Id
                END
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

GO