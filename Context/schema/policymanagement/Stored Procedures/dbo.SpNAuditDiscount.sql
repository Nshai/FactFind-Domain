SET QUOTED_IDENTIFIER ON
GO

SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		<Author,,Vinay>
-- Create date: <20-Dec-11,,>
-- Description:	<Audit SP to track the Discount Table DML operation,,>
--Modified by: Leena T.
--Modified Date: 15-05-2012
-- Description: Modified to add the group id column
-- =============================================
CREATE PROCEDURE [dbo].[SpNAuditDiscount]
	-- parameters Needed for the stored procedure
	@StampUser VARCHAR(255),
	@DiscountId BIGINT,
	@StampAction CHAR(1)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;

	-- Insert statements for procedure
	INSERT INTO TDiscountAudit (
		Name,
		Amount,
		Percentage,
		Reason,
		IsArchived,
		TenantId,
		ConcurrencyId,
		DiscountId,
		StampAction,
		StampDateTime,
		StampUser,
		GroupId,
  		IsRange,
  		MinAmount,
  		MaxAmount,
  		MinPercentage,
  		MaxPercentage
		)
	SELECT Name,
		Amount,
		Percentage,
		Reason,
		IsArchived,
		TenantId,
		ConcurrencyId,
		DiscountId,
		@StampAction,
		GetDate(),
		@StampUser,
		GroupId,
  		IsRange,
  		MinAmount,
  		MaxAmount,
  		MinPercentage,
  		MaxPercentage
	FROM TDiscount
	WHERE DiscountId = @DiscountId
END

IF @@ERROR != 0
	GOTO errh

RETURN (0)

errh:

RETURN (100)
GO


