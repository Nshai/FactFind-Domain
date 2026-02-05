CREATE TABLE [dbo].[TContact]
(
[ContactId] [int] NOT NULL IDENTITY(1, 1),
[IndClientId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[RefContactType] [varchar] (50)  NOT NULL,
[Description] [varchar] (8000)  NULL,
[Value] [varchar] (255)  NOT NULL,
[DefaultFg] [tinyint] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TContact_ConcurrencyId] DEFAULT ((1)),
[MigrationRef] [varchar] (255)  NULL,
[FormattedPhoneNumber]  AS (case when [RefContactType]='Home' OR [RefContactType]='Pager' OR [RefContactType]='OtherFax' OR [RefContactType]='Mobile' OR [RefContactType]='AlternativeHome' OR [RefContactType]='Fax' OR [RefContactType]='Telephone' OR [RefContactType]='BusinessFax' OR [RefContactType]='Business2' OR [RefContactType]='Business' then case when len(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace([Value],'-',''),'(',''),')',''),'+',''),'_',''),'.',''),'/',''),':',''),char((39)),''),'?',''),'*',''),'@',''),']',''),'&',''),'#',''),'|',''),' ',''),'"',''),'!',''),'=',''),'`',''),'>',''),'<',''),',',''),';',''),'\',''),'~',''),'$',''),'{',''),'}',''),'',''),'?',''),'^',''),'%',''),'[',''),'a',''),'b',''),'c',''),'d',''),'e',''),'f',''),'g',''),'h',''),'j',''),'k',''),'l',''),'m',''),'n',''),'o',''),'p',''),'q',''),'r',''),'s',''),'t',''),'u',''),'v',''),'w',''),'x',''),'y',''),'z',''),char((105)),''),char((11)),''),char((10)),''),char((9)),''),char((183)),''),char((160)),''),char((129)),''),char((1)),''),char((225)),''),char((250)),''),char((223)),''))>=(7) then right(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace([Value],'-',''),'(',''),')',''),'+',''),'_',''),'.',''),'/',''),':',''),char((39)),''),'?',''),'*',''),'@',''),']',''),'&',''),'#',''),'|',''),' ',''),'"',''),'!',''),'=',''),'`',''),'>',''),'<',''),',',''),';',''),'\',''),'~',''),'$',''),'{',''),'}',''),'',''),'?',''),'^',''),'%',''),'[',''),'a',''),'b',''),'c',''),'d',''),'e',''),'f',''),'g',''),'h',''),'j',''),'k',''),'l',''),'m',''),'n',''),'o',''),'p',''),'q',''),'r',''),'s',''),'t',''),'u',''),'v',''),'w',''),'x',''),'y',''),'z',''),char((105)),''),char((11)),''),char((10)),''),char((9)),''),char((183)),''),char((160)),''),char((129)),''),char((1)),''),char((225)),''),char((250)),''),char((223)),''),(7))  end  end) PERSISTED,
[CreatedOn] [datetime] NULL CONSTRAINT [DF_TContact_CreatedOn] DEFAULT (getdate()),
[CreatedByUserId] [int] NULL,
[UpdatedOn] [datetime] NULL CONSTRAINT [DF_TContact_UpdatedOn] DEFAULT (getdate()),
[UpdatedByUserId] [int] NULL
)
GO
ALTER TABLE [dbo].[TContact] ADD CONSTRAINT [PK_TContact] PRIMARY KEY CLUSTERED  ([ContactId])
GO
CREATE NONCLUSTERED INDEX [IDX_TContact_CRMContactId] ON [dbo].[TContact] ([CRMContactId])
GO
CREATE NONCLUSTERED INDEX [IX_TContact_CRMContactID_Value_DefaultFG_RefContactType] ON [dbo].[TContact] ([CRMContactId], [ContactId], [Value], [RefContactType])
GO
CREATE NONCLUSTERED INDEX [IX_TContact_IndigoClientId_MigrationRef] ON [dbo].[TContact] ([IndClientId], [MigrationRef], [RefContactType])
GO
CREATE NONCLUSTERED INDEX [IX_Tcontact_Value] ON [dbo].[TContact] ([Value]) INCLUDE ([CRMContactId], [RefContactType])
GO
CREATE NONCLUSTERED INDEX [IX_TContact_IndigoClientId_FormattedPhoneNumber] ON [dbo].[TContact] ([IndClientId], [FormattedPhoneNumber]) INCLUDE ([CRMContactId])
GO
ALTER TABLE [dbo].[TContact] WITH CHECK ADD CONSTRAINT [FK_TContact_CRMContactId_CRMContactId] FOREIGN KEY ([CRMContactId]) REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
