CREATE TABLE [dbo].[TRefIndexationType]
(
[RefIndexationTypeId] [int] NOT NULL IDENTITY(1, 1),
[IndexationTypeName] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[OrigoRef] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[FixedAmountFg] [tinyint] NULL,
[RetireFg] [tinyint] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefIndexa_ConcurrencyId_1__63] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefIndexationType] ADD CONSTRAINT [PK_TRefIndexationType_2__63] PRIMARY KEY NONCLUSTERED  ([RefIndexationTypeId]) WITH (FILLFACTOR=80)
GO
