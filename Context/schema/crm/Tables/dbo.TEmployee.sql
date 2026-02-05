CREATE TABLE [dbo].[TEmployee]
(
[EmployeeId] [int] NOT NULL IDENTITY(1, 1),
[OccupationId] [int] NOT NULL,
[EmployerCRMContactId] [int] NOT NULL,
[RefNatureOfEmploymentId] [int] NULL,
[GrossSalary] [money] NULL,
[MonthOfReview] [varchar] (50)  NULL,
[hasGuaranteedOT] [bit] NULL,
[GuaranteedRecieved] [varchar] (50)  NULL,
[hasBonus] [bit] NULL,
[IsBonusGuaranteed] [bit] NULL,
[BonusReceived] [varchar] (50)  NULL,
[hasCommission] [bit] NULL,
[IsCommissionGuarenteed] [bit] NULL,
[CommissionReceived] [varchar] (50)  NULL,
[IndClientId] [int] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TEmployee_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TEmployee] ADD CONSTRAINT [PK_TEmployee] PRIMARY KEY NONCLUSTERED  ([EmployeeId])
GO
CREATE NONCLUSTERED INDEX [IDX_TEmployee_EmployerCRMContactId] ON [dbo].[TEmployee] ([EmployerCRMContactId])
GO
CREATE NONCLUSTERED INDEX [IDX_TEmployee_OccupationId] ON [dbo].[TEmployee] ([OccupationId])
GO
CREATE NONCLUSTERED INDEX [IDX_TEmployee_RefNatureOfEmploymentId] ON [dbo].[TEmployee] ([RefNatureOfEmploymentId])
GO
ALTER TABLE [dbo].[TEmployee] WITH CHECK ADD CONSTRAINT [FK_TEmployee_EmployerCRMContactId_CRMContactId] FOREIGN KEY ([EmployerCRMContactId]) REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
ALTER TABLE [dbo].[TEmployee] ADD CONSTRAINT [FK_TEmployee_RefNatureOfEmploymentId_RefNatureOfEmploymentId] FOREIGN KEY ([RefNatureOfEmploymentId]) REFERENCES [dbo].[TRefNatureOfEmployment] ([RefNatureOfEmploymentId])
GO
