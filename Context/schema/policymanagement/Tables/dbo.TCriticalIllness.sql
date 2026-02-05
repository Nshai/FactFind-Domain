CREATE TABLE [dbo].[TCriticalIllness]
(
[CriticalIllnessId] [int] NOT NULL IDENTITY(1, 1),
[Amount] [money] NULL,
[Term] [int] NULL,
[RefPremiumTypeId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TCriticalIllness_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TCriticalIllness] ADD CONSTRAINT [PK_TCriticalIllness] PRIMARY KEY NONCLUSTERED  ([CriticalIllnessId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TCriticalIllness_RefPremiumTypeId] ON [dbo].[TCriticalIllness] ([RefPremiumTypeId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TCriticalIllness] ADD CONSTRAINT [FK_TCriticalIllness_RefPremiumTypeId_RefPremiumTypeId] FOREIGN KEY ([RefPremiumTypeId]) REFERENCES [dbo].[TRefPremiumType] ([RefPremiumTypeId])
GO
