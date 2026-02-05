CREATE TABLE [dbo].[TCorporateAdviceAreas]
(
[CorporateAdviceAreasId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[advicetype] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[PA] [bit] NULL,
[RPA] [bit] NULL,
[SIA] [bit] NULL,
[DateOfFirstAppointment] [datetime] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TCorporateAdviceAreas__ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TCorporateAdviceAreas] ADD CONSTRAINT [PK_TCorporateAdviceAreas] PRIMARY KEY NONCLUSTERED  ([CorporateAdviceAreasId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TCorporateAdviceAreas_CRMContactId] ON [dbo].[TCorporateAdviceAreas] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
CREATE CLUSTERED INDEX [IX_TCorporateAdviceAreas_CRMContactId] ON [dbo].[TCorporateAdviceAreas] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
