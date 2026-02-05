CREATE TABLE [dbo].[TLimitedCompany]
(
[LimitedCompanyId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[OtherEmployeesToBeProtected] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TLimitedC__Concu__19EAC663] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TLimitedCompany_CRMContactId] ON [dbo].[TLimitedCompany] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
