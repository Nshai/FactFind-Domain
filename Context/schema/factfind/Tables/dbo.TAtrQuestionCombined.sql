CREATE TABLE [dbo].[TAtrQuestionCombined]
(
[Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TAtrQuestionCombined_Guid] DEFAULT (newid()),
[AtrQuestionId] [int] NOT NULL,
[Description] [varchar] (500) COLLATE Latin1_General_CI_AS NOT NULL,
[Ordinal] [tinyint] NOT NULL,
[Investment] [bit] NOT NULL CONSTRAINT [DF_TAtrQuestionCombined_Investment] DEFAULT ((0)),
[Retirement] [bit] NOT NULL CONSTRAINT [DF_TAtrQuestionCombined_Retirement] DEFAULT ((0)),
[Active] [bit] NOT NULL CONSTRAINT [DF_TAtrQuestionCombined_Active] DEFAULT ((0)),
[AtrTemplateGuid] [uniqueidentifier] NULL,
[IndigoClientId] [int] NOT NULL,
[IndigoClientGuid] [uniqueidentifier] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrQuestionCombined_ConcurrencyId] DEFAULT ((1)),
[msrepl_tran_version] [uniqueidentifier] NOT NULL CONSTRAINT [MSrepl_tran_version_default_38EADF69_007A_4D36_9035_22EB335B6A9C_966346557] DEFAULT (newid())
)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create trigger [dbo].[sp_MSsync_upd_trig_TAtrQuestionCombined_3] on [dbo].[TAtrQuestionCombined] for update not for replication as  
 declare @rc int
 select @rc = @@ROWCOUNT 

 if @rc = 0 return 
 if update (msrepl_tran_version) return 
 update [dbo].[TAtrQuestionCombined] set msrepl_tran_version = newid() from [dbo].[TAtrQuestionCombined], inserted  
     where      [dbo].[TAtrQuestionCombined].[Guid] = inserted.[Guid] 
 
GO
EXEC sp_settriggerorder N'[dbo].[sp_MSsync_upd_trig_TAtrQuestionCombined_3]', 'first', 'update', null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create trigger [dbo].[sp_MSsync_upd_trig_TAtrQuestionCombined_4] on [dbo].[TAtrQuestionCombined] for update not for replication as  
 declare @rc int
 select @rc = @@ROWCOUNT 

 if @rc = 0 return 
 if update (msrepl_tran_version) return 
 update [dbo].[TAtrQuestionCombined] set msrepl_tran_version = newid() from [dbo].[TAtrQuestionCombined], inserted  
     where      [dbo].[TAtrQuestionCombined].[Guid] = inserted.[Guid] 
 
GO
ALTER TABLE [dbo].[TAtrQuestionCombined] ADD CONSTRAINT [PK_TAtrQuestionCombined] PRIMARY KEY NONCLUSTERED  ([Guid]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TAtrQuestionCombined_AtrTemplateGuid] ON [dbo].[TAtrQuestionCombined] ([AtrTemplateGuid]) WITH (FILLFACTOR=80)
GO
