CREATE TABLE [dbo].[TPostCodeAllocationGroupPostCodeAssignedAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[PostCodeAllocationGroupId] [int] NOT NULL,
[PostCodeId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[PostCodeAllocationGroupPostCodeAssignedId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
