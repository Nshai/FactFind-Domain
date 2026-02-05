CREATE TABLE [dbo].[TRefBenefitType]
(
[RefBenefitTypeId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Name] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefBenefi_ConcurrencyId_1__57] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefBenefitType] ADD CONSTRAINT [PK_TRefBenefitType_2__57] PRIMARY KEY NONCLUSTERED  ([RefBenefitTypeId]) WITH (FILLFACTOR=80)
GO
