SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpCustomTransitionRule_CheckIdVerificationdHasExpired]
  @PolicyBusinessId BIGINT,
  @ErrorMessage VARCHAR(512) OUTPUT
AS    
    DECLARE  @ClientCount TINYINT
            ,@Owner1Id BIGINT 
            ,@Owner2Id BIGINT 
            ,@Owner1Name VARCHAR(255)
            ,@Owner2Name VARCHAR(255)
            ,@ClientType VARCHAR(10)
            ,@Valid1 INT = 0
            ,@Valid2 INT = 0
            ,@CurrentDate DATETIME = GETDATE();
        
    EXEC spCustomTansitionRuleGetOwners @PolicyBusinessId, 
                                        @ClientCount OUTPUT, @ClientType OUTPUT,
                                        @Owner1Id OUTPUT, @Owner1Name OUTPUT, 
                                        @Owner2Id OUTPUT, @Owner2Name OUTPUT;    

    -- The rule works for Person type only
    IF @ClientType = 'PERSON'
    BEGIN
        SELECT @Valid1 = COUNT(1)
        FROM CRM.dbo.TVerification
        WHERE CRMContactId = @Owner1Id AND VerificationExpiryDate > @CurrentDate;
    END
    ELSE        
    BEGIN
        SET @Valid1 = 1;
    END

    If(@Owner2Id IS NOT NULL)
    BEGIN
        -- The rule works for Person type only
        SELECT @Valid2 = IIF(MAX(c.PersonId) IS NOT NULL, COUNT(v.VerificationId), 1)
        FROM CRM..TCRMContact c
        LEFT JOIN CRM.dbo.TVerification v ON v.CRMContactId = c.CRMContactId AND v.VerificationExpiryDate > @CurrentDate
        WHERE c.CRMContactId = @Owner2Id
        GROUP BY c.CRMContactId;
    END

    IF (@Valid1 = 0)
        SET @ErrorMessage = 'OWNER1';
    IF (@Valid2 = 0 and @Owner2Id is not null and @Valid1 > 0)
        SET @ErrorMessage = 'OWNER2';
    IF (@Valid2 = 0 and @Owner2Id is not null and @Valid1 = 0)
        SET @ErrorMessage = 'OWNER1+OWNER2';
    
    --Add Owner Data for side bar link generator
    IF(LEN(ISNULL(@ErrorMessage, '')) > 0)
    BEGIN        
        SET @ErrorMessage = @ErrorMessage + '_::Owner1Id=' + CONVERT(varchar(50), ISNULL(@Owner1Id,''))
                                          + '::Owner1Name=' + CONVERT(varchar(255), ISNULL(@Owner1Name,''))
                                          + '::Owner2Id=' + CONVERT(varchar(50), ISNULL(@Owner2Id,''))
                                          + '::Owner2Name=' + CONVERT(varchar(255), ISNULL(@Owner2Name,''));

    END    
GO