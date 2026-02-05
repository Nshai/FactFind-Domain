CREATE TABLE [dbo].[TDelegateAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NOT NULL,
[DelegatedUserId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TDelegateA_ConcurrencyId_1__56] DEFAULT ((1)),
[DelegateId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TDelegateA_StampDateTime_2__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TDelegateAudit] ADD CONSTRAINT [PK_TDelegateAudit_3__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TDelegateAudit_DelegateId_ConcurrencyId] ON [dbo].[TDelegateAudit] ([DelegateId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
