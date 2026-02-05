CREATE TABLE [dbo].[TAtrRefAccessOption]
(
[AtrRefAccessOptionId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrRefAccessOption_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAtrRefAccessOption] ADD CONSTRAINT [PK_TAtrRefAccessOption] PRIMARY KEY NONCLUSTERED  ([AtrRefAccessOptionId]) WITH (FILLFACTOR=80)
GO
