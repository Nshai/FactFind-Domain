CREATE TABLE [dbo].[TLeadSource]
(
[LeadSourceId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[LeadTypeId] [int] NOT NULL,
[Descriptor] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Reference] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Cost] [money] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TLeadSource_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TLeadSource] ADD CONSTRAINT [PK_TLeadSource_LeadSourceId] PRIMARY KEY NONCLUSTERED  ([LeadSourceId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TLeadSource_LeadTypeIdASC] ON [dbo].[TLeadSource] ([LeadTypeId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TLeadSource] ADD CONSTRAINT [FK_TLeadSource_TRefSourceOfClient] FOREIGN KEY ([LeadTypeId]) REFERENCES [dbo].[TRefSourceOfClient] ([RefSourceOfClientId])
GO
