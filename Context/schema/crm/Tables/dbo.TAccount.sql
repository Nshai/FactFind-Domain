CREATE TABLE [dbo].[TAccount]
(
[AccountId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[AccountTypeId] [int] NULL,
[RefAccountAccessId] [int] NULL,
[RefProductProviderId] [int] NULL,
[IndigoClientId] [int] NOT NULL,
[CreatedBy] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAccount_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAccount] ADD CONSTRAINT [PK_TAccount] PRIMARY KEY CLUSTERED  ([AccountId])
GO
CREATE NONCLUSTERED INDEX [IX_TAccount_IndigoClientId] ON [dbo].[TAccount] ([IndigoClientId])
go
CREATE NONCLUSTERED INDEX [IX_TAccount_RefProdProviderId_IndigoClientId] ON [dbo].[TAccount] ([RefProductProviderId],[IndigoClientId]) INCLUDE ([CRMContactId])
go
CREATE NONCLUSTERED INDEX IX_TAccount_CRMContactId ON [dbo].[TAccount] ([CRMContactId]) INCLUDE ([AccountId])
GO