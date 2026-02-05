CREATE TABLE [dbo].[TDebt]
(
[DebtId] [int] NOT NULL IDENTITY(1, 1),
[ShortTermDebt] [money] NULL,
[LongTermDebt] [money] NULL,
[ShortDeathProtection] [bit] NULL CONSTRAINT [DF_TDebt_ShortDeathProtection] DEFAULT ((0)),
[ShortSicknessProtection] [bit] NULL CONSTRAINT [DF_TDebt_ShortSicknessProtection] DEFAULT ((0)),
[ShortUnemploymentProtection] [bit] NULL CONSTRAINT [DF_TDebt_ShortUnemploymentProtection] DEFAULT ((0)),
[LongDeathProtection] [bit] NULL CONSTRAINT [DF_TDebt_LongDeathProtection] DEFAULT ((0)),
[LongSicknessProtection] [bit] NULL CONSTRAINT [DF_TDebt_LongSicknessProtection] DEFAULT ((0)),
[LongUnemploymentProtection] [bit] NULL CONSTRAINT [DF_TDebt_LongUnemploymentProtection] DEFAULT ((0)),
[Arrears] [bit] NULL CONSTRAINT [DF_TDebt_Arrears] DEFAULT ((0)),
[Judgements] [bit] NULL CONSTRAINT [DF_TDebt_Judgements] DEFAULT ((0)),
[Joint] [bit] NULL CONSTRAINT [DF_TDebt_Joint] DEFAULT ((0)),
[ClearedPreRetire] [bit] NULL CONSTRAINT [DF_TDebt_ClearedPreRetire] DEFAULT ((0)),
[ClearedPreRetireDetail] [varchar] (255)  NULL,
[CrmContactId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TDebt_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TDebt] ADD CONSTRAINT [PK_TDebt_DebtId] PRIMARY KEY CLUSTERED  ([DebtId])
GO
ALTER TABLE [dbo].[TDebt] WITH CHECK ADD CONSTRAINT [FK_TDebt_CrmContactId_CrmContactId] FOREIGN KEY ([CrmContactId]) REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
