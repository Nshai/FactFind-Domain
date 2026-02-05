CREATE TABLE [dbo].[TSignatureAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NOT NULL,
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Value] [text] COLLATE Latin1_General_CI_AS NULL,
[DefaultFg] [bit] NOT NULL CONSTRAINT [DF_TSignatureAudit_DefaultFg] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TSignatureAudit_ConcurrencyId] DEFAULT ((1)),
[SignatureId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TSignatureAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TSignatureAudit] ADD CONSTRAINT [PK_TSignatureAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
