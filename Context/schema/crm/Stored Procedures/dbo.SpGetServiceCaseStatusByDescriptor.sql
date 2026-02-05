USE [crm]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SpGetServiceCaseStatusByDescriptor]

@TenantId bigint,
@StatusDescriptor varchar(255)
AS

BEGIN
  SELECT
	   [StatusId] = [AdviceCaseStatusId]
      ,[Descriptor]
      ,[IsDefault]
      ,[IsComplete]
      ,[IsAutoClose]
  FROM TAdviceCaseStatus 

  WHERE TenantId = @TenantId AND Descriptor = @StatusDescriptor	

END
RETURN (0)
