CREATE TABLE [dbo].[TRefRiskEventType]
(
[RefRiskEventTypeId] [int] NOT NULL IDENTITY(1, 1),
[RiskEventTypeName] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[OrigoRef] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ContactAssuredFg] [tinyint] NULL,
[RetireFg] [tinyint] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefRiskEv_ConcurrencyId_1__63] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefRiskEventType] ADD CONSTRAINT [PK_TRefRiskEventType_2__63] PRIMARY KEY NONCLUSTERED  ([RefRiskEventTypeId]) WITH (FILLFACTOR=80)
GO
