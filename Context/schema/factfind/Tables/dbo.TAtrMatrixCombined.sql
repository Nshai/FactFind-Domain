CREATE TABLE [dbo].[TAtrMatrixCombined]
(
[Guid] [uniqueidentifier] NOT NULL,
[AtrMatrixId] [int] NOT NULL,
[ImmediateIncome] [bit] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[IndigoClientGuid] [uniqueidentifier] NOT NULL,
[RiskProfileGuid] [uniqueidentifier] NOT NULL,
[AtrPortfolioGuid] [uniqueidentifier] NOT NULL,
[AtrTemplateGuid] [uniqueidentifier] NOT NULL,
[AtrMatrixTermGuid] [uniqueidentifier] NULL,
[ConcurrencyId] [int] NOT NULL,
[msrepl_tran_version] [uniqueidentifier] NOT NULL CONSTRAINT [MSrepl_tran_version_default_188FDE7A_98EC_4007_AB44_9459CF055652_1665545117] DEFAULT (newid())
)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create trigger [dbo].[sp_MSsync_upd_trig_TAtrMatrixCombined_4] on [dbo].[TAtrMatrixCombined] for update not for replication as  
 declare @rc int
 select @rc = @@ROWCOUNT 

 if @rc = 0 return 
 if update (msrepl_tran_version) return 
 update [dbo].[TAtrMatrixCombined] set msrepl_tran_version = newid() from [dbo].[TAtrMatrixCombined], inserted  
     where      [dbo].[TAtrMatrixCombined].[Guid] = inserted.[Guid] 
 
GO
EXEC sp_settriggerorder N'[dbo].[sp_MSsync_upd_trig_TAtrMatrixCombined_4]', 'first', 'update', null
GO
ALTER TABLE [dbo].[TAtrMatrixCombined] ADD CONSTRAINT [PK_TAtrMatrixCombined] PRIMARY KEY NONCLUSTERED  ([Guid])
GO
