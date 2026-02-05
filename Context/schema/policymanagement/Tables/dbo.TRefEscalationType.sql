CREATE TABLE [dbo].[TRefEscalationType]
(
[RefEscalationTypeId] [int] NOT NULL IDENTITY(1, 1),
[EscalationType] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[RetireFg] [bit] NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TRefEscalationType] ADD CONSTRAINT [PK_TRefEscalationType] PRIMARY KEY CLUSTERED  ([RefEscalationTypeId])
GO