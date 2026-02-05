CREATE TABLE [dbo].[TProductTerm]
(
[ProductTermId] [int] NOT NULL IDENTITY(1, 1),
[TermType] [nvarchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Value] [int] NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TProductTerm_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TProductTerm] ADD CONSTRAINT [PK_TProductTerm] PRIMARY KEY CLUSTERED  ([ProductTermId])
GO
