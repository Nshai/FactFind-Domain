SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Anulekha
-- Create date: 12/09/2013
-- Description:	Retrieves the next expectation due date.
-- =============================================
CREATE PROCEDURE [dbo].[SpNCustomNextExpectationDueDate] 
@FeeId bigint = 0,
@startDate date,
@lastDueDate date,
@CurrentUserDate datetime,
@outputDate date = null OUTPUT 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;	

    exec spExpectationsDueDate @FeeId,@startDate,@lastDueDate, @CurrentUserDate, @outputDate output
	select @outputDate as NextDueDate
	
END
GO
