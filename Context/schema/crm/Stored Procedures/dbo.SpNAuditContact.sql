SET QUOTED_IDENTIFIER ON -- Set to ON to reduce the deadlocking
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditContact]
	@StampUser varchar (255),
	@ContactId bigint,
	@StampAction char(1)
AS

INSERT INTO
	TContactAudit
	(IndClientId
	, CRMContactId
	, RefContactType
	, [Description]
	, Value
	, DefaultFg
	, ConcurrencyId
	, ContactId
  	, FormattedPhoneNumber
  	, CreatedOn
  	, CreatedByUserId
  	, UpdatedOn
  	, UpdatedByUserId
	, StampAction
	, StampDateTime
	, StampUser)
SELECT
	IndClientId
	, CRMContactId
	, RefContactType
	, [Description]
	, Value
	, DefaultFg
	, ConcurrencyId
	, ContactId
  	, FormattedPhoneNumber
  	, CreatedOn
  	, CreatedByUserId
  	, UpdatedOn
  	, UpdatedByUserId
	, @StampAction
	, GetDate()
	, @StampUser
FROM
	TContact
WHERE
	ContactId = @ContactId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
