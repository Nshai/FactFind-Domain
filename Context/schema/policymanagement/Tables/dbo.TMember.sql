CREATE TABLE [dbo].[TMember]
(
[MemberId] [int] NOT NULL IDENTITY(1, 1),
[PolicyBusinessId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TMember_ConcurrencyId] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TMember] ADD CONSTRAINT [PK_TMember] PRIMARY KEY CLUSTERED  ([MemberId])
GO
