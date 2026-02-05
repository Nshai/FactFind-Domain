CREATE TABLE [dbo].[TPostCodeAllocationGroupAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[AllocationGroupName] [nvarchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[PostCodeAllocationGroupId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPostCodeAllocationGroupAudit] ADD CONSTRAINT [PK_TPostCodeAllocationGroupAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
