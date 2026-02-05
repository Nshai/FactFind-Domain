CREATE TABLE [dbo].[TRefPlanValueType]
(
[RefPlanValueTypeId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[RefPlanValueType] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[RetireFg] [bit] NULL CONSTRAINT [DF_TRefPlanValueType_RetireFg] DEFAULT ((0)),
[ServiceType] [int] NULL,
[ServiceTypeDescription] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefPlanValueType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefPlanValueType] ADD CONSTRAINT [PK_TRefPlanValueType] PRIMARY KEY NONCLUSTERED  ([RefPlanValueTypeId]) WITH (FILLFACTOR=80)
GO
