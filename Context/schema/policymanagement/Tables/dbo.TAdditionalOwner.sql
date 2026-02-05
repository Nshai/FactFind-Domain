CREATE TABLE [dbo].[TAdditionalOwner]
(
[AdditionalOwnerId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[PolicyBusinessId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAdditionalOwner_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAdditionalOwner] ADD CONSTRAINT [PK_TAdditionalOwner] PRIMARY KEY NONCLUSTERED  ([AdditionalOwnerId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TAdditionalOwner_PolicyBusinessId] ON [dbo].[TAdditionalOwner] ([PolicyBusinessId]) WITH (FILLFACTOR=80)
GO
