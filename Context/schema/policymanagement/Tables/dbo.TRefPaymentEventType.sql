CREATE TABLE [dbo].[TRefPaymentEventType]
(
[RefPaymentEventTypeId] [int] NOT NULL IDENTITY(1, 1),
[PaymentEventTypeName] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[RetireFg] [tinyint] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefPaymen_ConcurrencyId_2__63] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefPaymentEventType] ADD CONSTRAINT [PK_TRefPaymentEventType_3__63] PRIMARY KEY NONCLUSTERED  ([RefPaymentEventTypeId]) WITH (FILLFACTOR=80)
GO
