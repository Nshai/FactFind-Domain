CREATE TABLE [dbo].[TPartnershipdetailsgeneral]
(
[PartnershipdetailsgeneralId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[PartnershipYesNo] [bit] NULL,
[partnershipdetailsgeneralYesNo] [bit] NULL,
[partnershipdetailsgeneralType] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[plansToIncorporateYesNo] [bit] NULL,
[Notes] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TPartnershipdetailsgeneral__ConcurrencyId] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TPartnershipdetailsgeneral_CRMContactId] ON [dbo].[TPartnershipdetailsgeneral] ([CRMContactId])
GO
