CREATE TABLE [dbo].[TRefPaymentType]
(
[RefPaymentTypeId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[IndClientId] [int] NOT NULL,
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Description] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ActiveFG] [tinyint] NOT NULL CONSTRAINT [DF_TRefPaymentType_ActiveFG] DEFAULT ((0)),
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefPaymentType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefPaymentType] ADD CONSTRAINT [PK_TRefPaymentType] PRIMARY KEY NONCLUSTERED  ([RefPaymentTypeId]) WITH (FILLFACTOR=80)
GO
