CREATE TABLE [dbo].[TRefAdditionalPropertyDetail]
(
[RefAdditionalPropertyDetailId] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefAdditionalPropertyDetail_ConcurrencyId] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TRefAdditionalPropertyDetail] ADD CONSTRAINT [PK_TRefAdditionalPropertyDetail] PRIMARY KEY NONCLUSTERED  ([RefAdditionalPropertyDetailId])
GO
