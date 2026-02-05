CREATE TABLE [dbo].[TAppointmentCategories]
(
[AppointmentCategoriesId] [int] NOT NULL IDENTITY(1, 1),
[AppointmentId] [int] NOT NULL,
[RefCategoryAMId] [int] NOT NULL,
[ArchiveFG] [bit] NOT NULL CONSTRAINT [DF_TAppointme_ArchiveFG_1__51] DEFAULT ((0)),
[IndClientId] [int] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAppointme_ConcurrencyId_3__51] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAppointmentCategories] ADD CONSTRAINT [PK_TAppointmentCategories_4__51] PRIMARY KEY NONCLUSTERED  ([AppointmentCategoriesId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TAppointmentCategories_AppointmentId] ON [dbo].[TAppointmentCategories] ([AppointmentId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TAppointmentCategories_RefCategoryAMId] ON [dbo].[TAppointmentCategories] ([RefCategoryAMId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TAppointmentCategories] ADD CONSTRAINT [FK_TAppointmentCategories_AppointmentId_AppointmentId] FOREIGN KEY ([AppointmentId]) REFERENCES [dbo].[TAppointment] ([AppointmentId])
GO
ALTER TABLE [dbo].[TAppointmentCategories] ADD CONSTRAINT [FK_TAppointmentCategories_RefCategoryAMId_RefCategoryAMId] FOREIGN KEY ([RefCategoryAMId]) REFERENCES [dbo].[TRefCategoryAM] ([RefCategoryAMId])
GO
