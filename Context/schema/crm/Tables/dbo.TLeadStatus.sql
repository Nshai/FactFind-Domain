CREATE TABLE [dbo].[TLeadStatus]
(
[LeadStatusId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Descriptor] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[CanConvertToClientFG] [bit] NOT NULL,
[OrderNumber] [int] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[RefServiceStatusId] [int] NULL
)
GO
ALTER TABLE [dbo].[TLeadStatus] ADD CONSTRAINT [PK_TLeadStatus] PRIMARY KEY CLUSTERED  ([LeadStatusId]) WITH (FILLFACTOR=80)
GO
