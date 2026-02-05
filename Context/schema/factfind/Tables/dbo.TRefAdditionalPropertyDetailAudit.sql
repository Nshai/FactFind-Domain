CREATE TABLE [dbo].[TRefAdditionalPropertyDetailAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefAdditionalPropertyDetailAudit_ConcurrencyId] DEFAULT ((0)),
[RefAdditionalPropertyDetailId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefAdditionalPropertyDetailAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefAdditionalPropertyDetailAudit] ADD CONSTRAINT [PK_TRefAdditionalPropertyDetailAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TRefAdditionalPropertyDetailAudit_RefAdditionalPropertyDetailId_ConcurrencyId] ON [dbo].[TRefAdditionalPropertyDetailAudit] ([RefAdditionalPropertyDetailId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
