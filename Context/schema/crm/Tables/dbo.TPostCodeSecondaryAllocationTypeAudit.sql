CREATE TABLE [dbo].[TPostCodeSecondaryAllocationTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[SecondaryAllocationTypeName] [nvarchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[SecondaryAllocationTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPostCodeSecondaryAllocationTypeAudit] ADD CONSTRAINT [PK_TPostCodeSecondaryAllocationTypeAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
