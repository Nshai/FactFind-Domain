SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditAdviseCategory]   @StampUser varchar (255),   @AdviseCategoryId bigint,   @StampAction char(1)  AS    INSERT INTO TAdviseCategoryAudit   ( Name, TenantId, IsArchived, ConcurrencyId,        AdviseCategoryId, StampAction, StampDateTime, StampUser, GroupId, IsPropagated)   Select Name, TenantId, IsArchived, ConcurrencyId,        AdviseCategoryId, @StampAction, GetDate(), @StampUser, GroupId, IsPropagated  FROM TAdviseCategory  WHERE AdviseCategoryId = @AdviseCategoryId    IF @@ERROR != 0 GOTO errh    RETURN (0)    errh:  RETURN (100)
GO
