CREATE TABLE [dbo].[TPostCodePrimaryAllocationTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[PrimaryAllocationTypeName] [nvarchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[PrimaryAllocationTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPostCodePrimaryAllocationTypeAudit] ADD CONSTRAINT [PK_TPostCodePrimaryAllocationTypeAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
