CREATE TABLE [dbo].[TThirdPartyAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ThirdPartyDescription] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TThirdPartyAudit_ConcurrencyId] DEFAULT ((1)),
[ThirdPartyId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TThirdPartyAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TThirdPartyAudit] ADD CONSTRAINT [PK_TThirdPartyAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TThirdPartyAudit_ThirdPartyId_ConcurrencyId] ON [dbo].[TThirdPartyAudit] ([ThirdPartyId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
