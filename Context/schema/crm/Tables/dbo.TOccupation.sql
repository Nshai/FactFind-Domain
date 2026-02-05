CREATE TABLE [dbo].[TOccupation]
(
[OccupationId] [int] NOT NULL IDENTITY(1, 1),
[Occupation] [varchar] (32)  NOT NULL,
[Employer] [varchar] (32)  NULL,
[EmployerAddress] [varchar] (128)  NULL,
[Telephone] [varchar] (32)  NULL,
[Properties] [int] NULL,
[CrmContactId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_Occupation_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TOccupation] ADD CONSTRAINT [PK_TOccupation_OccupationId] PRIMARY KEY CLUSTERED  ([OccupationId])
GO
ALTER TABLE [dbo].[TOccupation] WITH CHECK ADD CONSTRAINT [FK_TOccupation_CrmContactId_CrmContactId] FOREIGN KEY ([CrmContactId]) REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
