CREATE TABLE [dbo].[TRefAsuPhiCoverType]
(
[RefAsuPhiCoverTypeId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefAsuPhiCoverType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefAsuPhiCoverType] ADD CONSTRAINT [PK_TRefAsuPhiCoverType] PRIMARY KEY CLUSTERED  ([RefAsuPhiCoverTypeId])
GO
