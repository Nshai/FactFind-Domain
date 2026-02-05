CREATE TABLE [dbo].[TLead]
(
[LeadId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[LeadSourceId] [int] NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TLead_ConcurrencyId] DEFAULT ((1)),
[IntroducerEmployeeId] [int] NULL,
[IntroducerBranchId] [int] NULL,
[IndividualName] [varchar] (255) NULL
)
GO
ALTER TABLE [dbo].[TLead] ADD CONSTRAINT [PK_TLead_LeadId] PRIMARY KEY CLUSTERED  ([LeadId])
GO
CREATE NONCLUSTERED INDEX [IX_TLead_CRMContactIdASC] ON [dbo].[TLead] ([CRMContactId])
GO
CREATE NONCLUSTERED INDEX [IX_TLead_IndigoClientId_CRMContactId] ON [dbo].[TLead] ([IndigoClientId], [CRMContactId])
GO
CREATE NONCLUSTERED INDEX [IX_TLead_LeadSourceIdASC] ON [dbo].[TLead] ([LeadSourceId])
GO
create index IX_Tlead_LeadId_CRMContactId_IntroducerEmployeeId_IntroducerBranchId on Tlead (LeadId,CRMContactId,IntroducerEmployeeId,IntroducerBranchId) 
GO