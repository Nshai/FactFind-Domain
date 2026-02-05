

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRegisterEntityChangeEvent]
	@EventName varchar(255),
	@EntityId int,
	@UserId int,
	@TenantId int,
	@AdditionalContext varchar(max) = null
AS


/*
------------ RULES OF THE GAME -----------------------

This stored procedure should be used to register for domain event(s) when a concerned entity like client, 
lead, etc is created/deleted/modified via database script.

The complete list of domain events and associated entities 
should be available in the 'IntelliFlo.IO.Core.DomainEvents.ChangeEvent.NameConstant' file.

Event Initialisation with custom properties -

If your database change should raise and initialise an event (with custom properties) 
then these properties (as specified in the event class) should be included in the additional context as '&' seperated name value items 
eg - SET @AdditionalContext = 'Status=Completed & LastUpdatedUserId=112233'

For an Array Property - enclose the array values in brackets as csv - 
eg. SET @AdditionalContext = 'Status=Completed & Sequences=[123,234,900]'

--------------- JOYFUL PLAY --------------------------
*/

raiserror('SpRegisterEntityChangeEvent needs fixing', 16,1)

/*

IF EXISTS(SELECT 1 FROM administration..TChangeEvent
WHERE EntityId = @EntityId AND UserId =@UserId AND TenantId = @TenantId AND LOWER(EventName) = LOWER(@EventName))
RAISERROR('change record already exists - Please delete existing to register new change', 16,1)

INSERT INTO administration..TChangeEvent(
	EntityId
,	UserId
,	TenantId
,	CreatedDate
,	LastUpdatedDate
,	EventName
,	AdditionalContext
,	IsProcessed
,	ProcessResult) 

SELECT 
	@EntityId
,	@UserId
,	@TenantId
,	GETDATE()
,	GETDATE()
,	@EventName
,	@AdditionalContext
,	0
,	NULL
*/
IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

