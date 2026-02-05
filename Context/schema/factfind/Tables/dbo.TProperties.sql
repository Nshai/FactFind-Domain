CREATE TABLE [dbo].[TProperties]
(
[PropertiesId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[Type] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[LivingHere] [bit] NULL,
[Adviser] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[AdviserId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TProperti__Concu__77CAB889] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TProperties_CRMContactId] ON [dbo].[TProperties] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
