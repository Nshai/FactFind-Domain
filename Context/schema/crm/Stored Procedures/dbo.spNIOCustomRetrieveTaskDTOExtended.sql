USE [CRM]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
Modification History (most recent first)
Date        Modifier        Issue       Description
----        ---------       -------     -------------
20200115    Nick Fairway    IP-51896    Performance enhancements and refactored to use 3 sub procedures
*/
CREATE PROCEDURE dbo.spNIOCustomRetrieveTaskDTOExtended
    @UserId bigint, 
	@TenantId int,
	@PartyId bigint=0, 
	@Range tinyint=0, -- Historic = 0, Active = 1, All=2
	@GetAppointments tinyint =0,
	@IsShowSolicitor BIT = 0,
	@StartDate DATETIME = NULL,
	@EndDate DATETIME = NULL
AS
BEGIN

    DECLARE @CompleteFG bit
    DECLARE @DateCompletedStart DATETIME;
    DECLARE @DateCompletedEnd DATETIME;
    --Adjust end date to the end of the day
    SET @EndDate = IIF(@EndDate IS NULL, NULL, DATEADD(ms, -3, DATEADD(dd, DATEDIFF(dd, 0, ISNULL(@EndDate, GETDATE())) + 1, 0)));
    if (@Range = 1)
    BEGIN
        set @CompleteFG = 0
    END
    ELSE IF (@Range = 0)
    BEGIN
        SET @CompleteFG = 1
    END

    IF @PartyId <> 0
        EXEC dbo.spNIOCustomRetrievePartyTaskDTOExtended 
	                @UserId             = @UserId, 
	                @TenantId           = @TenantId, 
                    @PartyId            = @PartyId,
                    @Range              = @Range,
	                @GetAppointments    = @GetAppointments
    ELSE 
    BEGIN

        IF @CompleteFG = 0
            EXEC dbo.spNIOCustomRetrieveActiveUserTaskDTOExtended
                @UserId             = @UserId, 
	            @TenantId           = @TenantId, 
                @IsShowSolicitor    = @IsShowSolicitor
        ELSE
            EXEC dbo.spNIOCustomRetrieveCompleteUserTaskDTOExtended
                @UserId     = @UserId, 
                @TenantId   = @TenantId, 
                @StartDate  = @StartDate,
                @EndDate    = @EndDate

    END
END
GO

          

          