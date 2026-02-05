CREATE TABLE [dbo].[TBankEx]
(
[ExtensibleColumnId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Description] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Type] [int] NOT NULL,
[TypeDescription] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Size] [int] NULL CONSTRAINT [DF_TBankEx_Size_3__93] DEFAULT ((0)),
[Required] [int] NOT NULL CONSTRAINT [DF_TBankEx_Required_2__93] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TBankEx_ConcurrencyId_1__93] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TBankEx] ADD CONSTRAINT [PK_TBankEx_4__93] PRIMARY KEY NONCLUSTERED  ([ExtensibleColumnId]) WITH (FILLFACTOR=80)
GO
