CREATE TABLE [dbo].[TAtrAnswerCombined]
(
[Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TAtrAnswerCombined_Guid] DEFAULT (newid()),
[AtrAnswerId] [int] NOT NULL,
[Description] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Ordinal] [tinyint] NOT NULL,
[Weighting] [int] NOT NULL,
[AtrQuestionGuid] [uniqueidentifier] NULL,
[IndigoClientId] [int] NOT NULL,
[IndigoClientGuid] [uniqueidentifier] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrAnswerCombined_ConcurrencyId] DEFAULT ((1)),
[msrepl_tran_version] [uniqueidentifier] NOT NULL CONSTRAINT [MSrepl_tran_version_default_DBAD5241_CC3E_4440_86BD_3280BB19CF78_162867697] DEFAULT (newid())
)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create trigger [dbo].[sp_MSsync_upd_trig_TAtrAnswerCombined_3] on [dbo].[TAtrAnswerCombined] for update not for replication as  
 declare @rc int
 select @rc = @@ROWCOUNT 

 if @rc = 0 return 
 if update (msrepl_tran_version) return 
 update [dbo].[TAtrAnswerCombined] set msrepl_tran_version = newid() from [dbo].[TAtrAnswerCombined], inserted  
     where      [dbo].[TAtrAnswerCombined].[Guid] = inserted.[Guid] 
 
GO
EXEC sp_settriggerorder N'[dbo].[sp_MSsync_upd_trig_TAtrAnswerCombined_3]', 'first', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create trigger [dbo].[sp_MSsync_upd_trig_TAtrAnswerCombined_4] on [dbo].[TAtrAnswerCombined] for update not for replication as  
 declare @rc int
 select @rc = @@ROWCOUNT 

 if @rc = 0 return 
 if update (msrepl_tran_version) return 
 update [dbo].[TAtrAnswerCombined] set msrepl_tran_version = newid() from [dbo].[TAtrAnswerCombined], inserted  
     where      [dbo].[TAtrAnswerCombined].[Guid] = inserted.[Guid] 
 
GO
ALTER TABLE [dbo].[TAtrAnswerCombined] ADD CONSTRAINT [PK_TAtrAnswerCombined] PRIMARY KEY NONCLUSTERED  ([Guid]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TAtrAnswerCombined_AtrQuestionGuid] ON [dbo].[TAtrAnswerCombined] ([AtrQuestionGuid]) WITH (FILLFACTOR=80)
GO
