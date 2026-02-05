CREATE TABLE [dbo].[TBenefit]
(
[BenefitId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[RefBenefitTypeId] [int] NOT NULL,
[EmployeeId] [int] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TBenefit_ConcurrencyId_1__57] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TBenefit] ADD CONSTRAINT [PK_TBenefit_2__57] PRIMARY KEY NONCLUSTERED  ([BenefitId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TBenefit_EmployeeId] ON [dbo].[TBenefit] ([EmployeeId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TBenefit_RefBenefitTypeId] ON [dbo].[TBenefit] ([RefBenefitTypeId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TBenefit] ADD CONSTRAINT [FK_TBenefit_EmployeeId_EmployeeId] FOREIGN KEY ([EmployeeId]) REFERENCES [dbo].[TEmployee] ([EmployeeId])
GO
ALTER TABLE [dbo].[TBenefit] ADD CONSTRAINT [FK_TBenefit_RefBenefitTypeId_RefBenefitTypeId] FOREIGN KEY ([RefBenefitTypeId]) REFERENCES [dbo].[TRefBenefitType] ([RefBenefitTypeId])
GO
