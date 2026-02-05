CREATE TABLE [dbo].[TPartnership]
(
[PartnershipId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[OtherEmployeesToBeProtected] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TPartners__Concu__10615C29] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TPartnership_CRMContactId] ON [dbo].[TPartnership] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
