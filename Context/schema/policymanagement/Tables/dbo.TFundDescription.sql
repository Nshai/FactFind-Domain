CREATE TABLE [dbo].[TFundDescription]
(
[FundDescriptionId] [int] NOT NULL IDENTITY(1, 1),
[Descriptor] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFundDescription_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFundDescription] ADD CONSTRAINT [PK_TFundDescription] PRIMARY KEY NONCLUSTERED  ([FundDescriptionId]) WITH (FILLFACTOR=80)
GO
