CREATE TABLE [dbo].[TAdvisePaymentType]
(
[AdvisePaymentTypeId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[TenantId] [int] NOT NULL,
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TAdvisePaymentType_IsArchived] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAdvisePaymentType_ConcurrencyId] DEFAULT ((1)),
[Name] [nvarchar] (250) COLLATE Latin1_General_CI_AS NOT NULL,
[IsSystemDefined] [bit] NOT NULL CONSTRAINT [DF__TAdvisePa__IsSys__427A3CAF] DEFAULT ((0)),
[GroupId] [int] NULL,
[RefAdvisePaidById] [int] NOT NULL CONSTRAINT [DF_TAdvisePaymentType_RefAdvisePaidById] DEFAULT ((1)),
[PaymentProviderId] [int] NULL
)
GO
ALTER TABLE [dbo].[TAdvisePaymentType] ADD CONSTRAINT [PK_TAdvisePaymentType] PRIMARY KEY CLUSTERED  ([AdvisePaymentTypeId])
GO
CREATE NONCLUSTERED INDEX [IX_TAdvisePaymentType_GroupId] ON [dbo].[TAdvisePaymentType] ([GroupId])
GO
CREATE NONCLUSTERED INDEX [IX_TAdvisePaymentType_TenantId] ON [dbo].[TAdvisePaymentType] ([TenantId])
GO

