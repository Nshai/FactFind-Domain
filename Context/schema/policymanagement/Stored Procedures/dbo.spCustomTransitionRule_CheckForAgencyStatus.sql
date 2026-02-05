SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[spCustomTransitionRule_CheckForAgencyStatus]
  @PolicyBusinessId bigint,
  @ErrorMessage varchar(512) output
AS

--  Check if agency status is selected
    DECLARE @AgencyStatus varchar(50),
            @TopupMasterPolicyBusinessId int

    SET @AgencyStatus = (SELECT AgencyStatus FROM TPolicyBusinessExt WHERE PolicyBusinessId = @PolicyBusinessId)
    SET @TopupMasterPolicyBusinessId = (SELECT TopupMasterPolicyBusinessId FROM TPolicyBusiness WHERE PolicyBusinessId = @PolicyBusinessId)

    IF ((ISNULL(@AgencyStatus,'') = '' OR @AgencyStatus = 'NotSelected') AND ISNULL(@TopupMasterPolicyBusinessId, '') = '')
    BEGIN
        SELECT @ErrorMessage = 'Agency status is mandatory'
    END

GO