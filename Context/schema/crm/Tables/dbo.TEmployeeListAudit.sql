CREATE TABLE [dbo].[TEmployeeListAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RecordId] [int] NOT NULL,
[PractitionerUsername] [varchar] (60) COLLATE Latin1_General_CI_AS NOT NULL,
[Surname] [varchar] (60) COLLATE Latin1_General_CI_AS NOT NULL,
[Forename] [varchar] (60) COLLATE Latin1_General_CI_AS NOT NULL,
[DOB] [datetime] NOT NULL,
[NiNumber] [varchar] (20) COLLATE Latin1_General_CI_AS NULL,
[Department] [varchar] (60) COLLATE Latin1_General_CI_AS NULL,
[GatewayId] [int] NOT NULL,
[DuplicateFG] [bit] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[EmployeeListId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TEmployeeListAudit_EmployeeListId_ConcurrencyId] ON [dbo].[TEmployeeListAudit] ([EmployeeListId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
