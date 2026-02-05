CREATE TABLE [dbo].[TPartnershipKeyEmployees]
(
[PartnershipKeyEmployeesId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[Name] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[RolesDuties] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[DOB] [datetime] NULL,
[Smoker] [bit] NULL,
[GoodHealth] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TPartners__Concu__1249A49B] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TPartnershipKeyEmployees_CRMContactId] ON [dbo].[TPartnershipKeyEmployees] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
