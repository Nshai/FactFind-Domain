CREATE TABLE [dbo].[TKfiGroup]
(
[KfiGroupId] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NOT NULL,
[FactFindId] [int] NOT NULL,
[QuoteId] [int] NOT NULL,
[GenerationDate] [datetime] NOT NULL CONSTRAINT [DF_TKfiGroup_GenerationDate] DEFAULT (getdate()),
[EmailClient] [bit] NOT NULL CONSTRAINT [DF_TKfiGroup_EmailClient] DEFAULT ((0)),
[GenerateAdviserSummary] [bit] NOT NULL CONSTRAINT [DF_TKfiGroup_GenerateAdviserSummary] DEFAULT ((0)),
[AdviserSummaryDocVersionId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TKfiGroup_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TKfiGroup] ADD CONSTRAINT [PK_TKfiGroup] PRIMARY KEY NONCLUSTERED  ([KfiGroupId])
GO
