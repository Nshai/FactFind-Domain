CREATE TABLE [dbo].[TPostCodeAllocationGroupAdviserAssignedAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[PostCodeAllocationGroupId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[PostCodeAllocationGroupAdviserAssignedId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPostCodeAllocationGroupAdviserAssignedAudit] ADD CONSTRAINT [PK_TPostCodeAllocationGroupAdviserAssignedAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
