CREATE TABLE [dbo].[TRefPhiTransferCoverType]
(
[RefPhiTransferCoverTypeId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Description] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefPhiTransferCoverType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefPhiTransferCoverType] ADD CONSTRAINT [PK_TRefPhiTransferCoverType] PRIMARY KEY CLUSTERED  ([RefPhiTransferCoverTypeId])
GO
