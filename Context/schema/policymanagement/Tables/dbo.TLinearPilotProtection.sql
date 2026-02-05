CREATE TABLE [dbo].[TLinearPilotProtection]
(
[LinearPilotProtectionId] [int] NOT NULL IDENTITY(1, 1),
[PolicyBusinessId] [int] NULL,
[WaiverDeferedFg] [bit] NULL,
[IndexationFg] [bit] NULL,
[ConcurrencyId] [int] NULL
)
GO
ALTER TABLE [dbo].[TLinearPilotProtection] ADD CONSTRAINT [PK_TLinearPilotProtection] PRIMARY KEY CLUSTERED  ([LinearPilotProtectionId])
GO
