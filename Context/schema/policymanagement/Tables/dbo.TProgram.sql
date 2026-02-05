CREATE TABLE [dbo].[TProgram]
(
[ProgramId] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NOT NULL,
[Name] [varchar] (50) NOT NULL,
[CreatedBy] [int] NOT NULL,
[CreatedAt] [datetime] NOT NULL,
[ModifiedBy] [int] NULL,
[ModifiedAt] [datetime] NULL,
[DoesAllowTrading] [bit] NOT NULL CONSTRAINT [DF_TProgram_DoesAllowTrading] Default(0),
[Status] [nvarchar] (50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_TProgram_Status] DEFAULT (N'Draft'),
[Description] [nvarchar] (1000) NULL
)
GO
ALTER TABLE [dbo].[TProgram] ADD CONSTRAINT [PK_TProgram_ProgramId] PRIMARY KEY NONCLUSTERED ([ProgramId])
GO
ALTER TABLE [dbo].[TProgram] ADD CONSTRAINT [UQ_TenantId_Name] UNIQUE ([TenantId], [Name])
GO
CREATE NONCLUSTERED INDEX [IDX_TProgram_TenantId] ON [dbo].[TProgram] ([TenantId])
GO