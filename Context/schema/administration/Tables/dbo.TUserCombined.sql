CREATE TABLE [dbo].[TUserCombined]
(
[Guid] [uniqueidentifier] NOT NULL,
[UserId] [int] NOT NULL,
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IndigoClientId] [int] NOT NULL,
[IndigoClientGuid] [uniqueidentifier] NOT NULL,
[UnipassSerialNbr] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TUserCombined_ConcurrencyId] DEFAULT ((1)),
[msrepl_tran_version] [uniqueidentifier] NOT NULL CONSTRAINT [MSrepl_tran_version_default_79312B9B_4338_45BA_A468_61BF6D13703F_1127727120] DEFAULT (newid())
)
GO
ALTER TABLE [dbo].[TUserCombined] ADD CONSTRAINT [PK_TUserCombined] PRIMARY KEY NONCLUSTERED  ([Guid])
GO
CREATE NONCLUSTERED INDEX [IDX_TUserCombined_Identifier] ON [dbo].[TUserCombined] ([Identifier])
GO
CREATE NONCLUSTERED INDEX IX_TUserCombined_UserId ON [dbo].[TUserCombined] ([UserId])
go