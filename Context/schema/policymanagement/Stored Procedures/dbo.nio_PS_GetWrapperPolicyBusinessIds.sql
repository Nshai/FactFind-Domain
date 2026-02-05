SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Teodora Pilitis
-- Create date: 26 March 2015
-- Description:	Returns Wrapper PolicyBusinessIds for the list of specified plan id(s)
-- =============================================
CREATE PROCEDURE [dbo].[nio_PS_GetWrapperPolicyBusinessIds]
	-- Add the parameters for the stored procedure here
	@PolicyBusinessIds VARCHAR(MAX)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT DISTINCT 
		ParentPolicyBusinessId
	FROM
		TWrapperPolicyBusiness
	WHERE
		PolicyBusinessId IN 
			(SELECT 
				Value 
			FROM
				dbo.[FnSplit](@PolicyBusinessIds,','))
END
GO
