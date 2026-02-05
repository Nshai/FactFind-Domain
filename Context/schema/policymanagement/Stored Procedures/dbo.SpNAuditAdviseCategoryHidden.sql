SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Leena T.>
-- Create date: <11/08/2012>
-- Description:	<Audit SP for AdviseCategoryHidden>
-- =============================================
CREATE PROCEDURE [dbo].[SpNAuditAdviseCategoryHidden]
	-- Add the parameters for the stored procedure here
	@StampUser varchar (255),   
	@AdviseCategoryHiddenId bigint,   
	@StampAction char(1)  
AS

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO TAdviseCategoryHiddenAudit
	(AdviseCategoryHiddenId,	AdviseCategoryId, GroupId, TenantId, ConcurrencyId,
	StampAction, StampDateTime, StampUser)
	SELECT AdviseCategoryHiddenId,	AdviseCategoryId, GroupId, TenantId, ConcurrencyId,
	@StampAction, GetDate(), @StampUser
	FROM TAdviseCategoryHidden
	WHERE AdviseCategoryHiddenId = @AdviseCategoryHiddenId 

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
