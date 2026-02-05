CREATE TABLE [dbo].[TRefNatureOfEmployment]
(
[RefNatureOfEmploymentId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Name] [varchar] (25) COLLATE Latin1_General_CI_AS NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefNatureOfEmployment_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefNatureOfEmployment] ADD CONSTRAINT [PK_TRefNatureOfEmployment] PRIMARY KEY NONCLUSTERED  ([RefNatureOfEmploymentId]) WITH (FILLFACTOR=80)
GO
