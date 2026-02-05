SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[spCustomCRMContactUpdateCurrentAdviser] @AdviserCRMContactId bigint, @AdviserName varchar(255)
as

-- update CRMContact Record

Update TCRMContact set CurrentAdviserName=@AdviserName where CurrentAdviserCRMId=@AdviserCRMContactId

GO
