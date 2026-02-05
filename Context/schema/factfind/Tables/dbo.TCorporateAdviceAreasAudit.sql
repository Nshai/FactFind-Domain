CREATE TABLE [dbo].[TCorporateAdviceAreasAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[advicetype] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[PA] [bit] NULL,
[RPA] [bit] NULL,
[SIA] [bit] NULL,
[CRMContactId] [int] NOT NULL,
[DateOfFirstAppointment] [datetime] NULL,
[CorporateAdviceAreasId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TCorporateAdviceAreasAudit__ConcurrencyId] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TCorporateAdviceAreasAudit] ADD CONSTRAINT [PK_TCorporateAdviceAreasAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TCorporateAdviceAreasAudit_CorporateAdviceAreasId_ConcurrencyId] ON [dbo].[TCorporateAdviceAreasAudit] ([CorporateAdviceAreasId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
