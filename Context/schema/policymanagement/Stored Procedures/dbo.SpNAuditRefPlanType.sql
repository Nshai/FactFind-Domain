SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditRefPlanType]
	@StampUser varchar (255),
	@RefPlanTypeId bigint,
	@StampAction char(1)
AS
BEGIN
	INSERT INTO dbo.TRefPlanTypeAudit 
	(
		PlanTypeName, WebPage, OrigoRef, QuoteRef,NBRef, RetireFg, RetireDate, FindFg
		,SchemeType, IsWrapperFg, AdditionalOwnersFg, ConcurrencyId,IsTaxQualifying
		,RefPlanTypeId, StampAction, StampDateTime, StampUser
	) 
	SELECT
		pt.PlanTypeName, pt.WebPage, pt.OrigoRef, pt.QuoteRef,pt.NBRef, pt.RetireFg, pt.RetireDate, pt.FindFg
		,pt.SchemeType, pt.IsWrapperFg, pt.AdditionalOwnersFg, pt.ConcurrencyId,pt.IsTaxQualifying
		,pt.RefPlanTypeId, @StampAction, GetDate(), @StampUser
	FROM dbo.TRefPlanType AS pt
	WHERE (pt.RefPlanTypeId = @RefPlanTypeId);

	IF (@@ERROR <> 0)
		GOTO errh;

	RETURN (0);

	errh:
	RETURN (100);
END
GO
