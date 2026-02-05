CREATE TABLE [dbo].[TMenuNodeRestrictedBy]
(
[MenuNodeRestrictedById] [int] NOT NULL IDENTITY(1, 1),
[RefMenuNodeRestrictedById] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[ProcessingOrder] [int] NOT NULL CONSTRAINT [DF_TMenuNodeRestrictedBy_ProcessingOrder] DEFAULT ((1)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TMenuNodeRestrictedBy_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TMenuNodeRestrictedBy] ADD CONSTRAINT [PK_TMenuNodeRestrictedBy] PRIMARY KEY CLUSTERED  ([MenuNodeRestrictedById])
GO
ALTER TABLE [dbo].[TMenuNodeRestrictedBy] ADD CONSTRAINT [FK_TMenuNodeRestrictedBy_TRefMenuNodeRestrictedBy] FOREIGN KEY ([RefMenuNodeRestrictedById]) REFERENCES [dbo].[TRefMenuNodeRestrictedBy] ([RefMenuNodeRestrictedById])
GO
