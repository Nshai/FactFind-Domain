CREATE TABLE [dbo].[TRefCommissionType]
(
[RefCommissionTypeId] [int] NOT NULL IDENTITY(1, 1),
[CommissionTypeName] [varchar] (50)  NULL,
[RefLicenseTypeId] [int] NULL,
[OrigoRef] [varchar] (50)  NULL,
[InitialCommissionFg] [tinyint] NULL,
[RecurringCommissionFg] [tinyint] NULL,
[RetireFg] [tinyint] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefCommis_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefCommissionType] ADD CONSTRAINT [PK_TRefCommissionType] PRIMARY KEY CLUSTERED  ([RefCommissionTypeId])
GO
CREATE NONCLUSTERED INDEX [IX_TRefCommissionType] ON [dbo].[TRefCommissionType] ([CommissionTypeName], [RefCommissionTypeId])
GO
CREATE NONCLUSTERED INDEX [IX_TRefCommissionType_All_Fields] ON [dbo].[TRefCommissionType] ([RefCommissionTypeId], [CommissionTypeName], [OrigoRef], [InitialCommissionFg], [RecurringCommissionFg], [RetireFg], [ConcurrencyId])
GO
