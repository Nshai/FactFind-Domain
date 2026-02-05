SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO


CREATE PROCEDURE [dbo].[spCustomTransitionRule_CheckEmploymentStatus]
  @PolicyBusinessId bigint,
  @CurrentDate date,
  @ErrorMessage varchar(1024) output
AS

BEGIN

    Declare @ClientCount tinyint
           ,@ClientType varchar(10)
           ,@Owner1Id Bigint
           ,@Owner2Id Bigint
           ,@Owner1Name Varchar(255)
           ,@Owner2Name Varchar(255)
           ,@message VARCHAR(max)

    EXEC spCustomTansitionRuleGetOwners @PolicyBusinessId, 
                                        @ClientCount OUTPUT, @ClientType OUTPUT,
                                        @Owner1Id OUTPUT, @Owner1Name OUTPUT, 
                                        @Owner2Id OUTPUT, @Owner2Name OUTPUT

    IF (@ClientType = 'CORPORATE' OR @ClientType = 'TRUST' )
    BEGIN
      SELECT @ErrorMessage = ''
      RETURN(0)
    END

    DECLARE @FactFindId bigint = null,
    @FactFindPrimaryOwnerId bigint = null,
    @HasSuitableEmploymentStatusOwner1 int = 0


    EXEC spCustomTansitionRule_CheckFactFind @Owner1Id, null, @Owner1Name, null, 1, 
        @FactFindId OUTPUT, @FactFindPrimaryOwnerId OUTPUT, @ErrorMessage OUTPUT

   if ISNULL(@ErrorMessage, '') != ''
    return

    IF @Owner1Id IS NOT NULL AND @Owner1Id!=0
    BEGIN

    SELECT @HasSuitableEmploymentStatusOwner1 = 
         COUNT(*) FROM [factfind].[dbo].[TEmploymentDetail] 
         WHERE CRMContactId = @Owner1Id AND (StartDate <= @CurrentDate OR StartDate IS NULL) AND
         (EndDate IS NULL OR EndDate >= @CurrentDate) 
    END

    IF @HasSuitableEmploymentStatusOwner1 > 0
       RETURN(0)

    SELECT @message = 
         'FactFindPrimaryOwnerId=' + convert(varchar(20),@FactFindPrimaryOwnerId) + '::'+
         'FactFindId=' + CONVERT(varchar(20),@FactFindId)

    SELECT @ErrorMessage = 'EMPLOYMENTSTATUS_' + @message

END


GO
