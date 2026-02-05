CREATE TABLE [dbo].[TRefClientSegmentAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ClientSegmentName] [varchar] (50) NOT NULL,
[IndigoClientId] [int] NOT NULL,
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TRefClientSegmentAudit_IsArchived] DEFAULT ((0)),
[RefClientSegmentId] [int] NOT NULL,
[StampAction] [char] (1) NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefClientSegmentAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) NULL,
[GroupId] [int] NULL,
[IsPropagated] [bit] NOT NULL CONSTRAINT [DF_TRefClientSegmentAudit_IsPropagated] DEFAULT ((1)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefClientSegmentAudit_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefClientSegmentAudit] ADD CONSTRAINT [PK_TRefClientSegmentAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_Audit_TRefClientSegmentAudit_RefClientSegmentId_ConcurrencyId] ON [dbo].[TRefClientSegmentAudit] ([RefClientSegmentId], [ConcurrencyId])
GO
