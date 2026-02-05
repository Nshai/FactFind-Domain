CREATE TABLE [dbo].[TMortgageSourcing]
(
[MortgageSourcingId] [int] NOT NULL IDENTITY(1, 1),
[ApplicationLinkId] [int] NOT NULL,
[IsSaveDocuments] [tinyint] NOT NULL CONSTRAINT [DF_TMortgageSourcing_IsSaveDocuments] DEFAULT ((0)),
[DocumentCategoryId] [int] NULL,
[DocumentSubCategoryId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TMortgageSourcing_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TMortgageSourcing] ADD CONSTRAINT [PK_TMortgageSourcing] PRIMARY KEY NONCLUSTERED  ([MortgageSourcingId])
GO
