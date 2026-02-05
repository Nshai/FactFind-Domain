SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE  PROCEDURE [dbo].[nio_SpCustomCreateEmailApplicationLink]
@IndigoClientId bigint = 0
AS

Declare @ApplicationLinkId bigint
Declare @RefApplicationId bigint

select @RefApplicationId = RefApplicationId from TRefApplication 
where ApplicationShortName = 'EM' and RefApplicationTypeId = 4

if not exists
(select 1 from PolicyManagement..TApplicationLink where IndigoClientId = @IndigoClientId 
And RefApplicationId = @RefApplicationId)
begin

Insert Into PolicyManagement..TApplicationLink
            (IndigoClientId, RefApplicationId, MaxLicenceCount, CurrentLicenceCount,AllowAccess, ExtranetURL)
	 Values (@IndigoClientId, @RefApplicationId, Null, Null, 0, Null)

Select @ApplicationLinkId = SCOPE_IDENTITY()

Insert Into PolicyManagement..TApplicationLinkAudit
(IndigoClientId, RefApplicationId, MaxLicenceCount, CurrentLicenceCount,AllowAccess, ExtranetURL, ConcurrencyId, ApplicationLinkId, StampAction,StampDateTime, StampUser)

Values (@IndigoClientId, @RefApplicationId, Null, Null, 0, Null, 1, @ApplicationLinkId, 'C', getdate(), '0')

end
GO
