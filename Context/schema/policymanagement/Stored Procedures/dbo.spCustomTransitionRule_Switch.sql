SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[spCustomTransitionRule_Switch]
  @PolicyBusinessId bigint,
  @ResponseCode varchar(250)  output
AS
--    Check if  switch question is anwsered
       DECLARE @SwitchValue int
       DECLARE @SwitchExist int

       SET @SwitchValue = (SELECT SwitchFG FROM TPolicyBusiness WHERE PolicyBusinessId = @PolicyBusinessId)
       IF (@SwitchValue = 0)
       BEGIN
         SELECT @ResponseCode = 'SwitchValueIsNo'
       END
       IF (@SwitchValue = 1)
       BEGIN
         SET @SwitchExist  = (Select Count(SwitchId) From TSwitch Where PolicyBusinessId = @PolicyBusinessId)         
         IF (@SwitchExist = 0)
             SELECT @ResponseCode = 'SwitchNotExist'
       END



GO
