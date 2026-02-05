CREATE TABLE [dbo].[TProtection]
(
[ProtectionId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (64)  NOT NULL,
[Income] [money] NULL,
[LumpSum] [money] NULL,
[Term] [int] NULL,
[BorneBy] [varchar] (16)  NULL,
[Joint] [bit] NOT NULL CONSTRAINT [DF_TProtection_Joint] DEFAULT ((0)),
[CrmContactId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TProtection_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TProtection] ADD CONSTRAINT [PK_TProtection_ProtectionId] PRIMARY KEY CLUSTERED  ([ProtectionId])
GO
ALTER TABLE [dbo].[TProtection] WITH CHECK ADD CONSTRAINT [FK_TProtection_CrmContactId_CrmContactId] FOREIGN KEY ([CrmContactId]) REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
