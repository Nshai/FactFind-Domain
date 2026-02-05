CREATE TABLE [dbo].[TTradingStyle]
(
[TradingStyleId] [int] NOT NULL IDENTITY(1, 1),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TTradingStyle_ConcurrencyId] DEFAULT ((1)),
[TradingStyleDescription] [nvarchar] (500) COLLATE Latin1_General_CI_AS NULL,
[Email] [nvarchar] (500) COLLATE Latin1_General_CI_AS NULL,
[PhoneNumber] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[FaxNumber] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ProcFeePayableTo] [nvarchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[TenantId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TTradingStyle] ADD CONSTRAINT [PK_TTradingStyle] PRIMARY KEY CLUSTERED  ([TradingStyleId])
GO
