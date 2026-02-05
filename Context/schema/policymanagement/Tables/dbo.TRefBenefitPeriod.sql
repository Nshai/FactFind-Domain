CREATE TABLE [dbo].[TRefBenefitPeriod]
(
[RefBenefitPeriodId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Descriptor] [varchar] (20) COLLATE Latin1_General_CI_AS NOT NULL,
[ArchiveFG] [bit] NOT NULL,
[IndigoClientId] [int] NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TRefBenefitPeriod] ADD CONSTRAINT [PK_TRefBenefitPeriod] PRIMARY KEY CLUSTERED  ([RefBenefitPeriodId])
GO
