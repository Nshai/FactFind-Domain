CREATE TABLE [dbo].[TLeadType]
(
[LeadTypeId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Descriptor] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TLeadType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TLeadType] ADD CONSTRAINT [PK_TLeadType] PRIMARY KEY CLUSTERED  ([LeadTypeId]) WITH (FILLFACTOR=80)
GO
