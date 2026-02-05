SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomUpdateApplicationLinkLicenceCount]  
 @ApplicationName varchar(50),@IndigoClientId bigint,@MaxLicenceCount bigint,@StampUser varchar(255)
AS  
  
DECLARE @ApplicationLinkId bigint  
SET @ApplicationLinkId=(SELECT ApplicationLinkId FROM PolicyManagement..TApplicationLink A JOIN PolicyManagement..TRefApplication B ON A.RefApplicationId=B.RefApplicationId WHERE A.IndigoClientId=@IndigoClientId AND B.ApplicationName=@ApplicationName)
IF ISNULL(@ApplicationLinkId,0)!=0
BEGIN
	EXEC PolicyManagement..SpNAuditApplicationLink @StampUser,@ApplicationLinkId,'U'

	UPDATE PolicyManagement..TApplicationLink
	SET MaxLicenceCount=@MaxLicenceCount
	WHERE ApplicationLinkId=@ApplicationLinkId

END
GO
