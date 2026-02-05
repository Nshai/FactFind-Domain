CREATE TABLE [dbo].[TPersonExt]
(
[PersonExtId] [int] NOT NULL IDENTITY(1, 1),
[PersonId] [int] NOT NULL,
[HealthNotes] [varchar] (5000)  NULL,
[MedicalConditionNotes] [varchar] (5000)  NULL,
[HasOtherConsiderations] [bit] NULL,
[OtherConsiderationsNotes] [varchar](500) NULL
)
GO
ALTER TABLE [dbo].[TPersonExt] ADD CONSTRAINT [PK_TPersonExt] PRIMARY KEY NONCLUSTERED  ([PersonExtId]) 
GO
ALTER TABLE [dbo].[TPersonExt] WITH CHECK ADD CONSTRAINT [FK_TPersonExt_TPerson] FOREIGN KEY ([PersonId]) REFERENCES [dbo].[TPerson] ([PersonId])
GO
CREATE NONCLUSTERED INDEX IX_TPersonExt_PersonId ON [dbo].[TPersonExt] ([PersonId]) INCLUDE ([HealthNotes],[MedicalConditionNotes]) 
GO
