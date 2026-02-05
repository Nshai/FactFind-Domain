CREATE TABLE [dbo].[TLifeCover]
(
[LifeCoverId] [int] NOT NULL IDENTITY(1, 1),
[Amount] [money] NULL,
[Term] [int] NULL,
[RefPremiumTypeId] [int] NULL,
[RefPaymentBasisId] [int] NULL,
[RefPaymentTypeId] [int] NULL,
[RefOptionsId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TLifeCover_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TLifeCover] ADD CONSTRAINT [PK_TLifeCover] PRIMARY KEY NONCLUSTERED  ([LifeCoverId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TLifeCover_RefOptionsId] ON [dbo].[TLifeCover] ([RefOptionsId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TLifeCover_RefPaymentBasisId] ON [dbo].[TLifeCover] ([RefPaymentBasisId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TLifeCover_RefPaymentTypeId] ON [dbo].[TLifeCover] ([RefPaymentTypeId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TLifeCover_RefPremiumTypeId] ON [dbo].[TLifeCover] ([RefPremiumTypeId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TLifeCover] ADD CONSTRAINT [FK_TLifeCover_RefOptionsId_RefOptionsId] FOREIGN KEY ([RefOptionsId]) REFERENCES [dbo].[TRefOptions] ([RefOptionsId])
GO
ALTER TABLE [dbo].[TLifeCover] ADD CONSTRAINT [FK_TLifeCover_RefPaymentBasisId_RefPaymentBasisId] FOREIGN KEY ([RefPaymentBasisId]) REFERENCES [dbo].[TRefPaymentBasis] ([RefPaymentBasisId])
GO
ALTER TABLE [dbo].[TLifeCover] ADD CONSTRAINT [FK_TLifeCover_RefPaymentTypeId_RefPaymentTypeId] FOREIGN KEY ([RefPaymentTypeId]) REFERENCES [dbo].[TRefPaymentType] ([RefPaymentTypeId])
GO
ALTER TABLE [dbo].[TLifeCover] ADD CONSTRAINT [FK_TLifeCover_RefPremiumTypeId_RefPremiumTypeId] FOREIGN KEY ([RefPremiumTypeId]) REFERENCES [dbo].[TRefPremiumType] ([RefPremiumTypeId])
GO
