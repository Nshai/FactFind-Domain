CREATE TABLE [dbo].[TRefFeeType]
(
[RefFeeTypeId] [int] NOT NULL IDENTITY(1, 1),
[FeeTypeName] [varchar] (255)  NULL,
[RefVATId] [int] NULL,
[FeeFg] [bit] NULL CONSTRAINT [DF_TRefFeeType_FeeFg] DEFAULT ((0)),
[RetainerFg] [bit] NULL CONSTRAINT [DF_TRefFeeType_RetainerFg] DEFAULT ((0)),
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TRefFeeType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefFeeType] ADD CONSTRAINT [PK_TRefFeeType] PRIMARY KEY NONCLUSTERED  ([RefFeeTypeId])
GO
CREATE NONCLUSTERED INDEX [IDX_TRefFeeType_RefVATId] ON [dbo].[TRefFeeType] ([RefVATId])
GO
ALTER TABLE [dbo].[TRefFeeType] WITH CHECK ADD CONSTRAINT [FK_TRefFeeType_RefVATId_RefVATId] FOREIGN KEY ([RefVATId]) REFERENCES [dbo].[TRefVAT] ([RefVATId])
GO
